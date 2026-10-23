from __future__ import annotations

import os
from pathlib import Path
from typing import Any

import yaml
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parent.parent
load_dotenv(ROOT / ".env")


def _load_yaml() -> dict[str, Any]:
    path = ROOT / "config.yaml"
    if not path.exists():
        return {}
    with path.open(encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


_CFG = _load_yaml()


def get(path: str, default: Any = None) -> Any:
    node: Any = _CFG
    for part in path.split("."):
        if not isinstance(node, dict) or part not in node:
            return default
        node = node[part]
    return node


DATABASE_URL = os.getenv("DATABASE_URL") or get("database_url", "sqlite:///data/trades.db")
if DATABASE_URL.startswith("sqlite:///") and not DATABASE_URL.startswith("sqlite:////"):
    rel = DATABASE_URL.replace("sqlite:///", "", 1)
    DATABASE_URL = f"sqlite:///{(ROOT / rel).as_posix()}"

USER_AGENT = os.getenv("USER_AGENT") or get("http.user_agent", "TradeResultsStudentBot/1.0")
HTTP_TIMEOUT = float(os.getenv("HTTP_TIMEOUT") or get("http.timeout_sec", 45))
REQUEST_DELAY = float(os.getenv("REQUEST_DELAY_SEC") or get("http.request_delay_sec", 1.0))
MAX_RETRIES = int(os.getenv("MAX_RETRIES") or get("http.max_retries", 3))

ETS_CATALOG_URL = get("ets.catalog_url", "https://ets.kz/documents/trading-results/")
ETS_BASE_URL = get("ets.base_url", "https://ets.kz")
ETS_INCREMENTAL_MONTHS = int(get("ets.incremental_months", 2))

CASPIAN_RESULTS_URL = get(
    "caspian.results_url",
    "https://ccx.kz/trading-and-analytics/trading-results",
)
CASPIAN_LANG = get("caspian.lang", "ru")
CASPIAN_PER_PAGE = int(get("caspian.per_page", 100))
CASPIAN_INCREMENTAL_DAYS = int(get("caspian.incremental_days", 14))

SCHEDULER_ENABLED = (
    os.getenv("SCHEDULER_ENABLED", str(get("scheduler.enabled", True))).lower()
    in ("1", "true", "yes")
)
SCHEDULER_CRON = os.getenv("SCHEDULER_CRON") or get("scheduler.cron", "30 6 * * *")
SCHEDULER_TZ = get("scheduler.timezone", "Asia/Almaty")

LOG_LEVEL = os.getenv("LOG_LEVEL") or get("logging.level", "INFO")
LOG_FILE = ROOT / (os.getenv("LOG_FILE") or get("logging.file", "logs/app.log"))

HOST = os.getenv("HOST", "127.0.0.1")
PORT = int(os.getenv("PORT", "8000"))

DATA_DIR = ROOT / "data"
LOGS_DIR = ROOT / "logs"
SQL_SCHEMA = ROOT / "sql" / "schema.sql"
