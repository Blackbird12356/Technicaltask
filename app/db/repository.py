from __future__ import annotations

import logging
from datetime import datetime
from typing import Optional

from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session, aliased, joinedload

from app.db.models import Broker, Exchange, ParseRun, Participant, Product, Trade
from app.parsers.normalize import NormalizedTrade, normalize_name

log = logging.getLogger(__name__)


class TradeRepository:
    def __init__(self, session: Session) -> None:
        self.session = session
        self._exchange_cache: dict[str, int] = {}

    def get_exchange_id(self, code: str) -> int:
        if code in self._exchange_cache:
            return self._exchange_cache[code]
        row = self.session.scalar(select(Exchange).where(Exchange.code == code))
        if row is None:
            raise RuntimeError(f"Биржа не найдена в справочнике: {code}")
        self._exchange_cache[code] = row.id
        return row.id

    def _get_or_create_product(
        self,
        name: Optional[str],
        product_code: Optional[str],
        tnved: Optional[str],
    ) -> Optional[int]:
        if not name and not product_code:
            return None
        name_norm = normalize_name(name) or ""
        q = select(Product)
        if product_code:
            q = q.where(Product.product_code == product_code)
            if name_norm:
                q = q.where(Product.name_norm == name_norm)
        else:
            q = q.where(Product.name_norm == name_norm)
            if tnved:
                q = q.where(Product.tnved_code == tnved)
        existing = self.session.scalar(q.limit(1))
        if existing:
            return existing.id
        obj = Product(
            name=name or product_code or "Без названия",
            product_code=product_code,
            tnved_code=tnved,
            name_norm=name_norm or normalize_name(product_code) or "",
        )
        self.session.add(obj)
        self.session.flush()
        return obj.id

    def _get_or_create_participant(
        self, name: Optional[str], bin_code: Optional[str]
    ) -> Optional[int]:
        if not name and not bin_code:
            return None
        if bin_code:
            existing = self.session.scalar(
                select(Participant).where(Participant.bin == bin_code).limit(1)
            )
            if existing:
                return existing.id
        name_norm = normalize_name(name) or ""
        if name_norm and not bin_code:
            existing = self.session.scalar(
                select(Participant)
                .where(Participant.name_norm == name_norm)
                .where(or_(Participant.bin.is_(None), Participant.bin == ""))
                .limit(1)
            )
            if existing:
                return existing.id
        obj = Participant(
            name=name or bin_code or "Неизвестно",
            bin=bin_code,
            name_norm=name_norm or bin_code or "",
        )
        self.session.add(obj)
        self.session.flush()
        return obj.id

    def _get_or_create_broker(self, name: Optional[str]) -> Optional[int]:
        if not name:
            return None
        name_norm = normalize_name(name)
        if not name_norm:
            return None
        existing = self.session.scalar(
            select(Broker).where(Broker.name_norm == name_norm).limit(1)
        )
        if existing:
            return existing.id
        obj = Broker(name=name, name_norm=name_norm)
        self.session.add(obj)
        self.session.flush()
        return obj.id

    def upsert_trade(self, nt: NormalizedTrade) -> bool:
        """Возвращает True, если запись добавлена."""
        nt.finalize()
        key = nt.dedup_key()
        exists = self.session.scalar(select(Trade.id).where(Trade.dedup_key == key))
        if exists:
            return False
        trade = Trade(
            dedup_key=key,
            exchange_id=self.get_exchange_id(nt.exchange_code),
            trade_date=nt.trade_date,
            trade_time=nt.trade_time,
            product_id=self._get_or_create_product(
                nt.product_name, nt.product_code, nt.tnved_code
            ),
            seller_id=self._get_or_create_participant(nt.seller_name, nt.seller_bin),
            buyer_id=self._get_or_create_participant(nt.buyer_name, nt.buyer_bin),
            seller_broker_id=self._get_or_create_broker(nt.seller_broker),
            buyer_broker_id=self._get_or_create_broker(nt.buyer_broker),
            volume=nt.volume,
            unit=nt.unit,
            price=nt.price,
            price_vat=nt.price_vat,
            amount=nt.amount,
            delivery_place=nt.delivery_place,
            delivery_term=nt.delivery_term,
            deals_count=nt.deals_count,
            source_url=nt.source_url,
            raw_hash=key,
        )
        self.session.add(trade)
        return True

    def save_many(self, items: list[NormalizedTrade]) -> tuple[int, int]:
        added = 0
        seen = 0
        batch_keys: set[str] = set()
        for item in items:
            seen += 1
            item.finalize()
            key = item.dedup_key()
            if key in batch_keys:
                continue
            batch_keys.add(key)
            if self.upsert_trade(item):
                added += 1
                # периодический flush снижает риск огромной транзакции
                if added % 50 == 0:
                    self.session.flush()
        self.session.flush()
        return added, seen


def start_parse_run(session: Session, source: str, mode: str) -> ParseRun:
    run = ParseRun(
        source=source,
        started_at=datetime.utcnow(),
        mode=mode,
        status="running",
        records_added=0,
        records_seen=0,
    )
    session.add(run)
    session.flush()
    return run


def finish_parse_run(
    session: Session,
    run: ParseRun,
    *,
    status: str,
    added: int,
    seen: int,
    error: Optional[str] = None,
) -> None:
    run.finished_at = datetime.utcnow()
    run.status = status
    run.records_added = added
    run.records_seen = seen
    run.error_text = error
    session.flush()


def query_trades(
    session: Session,
    *,
    exchange: Optional[str] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    product: Optional[str] = None,
    participant: Optional[str] = None,
    broker: Optional[str] = None,
    amount_min: Optional[float] = None,
    amount_max: Optional[float] = None,
    delivery: Optional[str] = None,
    sort_by: str = "trade_date",
    sort_dir: str = "desc",
    page: int = 1,
    per_page: int = 50,
) -> tuple[list[Trade], int]:
    q = (
        select(Trade)
        .options(
            joinedload(Trade.exchange),
            joinedload(Trade.product),
            joinedload(Trade.seller),
            joinedload(Trade.buyer),
            joinedload(Trade.seller_broker),
            joinedload(Trade.buyer_broker),
        )
        .join(Trade.exchange)
    )
    count_q = select(func.count(Trade.id)).select_from(Trade).join(Trade.exchange)

    if exchange and exchange.upper() not in ("ALL", "BOTH", ""):
        code = "CASPIAN" if exchange.lower() in ("caspian", "каспий", "ccx") else "ETS"
        q = q.where(Exchange.code == code)
        count_q = count_q.where(Exchange.code == code)

    if date_from:
        q = q.where(Trade.trade_date >= date_from)
        count_q = count_q.where(Trade.trade_date >= date_from)
    if date_to:
        q = q.where(Trade.trade_date <= date_to)
        count_q = count_q.where(Trade.trade_date <= date_to)

    if product:
        like = f"%{product.casefold()}%"
        raw = f"%{product}%"
        q = q.outerjoin(Trade.product).where(
            or_(
                Product.name_norm.like(like),
                Product.product_code.like(raw),
                Product.tnved_code.like(raw),
                Product.name.like(raw),
            )
        )
        count_q = count_q.outerjoin(Trade.product).where(
            or_(
                Product.name_norm.like(like),
                Product.product_code.like(raw),
                Product.tnved_code.like(raw),
                Product.name.like(raw),
            )
        )

    if participant:
        like = f"%{participant.casefold()}%"
        raw = f"%{participant}%"
        seller = aliased(Participant)
        buyer = aliased(Participant)
        q = q.outerjoin(seller, Trade.seller_id == seller.id).outerjoin(
            buyer, Trade.buyer_id == buyer.id
        )
        cond = or_(
            seller.name_norm.like(like),
            buyer.name_norm.like(like),
            seller.bin.like(raw),
            buyer.bin.like(raw),
            seller.name.like(raw),
            buyer.name.like(raw),
        )
        q = q.where(cond)
        count_q = (
            count_q.outerjoin(seller, Trade.seller_id == seller.id)
            .outerjoin(buyer, Trade.buyer_id == buyer.id)
            .where(cond)
        )

    if broker:
        like = f"%{broker.casefold()}%"
        sb = aliased(Broker)
        bb = aliased(Broker)
        q = q.outerjoin(sb, Trade.seller_broker_id == sb.id).outerjoin(
            bb, Trade.buyer_broker_id == bb.id
        )
        cond = or_(sb.name_norm.like(like), bb.name_norm.like(like))
        q = q.where(cond)
        count_q = (
            count_q.outerjoin(sb, Trade.seller_broker_id == sb.id)
            .outerjoin(bb, Trade.buyer_broker_id == bb.id)
            .where(cond)
        )

    if amount_min is not None:
        q = q.where(Trade.amount >= amount_min)
        count_q = count_q.where(Trade.amount >= amount_min)
    if amount_max is not None:
        q = q.where(Trade.amount <= amount_max)
        count_q = count_q.where(Trade.amount <= amount_max)

    if delivery:
        like = f"%{delivery}%"
        q = q.where(
            or_(
                Trade.delivery_place.like(like),
                Trade.delivery_term.like(like),
            )
        )
        count_q = count_q.where(
            or_(
                Trade.delivery_place.like(like),
                Trade.delivery_term.like(like),
            )
        )

    sort_map = {
        "trade_date": Trade.trade_date,
        "amount": Trade.amount,
        "price": Trade.price,
        "volume": Trade.volume,
        "exchange": Exchange.name,
        "product": Product.name,
    }
    col = sort_map.get(sort_by, Trade.trade_date)
    if sort_by == "product":
        q = q.outerjoin(Trade.product)
    order = col.desc() if sort_dir.lower() != "asc" else col.asc()
    # вторичная сортировка для стабильности
    q = q.order_by(order, Trade.id.desc())

    total = session.scalar(count_q) or 0
    page = max(1, page)
    per_page = min(max(1, per_page), 200)
    rows = session.scalars(q.offset((page - 1) * per_page).limit(per_page)).unique().all()
    return list(rows), int(total)
