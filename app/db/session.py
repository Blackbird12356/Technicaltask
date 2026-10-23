from __future__ import annotations

from collections.abc import Generator
from contextlib import contextmanager

from sqlalchemy import create_engine, event, text
from sqlalchemy.engine import Engine
from sqlalchemy.orm import Session, sessionmaker

from app import config
from app.db.models import Base

_engine: Engine | None = None
_SessionLocal: sessionmaker[Session] | None = None


def get_engine() -> Engine:
    global _engine, _SessionLocal
    if _engine is None:
        config.DATA_DIR.mkdir(parents=True, exist_ok=True)
        _engine = create_engine(
            config.DATABASE_URL,
            connect_args={"check_same_thread": False},
            future=True,
        )

        @event.listens_for(_engine, "connect")
        def _set_sqlite_pragma(dbapi_conn, _):  # type: ignore[no-untyped-def]
            cursor = dbapi_conn.cursor()
            cursor.execute("PRAGMA foreign_keys=ON")
            cursor.close()

        _SessionLocal = sessionmaker(bind=_engine, autoflush=False, autocommit=False)
    return _engine


def init_db() -> None:
    engine = get_engine()
    Base.metadata.create_all(bind=engine)
    # Сиды бирж + индексы из schema.sql (частично дублируются ORM)
    schema = config.SQL_SCHEMA
    if schema.exists():
        sql = schema.read_text(encoding="utf-8")
        with engine.begin() as conn:
            # Выполняем по statements, игнорируя уже существующие объекты через IF NOT EXISTS
            for stmt in _split_sql(sql):
                try:
                    conn.execute(text(stmt))
                except Exception:
                    # CREATE INDEX / INSERT OR IGNORE уже безопасны; пропускаем сбои дублей
                    pass
    else:
        with engine.begin() as conn:
            conn.execute(
                text(
                    "INSERT OR IGNORE INTO exchanges (id, code, name) VALUES "
                    "(1, 'ETS', 'ETS'), (2, 'CASPIAN', 'Каспий')"
                )
            )


def _split_sql(sql: str) -> list[str]:
    parts: list[str] = []
    buf: list[str] = []
    for line in sql.splitlines():
        stripped = line.strip()
        if stripped.startswith("--") or not stripped:
            continue
        buf.append(line)
        if stripped.endswith(";"):
            parts.append("\n".join(buf).rstrip(";").strip())
            buf = []
    if buf:
        parts.append("\n".join(buf).strip())
    return [p for p in parts if p]


@contextmanager
def get_session() -> Generator[Session, None, None]:
    get_engine()
    assert _SessionLocal is not None
    session = _SessionLocal()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()

