from __future__ import annotations

from datetime import date, datetime
from typing import Optional

from sqlalchemy import (
    Date,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship


class Base(DeclarativeBase):
    pass


class Exchange(Base):
    __tablename__ = "exchanges"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    code: Mapped[str] = mapped_column(String(32), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String(64), nullable=False)

    trades: Mapped[list["Trade"]] = relationship(back_populates="exchange")


class Product(Base):
    __tablename__ = "products"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(Text, nullable=False)
    product_code: Mapped[Optional[str]] = mapped_column(String(64))
    tnved_code: Mapped[Optional[str]] = mapped_column(String(32))
    name_norm: Mapped[str] = mapped_column(Text, nullable=False)


class Participant(Base):
    __tablename__ = "participants"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(Text, nullable=False)
    bin: Mapped[Optional[str]] = mapped_column(String(16))
    name_norm: Mapped[str] = mapped_column(Text, nullable=False)


class Broker(Base):
    __tablename__ = "brokers"
    __table_args__ = (UniqueConstraint("name_norm", name="ux_brokers_name_norm"),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(Text, nullable=False)
    name_norm: Mapped[str] = mapped_column(Text, nullable=False)


class Trade(Base):
    __tablename__ = "trades"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    dedup_key: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    exchange_id: Mapped[int] = mapped_column(ForeignKey("exchanges.id"), nullable=False)
    trade_date: Mapped[date] = mapped_column(Date, nullable=False)
    trade_time: Mapped[Optional[str]] = mapped_column(String(16))
    product_id: Mapped[Optional[int]] = mapped_column(ForeignKey("products.id"))
    seller_id: Mapped[Optional[int]] = mapped_column(ForeignKey("participants.id"))
    buyer_id: Mapped[Optional[int]] = mapped_column(ForeignKey("participants.id"))
    seller_broker_id: Mapped[Optional[int]] = mapped_column(ForeignKey("brokers.id"))
    buyer_broker_id: Mapped[Optional[int]] = mapped_column(ForeignKey("brokers.id"))
    volume: Mapped[Optional[float]] = mapped_column(Float)
    unit: Mapped[Optional[str]] = mapped_column(String(16))
    price: Mapped[Optional[float]] = mapped_column(Float)
    price_vat: Mapped[Optional[str]] = mapped_column(String(16))
    amount: Mapped[Optional[float]] = mapped_column(Float)
    delivery_place: Mapped[Optional[str]] = mapped_column(Text)
    delivery_term: Mapped[Optional[str]] = mapped_column(Text)
    deals_count: Mapped[Optional[int]] = mapped_column(Integer)
    source_url: Mapped[Optional[str]] = mapped_column(Text)
    raw_hash: Mapped[Optional[str]] = mapped_column(String(64))
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    exchange: Mapped[Exchange] = relationship(back_populates="trades")
    product: Mapped[Optional[Product]] = relationship()
    seller: Mapped[Optional[Participant]] = relationship(foreign_keys=[seller_id])
    buyer: Mapped[Optional[Participant]] = relationship(foreign_keys=[buyer_id])
    seller_broker: Mapped[Optional[Broker]] = relationship(foreign_keys=[seller_broker_id])
    buyer_broker: Mapped[Optional[Broker]] = relationship(foreign_keys=[buyer_broker_id])


class ParseRun(Base):
    __tablename__ = "parse_runs"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    source: Mapped[str] = mapped_column(String(32), nullable=False)
    started_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    finished_at: Mapped[Optional[datetime]] = mapped_column(DateTime)
    mode: Mapped[str] = mapped_column(String(32), nullable=False)
    status: Mapped[str] = mapped_column(String(16), nullable=False)
    records_added: Mapped[int] = mapped_column(Integer, default=0)
    records_seen: Mapped[int] = mapped_column(Integer, default=0)
    error_text: Mapped[Optional[str]] = mapped_column(Text)
