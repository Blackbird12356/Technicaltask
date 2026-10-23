from __future__ import annotations

import logging
import time
from typing import Optional

import requests

from app import config

log = logging.getLogger(__name__)


class HttpClient:
    def __init__(self) -> None:
        self.session = requests.Session()
        self.session.headers.update(
            {
                "User-Agent": config.USER_AGENT,
                "Accept-Language": "ru-RU,ru;q=0.9,en;q=0.8",
                "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            }
        )

    def get(
        self,
        url: str,
        *,
        params: Optional[dict] = None,
        stream: bool = False,
        delay: Optional[float] = None,
    ) -> requests.Response:
        wait = config.REQUEST_DELAY if delay is None else delay
        last_err: Exception | None = None
        for attempt in range(1, config.MAX_RETRIES + 1):
            if wait:
                time.sleep(wait)
            try:
                resp = self.session.get(
                    url,
                    params=params,
                    timeout=config.HTTP_TIMEOUT,
                    stream=stream,
                )
                resp.raise_for_status()
                return resp
            except Exception as exc:  # noqa: BLE001
                last_err = exc
                log.warning("HTTP GET %s attempt %s failed: %s", url, attempt, exc)
                time.sleep(min(2 ** attempt, 10))
        assert last_err is not None
        raise last_err

    def get_bytes(self, url: str) -> bytes:
        return self.get(url).content

    def get_text(self, url: str, *, params: Optional[dict] = None) -> str:
        resp = self.get(url, params=params)
        resp.encoding = resp.apparent_encoding or "utf-8"
        return resp.text
