from __future__ import annotations

import hashlib
import re
from dataclasses import asdict, dataclass, field
from datetime import date, datetime
from decimal import Decimal, InvalidOperation
from typing import Any, Optional

BIN_RE = re.compile(r"(?<!\d)(\d{12})(?!\d)")
BASIS_RE = re.compile(
    r"\b(EXW|FCA|FOB|CIF|CIP|CPT|DAP|DDP|DAT|DAF)\b",
    re.IGNORECASE,
)
SPACE_RE = re.compile(r"\s+")


def clean_text(value: Any) -> Optional[str]:
    if value is None:
        return None
    text = str(value).replace("\xa0", " ").replace("\u200b", "").strip()
    text = SPACE_RE.sub(" ", text)
    if not text or text in {"-", "—", "–", "null", "None"}:
        return None
    return text


def normalize_name(value: Any) -> Optional[str]:
    text = clean_text(value)
    return text.casefold() if text else None


def parse_number(value: Any) -> Optional[float]:
    if value is None or value == "":
        return None
    if isinstance(value, (int, float, Decimal)):
        return float(value)
    text = clean_text(value)
    if not text:
        return None
    text = text.replace(" ", "").replace("\u202f", "").replace(",", ".")
    # убрать всё кроме цифр, точки, минуса
    text = re.sub(r"[^0-9.\-]", "", text)
    if not text or text in {".", "-", "-."}:
        return None
    try:
        return float(Decimal(text))
    except (InvalidOperation, ValueError):
        return None


def parse_date(value: Any) -> Optional[date]:
    if value is None:
        return None
    if isinstance(value, datetime):
        return value.date()
    if isinstance(value, date):
        return value
    text = clean_text(value)
    if not text:
        return None
    for fmt in ("%d.%m.%Y", "%Y-%m-%d", "%d/%m/%Y", "%Y.%m.%d"):
        try:
            return datetime.strptime(text[:10], fmt).date()
        except ValueError:
            continue
    m = re.search(r"(\d{2})\.(\d{2})\.(\d{4})", text)
    if m:
        return date(int(m.group(3)), int(m.group(2)), int(m.group(1)))
    return None


def split_name_bin(value: Any) -> tuple[Optional[str], Optional[str]]:
    """Извлекает БИН из конца строки имени (типично для CCX)."""
    text = clean_text(value)
    if not text:
        return None, None
    matches = list(BIN_RE.finditer(text))
    if not matches:
        return text, None
    last = matches[-1]
    bin_code = last.group(1)
    name = clean_text(text[: last.start()] + text[last.end() :])
    return name or text, bin_code


def extract_delivery_from_product(product_name: Optional[str]) -> Optional[str]:
    text = clean_text(product_name)
    if not text:
        return None
    m = BASIS_RE.search(text)
    if not m:
        return None
    # берём базис и хвост после него (часто локация)
    start = m.start()
    fragment = text[start:]
    # обрезаем по "/" если двуязычное
    if "/" in fragment:
        # предпочитаем русскую часть после /
        parts = fragment.split("/")
        # если базис в первой части — оставим её; иначе вторую
        for p in parts:
            if BASIS_RE.search(p):
                return clean_text(p)
    return clean_text(fragment[:180])


def prefer_russian_product_name(name: Optional[str]) -> Optional[str]:
    """Если название вида 'kz / ru' — берём русскую часть."""
    text = clean_text(name)
    if not text:
        return None
    if "/" in text:
        left, right = text.split("/", 1)
        left, right = left.strip(), right.strip()
        # эвристика: кириллица справа чаще RU
        if re.search(r"[А-Яа-яЁё]", right):
            return right
        if re.search(r"[А-Яа-яЁё]", left):
            return left
    return text


@dataclass
class NormalizedTrade:
    exchange_code: str
    trade_date: date
    product_name: Optional[str] = None
    product_code: Optional[str] = None
    tnved_code: Optional[str] = None
    seller_name: Optional[str] = None
    seller_bin: Optional[str] = None
    buyer_name: Optional[str] = None
    buyer_bin: Optional[str] = None
    seller_broker: Optional[str] = None
    buyer_broker: Optional[str] = None
    volume: Optional[float] = None
    unit: Optional[str] = None
    price: Optional[float] = None
    price_vat: Optional[str] = None
    amount: Optional[float] = None
    delivery_place: Optional[str] = None
    delivery_term: Optional[str] = None
    deals_count: Optional[int] = None
    source_url: Optional[str] = None
    trade_time: Optional[str] = None
    extra: dict[str, Any] = field(default_factory=dict)

    def finalize(self) -> "NormalizedTrade":
        self.product_name = prefer_russian_product_name(self.product_name) or clean_text(
            self.product_name
        )
        self.product_code = clean_text(self.product_code)
        self.tnved_code = clean_text(self.tnved_code)
        if self.tnved_code:
            self.tnved_code = self.tnved_code.replace(" ", "")
        self.seller_name = clean_text(self.seller_name)
        self.buyer_name = clean_text(self.buyer_name)
        self.seller_broker = clean_text(self.seller_broker)
        self.buyer_broker = clean_text(self.buyer_broker)
        self.seller_bin = clean_text(self.seller_bin)
        self.buyer_bin = clean_text(self.buyer_bin)
        if self.seller_bin and not re.fullmatch(r"\d{12}", self.seller_bin):
            self.seller_bin = None
        if self.buyer_bin and not re.fullmatch(r"\d{12}", self.buyer_bin):
            self.buyer_bin = None
        self.delivery_place = clean_text(self.delivery_place)
        self.delivery_term = clean_text(self.delivery_term)
        self.unit = clean_text(self.unit)
        if self.volume is None and self.amount and self.price and self.price != 0:
            self.volume = round(self.amount / self.price, 6)
        if self.volume is not None and not self.unit:
            self.unit = "т"
        if not self.delivery_place and self.product_name:
            self.delivery_place = extract_delivery_from_product(self.product_name)
        return self

    def dedup_key(self) -> str:
        parts = [
            self.exchange_code,
            self.trade_date.isoformat(),
            self.product_code or "",
            normalize_name(self.product_name) or "",
            self.tnved_code or "",
            self.seller_bin or "",
            normalize_name(self.seller_name) or "",
            self.buyer_bin or "",
            normalize_name(self.buyer_name) or "",
            normalize_name(self.seller_broker) or "",
            normalize_name(self.buyer_broker) or "",
            f"{self.volume:.6f}" if self.volume is not None else "",
            f"{self.price:.6f}" if self.price is not None else "",
            f"{self.amount:.6f}" if self.amount is not None else "",
            normalize_name(self.delivery_place) or "",
            str(self.deals_count or ""),
        ]
        raw = "|".join(parts)
        return hashlib.sha256(raw.encode("utf-8")).hexdigest()

    def to_dict(self) -> dict[str, Any]:
        d = asdict(self)
        d["trade_date"] = self.trade_date.isoformat()
        return d
