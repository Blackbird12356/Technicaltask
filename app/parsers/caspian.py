from __future__ import annotations

import logging
import math
import re
from datetime import date, timedelta
from typing import Optional
from urllib.parse import urlencode

from bs4 import BeautifulSoup

from app import config
from app.parsers.http_client import HttpClient
from app.parsers.normalize import (
    NormalizedTrade,
    clean_text,
    parse_date,
    parse_number,
    split_name_bin,
)

log = logging.getLogger(__name__)

TOTAL_MARKERS = ("итого по дате", "күні бойынша жиыны", "итого", "жиыны")


class CaspianParser:
    exchange_code = "CASPIAN"

    def __init__(self, client: Optional[HttpClient] = None) -> None:
        self.client = client or HttpClient()

    def parse(
        self,
        *,
        mode: str = "incremental",
        date_from: Optional[date] = None,
        date_to: Optional[date] = None,
    ) -> list[NormalizedTrade]:
        date_from, date_to = self._resolve_range(mode, date_from, date_to)
        log.info("Caspian parse mode=%s range=%s..%s", mode, date_from, date_to)
        trades: list[NormalizedTrade] = []
        seen_keys: set[str] = set()
        page = 1
        per_page = config.CASPIAN_PER_PAGE
        max_page = None
        while True:
            params = {
                "lang": config.CASPIAN_LANG,
                "page": str(page),
                "per_page": str(per_page),
            }
            if date_from:
                params["date_from"] = date_from.strftime("%d.%m.%Y")
            if date_to:
                params["date_to"] = date_to.strftime("%d.%m.%Y")
            url = config.CASPIAN_RESULTS_URL
            try:
                html = self.client.get_text(url, params=params)
            except Exception as exc:  # noqa: BLE001
                log.exception("Caspian page %s failed: %s", page, exc)
                break
            rows, detected_max = self.parse_html(
                html, source_url=f"{url}?{urlencode(params)}"
            )
            if max_page is None and detected_max:
                max_page = detected_max
            if not rows:
                log.info("Caspian page %s empty — stop", page)
                break
            new_on_page = 0
            for row in rows:
                key = row.dedup_key()
                if key in seen_keys:
                    continue
                seen_keys.add(key)
                trades.append(row)
                new_on_page += 1
            log.info(
                "Caspian page %s -> %s rows, %s new (max_page=%s)",
                page,
                len(rows),
                new_on_page,
                max_page,
            )
            if new_on_page == 0:
                log.info("Caspian page %s has no new rows — stop", page)
                break
            if max_page and page >= max_page:
                break
            page += 1
            if page > 500:
                log.warning("Caspian pagination safety stop at page 500")
                break
        return trades

    def _resolve_range(
        self,
        mode: str,
        date_from: Optional[date],
        date_to: Optional[date],
    ) -> tuple[Optional[date], Optional[date]]:
        if mode == "full" and date_from is None and date_to is None:
            return None, None
        if date_to is None:
            date_to = date.today()
        if date_from is None:
            date_from = date_to - timedelta(days=config.CASPIAN_INCREMENTAL_DAYS)
        return date_from, date_to

    def parse_html(self, html: str, *, source_url: str) -> tuple[list[NormalizedTrade], Optional[int]]:
        soup = BeautifulSoup(html, "lxml")
        table = soup.find("table")
        max_page = self._detect_max_page(soup)
        if not table:
            return [], max_page
        header_cells = [th.get_text(" ", strip=True) for th in table.find_all("th")]
        colmap = self._map_headers(header_cells)
        trades: list[NormalizedTrade] = []
        for tr in table.find_all("tr"):
            tds = tr.find_all("td")
            if not tds:
                continue
            values = [td.get_text(" ", strip=True) for td in tds]
            mapped = self._map_row(colmap, values)
            if not mapped:
                continue
            nt = NormalizedTrade(
                exchange_code=self.exchange_code,
                trade_date=mapped["trade_date"],
                product_name=mapped.get("product_name"),
                product_code=None,
                tnved_code=mapped.get("tnved"),
                seller_name=mapped.get("seller_name"),
                seller_bin=mapped.get("seller_bin"),
                buyer_name=mapped.get("buyer_name"),
                buyer_bin=mapped.get("buyer_bin"),
                seller_broker=mapped.get("seller_broker"),
                buyer_broker=mapped.get("buyer_broker"),
                price=mapped.get("price"),
                amount=mapped.get("amount"),
                delivery_place=mapped.get("delivery"),
                deals_count=mapped.get("deals_count"),
                source_url=source_url,
                price_vat=None,
            )
            trades.append(nt.finalize())
        return trades, max_page

    def _detect_max_page(self, soup: BeautifulSoup) -> Optional[int]:
        pages: list[int] = []
        for btn in soup.find_all(["button", "a"]):
            onclick = btn.get("onclick") or ""
            m = re.search(r"changePage\((\d+)\)", onclick)
            if m:
                pages.append(int(m.group(1)))
            text = btn.get_text(strip=True)
            if text.isdigit():
                pages.append(int(text))
        return max(pages) if pages else None

    def _map_headers(self, headers: list[str]) -> dict[str, int]:
        mapping: dict[str, int] = {}
        for i, h in enumerate(headers):
            hl = h.casefold()
            if "дата" in hl or hl == "күні":
                mapping["date"] = i
            elif "тн вэд" in hl or "сэқ тн" in hl or "еаэс" in hl:
                mapping["tnved"] = i
            elif "наименование товара" in hl or "тауардың атауы" in hl:
                mapping["product"] = i
            elif "средневзвеш" in hl or "орташа" in hl:
                mapping["price"] = i
            elif "сумма сделки" in hl or "келісім-шарт сомасы" in hl:
                mapping["amount"] = i
            elif "брокер покупателя" in hl or "сатып алушының брокері" in hl:
                mapping["buyer_broker"] = i
            elif "наименование покупателя" in hl or "сатып алушының атауы" in hl:
                mapping["buyer"] = i
            elif "брокер продавца" in hl or "сатушының брокері" in hl:
                mapping["seller_broker"] = i
            elif "наименование продавца" in hl or "сатушының атауы" in hl:
                mapping["seller"] = i
            elif "кол-во" in hl or "жасалған мәмілелер" in hl or "заключенных" in hl:
                mapping["deals"] = i
            elif "условие поставки" in hl or "жеткізу шарты" in hl:
                mapping["delivery"] = i
            elif "оборот" in hl or "айналым" in hl:
                mapping["turnover"] = i
        return mapping

    def _map_row(self, colmap: dict[str, int], values: list[str]) -> Optional[dict]:
        def get(key: str) -> Optional[str]:
            i = colmap.get(key)
            if i is None or i >= len(values):
                return None
            return clean_text(values[i])

        product = get("product")
        if product and product.casefold() in TOTAL_MARKERS:
            return None
        trade_date = parse_date(get("date"))
        if not trade_date:
            return None
        # строки только с итогом оборота
        if product is None and get("turnover") and not get("seller"):
            return None

        buyer_name, buyer_bin = split_name_bin(get("buyer"))
        seller_name, seller_bin = split_name_bin(get("seller"))
        deals = parse_number(get("deals"))
        return {
            "trade_date": trade_date,
            "product_name": product,
            "tnved": get("tnved"),
            "price": parse_number(get("price")),
            "amount": parse_number(get("amount")),
            "buyer_name": buyer_name,
            "buyer_bin": buyer_bin,
            "seller_name": seller_name,
            "seller_bin": seller_bin,
            "buyer_broker": get("buyer_broker"),
            "seller_broker": get("seller_broker"),
            "delivery": get("delivery"),
            "deals_count": int(deals) if deals is not None and not math.isnan(deals) else None,
        }
