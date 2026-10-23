from __future__ import annotations

import logging
from typing import Optional

from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger

from app import config
from app.parsers.runner import run_parsers

log = logging.getLogger(__name__)
_scheduler: Optional[BackgroundScheduler] = None


def _job() -> None:
    log.info("Scheduled parse started (cron=%s)", config.SCHEDULER_CRON)
    try:
        result = run_parsers(sources="all", mode="incremental")
        log.info("Scheduled parse finished: %s", result.get("status"))
    except Exception:  # noqa: BLE001
        log.exception("Scheduled parse failed")


def start_scheduler() -> Optional[BackgroundScheduler]:
    global _scheduler
    if not config.SCHEDULER_ENABLED:
        log.info("Scheduler disabled by config")
        return None
    if _scheduler and _scheduler.running:
        return _scheduler
    parts = config.SCHEDULER_CRON.split()
    if len(parts) != 5:
        log.error("Invalid cron expression: %s", config.SCHEDULER_CRON)
        return None
    minute, hour, day, month, day_of_week = parts
    trigger = CronTrigger(
        minute=minute,
        hour=hour,
        day=day,
        month=month,
        day_of_week=day_of_week,
        timezone=config.SCHEDULER_TZ,
    )
    _scheduler = BackgroundScheduler(timezone=config.SCHEDULER_TZ)
    _scheduler.add_job(_job, trigger=trigger, id="daily_parse", replace_existing=True)
    _scheduler.start()
    log.info("Scheduler started: %s (%s)", config.SCHEDULER_CRON, config.SCHEDULER_TZ)
    return _scheduler


def stop_scheduler() -> None:
    global _scheduler
    if _scheduler and _scheduler.running:
        _scheduler.shutdown(wait=False)
        log.info("Scheduler stopped")
    _scheduler = None
