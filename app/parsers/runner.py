from __future__ import annotations

import logging
from datetime import date, datetime
from typing import Optional

from app.db.models import ParseRun
from app.db.repository import TradeRepository
from app.db.session import get_session, init_db
from app.parsers.caspian import CaspianParser
from app.parsers.ets import EtsParser
from app.parsers.http_client import HttpClient

log = logging.getLogger(__name__)


def run_parsers(
    sources: str = "all",
    mode: str = "incremental",
    date_from: Optional[date] = None,
    date_to: Optional[date] = None,
) -> dict:
    """
    sources: ets | caspian | all
    mode: incremental | full
    """
    init_db()
    sources = sources.lower().strip()
    client = HttpClient()
    summary = {
        "started_at": datetime.utcnow().isoformat(),
        "sources": sources,
        "mode": mode,
        "results": {},
        "total_added": 0,
        "total_seen": 0,
        "status": "success",
    }
    errors: list[str] = []

    to_run: list[tuple[str, object]] = []
    if sources in ("all", "ets"):
        to_run.append(("ets", EtsParser(client)))
    if sources in ("all", "caspian", "ccx", "каспий"):
        to_run.append(("caspian", CaspianParser(client)))

    for name, parser in to_run:
        started = datetime.utcnow()
        added = seen = 0
        status = "success"
        err_text = None
        try:
            items = parser.parse(mode=mode, date_from=date_from, date_to=date_to)
            with get_session() as session:
                repo = TradeRepository(session)
                added, seen = repo.save_many(items)
                if seen == 0:
                    status = "partial"
                    err_text = "Нет строк (источник пуст или недоступен)"
                session.add(
                    ParseRun(
                        source=name,
                        started_at=started,
                        finished_at=datetime.utcnow(),
                        mode=mode,
                        status=status,
                        records_added=added,
                        records_seen=seen,
                        error_text=err_text,
                    )
                )
            log.info("%s done: added=%s seen=%s", name, added, seen)
        except Exception as exc:  # noqa: BLE001
            status = "fail"
            err_text = str(exc)
            errors.append(f"{name}: {exc}")
            log.exception("Parser %s failed", name)
            try:
                with get_session() as session:
                    session.add(
                        ParseRun(
                            source=name,
                            started_at=started,
                            finished_at=datetime.utcnow(),
                            mode=mode,
                            status=status,
                            records_added=added,
                            records_seen=seen,
                            error_text=err_text,
                        )
                    )
            except Exception:  # noqa: BLE001
                log.exception("Failed to write parse_runs journal")

        summary["results"][name] = {
            "status": status,
            "added": added,
            "seen": seen,
            "error": err_text,
        }
        summary["total_added"] += added
        summary["total_seen"] += seen

    if errors:
        summary["status"] = "fail" if len(errors) == len(to_run) else "partial"
        summary["errors"] = errors
    summary["finished_at"] = datetime.utcnow().isoformat()
    return summary
