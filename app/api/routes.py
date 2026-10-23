from __future__ import annotations

from datetime import datetime
from typing import Any, Optional

from fastapi import APIRouter, BackgroundTasks, Query
from sqlalchemy import func, select
from sqlalchemy.orm import joinedload

from app.db.models import Exchange, ParseRun, Trade
from app.db.repository import query_trades
from app.db.session import get_session
from app.parsers.runner import run_parsers

router = APIRouter()


def _trade_to_dict(t: Trade) -> dict[str, Any]:
    return {
        "id": t.id,
        "trade_date": t.trade_date.isoformat() if t.trade_date else None,
        "trade_time": t.trade_time,
        "exchange": t.exchange.name if t.exchange else None,
        "exchange_code": t.exchange.code if t.exchange else None,
        "product_name": t.product.name if t.product else None,
        "product_code": t.product.product_code if t.product else None,
        "tnved_code": t.product.tnved_code if t.product else None,
        "seller_name": t.seller.name if t.seller else None,
        "seller_bin": t.seller.bin if t.seller else None,
        "buyer_name": t.buyer.name if t.buyer else None,
        "buyer_bin": t.buyer.bin if t.buyer else None,
        "seller_broker": t.seller_broker.name if t.seller_broker else None,
        "buyer_broker": t.buyer_broker.name if t.buyer_broker else None,
        "volume": t.volume,
        "unit": t.unit,
        "price": t.price,
        "price_vat": t.price_vat,
        "amount": t.amount,
        "delivery_place": t.delivery_place,
        "delivery_term": t.delivery_term,
        "deals_count": t.deals_count,
    }


@router.get("/api/trades")
def api_trades(
    exchange: Optional[str] = Query(None),
    date_from: Optional[str] = Query(None),
    date_to: Optional[str] = Query(None),
    product: Optional[str] = Query(None),
    participant: Optional[str] = Query(None),
    broker: Optional[str] = Query(None),
    amount_min: Optional[float] = Query(None),
    amount_max: Optional[float] = Query(None),
    delivery: Optional[str] = Query(None),
    sort_by: str = Query("trade_date"),
    sort_dir: str = Query("desc"),
    page: int = Query(1, ge=1),
    per_page: int = Query(50, ge=1, le=200),
) -> dict[str, Any]:
    with get_session() as session:
        rows, total = query_trades(
            session,
            exchange=exchange,
            date_from=date_from,
            date_to=date_to,
            product=product,
            participant=participant,
            broker=broker,
            amount_min=amount_min,
            amount_max=amount_max,
            delivery=delivery,
            sort_by=sort_by,
            sort_dir=sort_dir,
            page=page,
            per_page=per_page,
        )
        return {
            "items": [_trade_to_dict(t) for t in rows],
            "total": total,
            "page": page,
            "per_page": per_page,
            "pages": max(1, (total + per_page - 1) // per_page),
        }


@router.get("/api/status")
def api_status() -> dict[str, Any]:
    with get_session() as session:
        total = session.scalar(select(func.count(Trade.id))) or 0
        by_exchange = []
        exchanges = session.scalars(select(Exchange)).all()
        for ex in exchanges:
            cnt = session.scalar(
                select(func.count(Trade.id)).where(Trade.exchange_id == ex.id)
            ) or 0
            last_date = session.scalar(
                select(func.max(Trade.trade_date)).where(Trade.exchange_id == ex.id)
            )
            last_created = session.scalar(
                select(func.max(Trade.created_at)).where(Trade.exchange_id == ex.id)
            )
            by_exchange.append(
                {
                    "code": ex.code,
                    "name": ex.name,
                    "count": cnt,
                    "last_trade_date": last_date.isoformat() if last_date else None,
                    "last_updated_at": last_created.isoformat() if last_created else None,
                }
            )
        last_runs = session.scalars(
            select(ParseRun).order_by(ParseRun.started_at.desc()).limit(10)
        ).all()
        return {
            "total_trades": total,
            "exchanges": by_exchange,
            "last_runs": [
                {
                    "id": r.id,
                    "source": r.source,
                    "mode": r.mode,
                    "status": r.status,
                    "started_at": r.started_at.isoformat() if r.started_at else None,
                    "finished_at": r.finished_at.isoformat() if r.finished_at else None,
                    "records_added": r.records_added,
                    "records_seen": r.records_seen,
                    "error_text": r.error_text,
                }
                for r in last_runs
            ],
            "server_time": datetime.utcnow().isoformat() + "Z",
        }


@router.post("/api/parse")
def api_parse(
    background_tasks: BackgroundTasks,
    source: str = Query("all"),
    mode: str = Query("incremental"),
) -> dict[str, Any]:
    """Ручной запуск парсера (в фоне). Портал сам на биржи не ходит — только этот endpoint."""

    def _task() -> None:
        run_parsers(sources=source, mode=mode)

    background_tasks.add_task(_task)
    return {"ok": True, "message": "Парсинг запущен в фоне", "source": source, "mode": mode}
