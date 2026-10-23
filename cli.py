#!/usr/bin/env python3
"""CLI: инициализация БД и ручной запуск парсеров."""
from __future__ import annotations

import argparse
import json
from datetime import datetime

from app.db.session import init_db
from app.logging_setup import setup_logging
from app.parsers.runner import run_parsers


def _parse_date(value: str | None):
    if not value:
        return None
    return datetime.strptime(value, "%Y-%m-%d").date()


def main() -> None:
    setup_logging()
    parser = argparse.ArgumentParser(description="Парсеры итогов торгов ETS / Каспий")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("init-db", help="Создать схему БД и справочники")

    p_run = sub.add_parser("parse", help="Запустить парсеры")
    p_run.add_argument(
        "--source",
        choices=["all", "ets", "caspian"],
        default="all",
        help="Источник данных",
    )
    p_run.add_argument(
        "--mode",
        choices=["incremental", "full"],
        default="incremental",
        help="incremental — недавний период; full — вся доступная история",
    )
    p_run.add_argument("--date-from", dest="date_from", help="YYYY-MM-DD")
    p_run.add_argument("--date-to", dest="date_to", help="YYYY-MM-DD")

    args = parser.parse_args()
    if args.command == "init-db":
        init_db()
        print("OK: база инициализирована")
        return

    if args.command == "parse":
        result = run_parsers(
            sources=args.source,
            mode=args.mode,
            date_from=_parse_date(args.date_from),
            date_to=_parse_date(args.date_to),
        )
        print(json.dumps(result, ensure_ascii=False, indent=2))
        if result.get("status") == "fail":
            raise SystemExit(1)


if __name__ == "__main__":
    main()
