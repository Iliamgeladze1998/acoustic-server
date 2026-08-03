"""Authenticated, deliberately slow HTTP client for the Acoustic.ge CS-Cart admin.

The admin panel is plain server-rendered PHP, so a session + BeautifulSoup is
enough - no browser automation needed. Every request is spaced out because the
store shares its host with the live shop and we must never look like a flood.
"""

from __future__ import annotations

import random
import time

import requests
from bs4 import BeautifulSoup

import config


class AdminError(RuntimeError):
    """Raised when the admin panel cannot be reached or parsed."""


class AdminClient:
    def __init__(self) -> None:
        self._session = requests.Session()
        self._session.headers.update({
            "User-Agent": config.USER_AGENT,
            "Accept-Language": "ka,en;q=0.8",
        })
        self._requests_made = 0

    # ── low level ──────────────────────────────────────────────────────────
    def _sleep(self, bounds: tuple[float, float]) -> None:
        time.sleep(random.uniform(*bounds))

    def _get(self, params: dict) -> str:
        last_error: Exception | None = None
        for attempt in range(1, config.MAX_RETRIES + 1):
            try:
                response = self._session.get(
                    config.ADMIN_URL, params=params,
                    timeout=config.REQUEST_TIMEOUT,
                )
                response.raise_for_status()
                self._requests_made += 1
                self._maybe_cooldown()
                return response.text
            except requests.RequestException as error:
                last_error = error
                backoff = 10.0 * attempt
                print(f"    request failed ({error}); retrying in {backoff:.0f}s "
                      f"[{attempt}/{config.MAX_RETRIES}]", flush=True)
                time.sleep(backoff)
        raise AdminError(f"GET {params} failed after "
                         f"{config.MAX_RETRIES} attempts: {last_error}")

    def _maybe_cooldown(self) -> None:
        if config.COOLDOWN_EVERY and self._requests_made % config.COOLDOWN_EVERY == 0:
            pause = random.uniform(*config.COOLDOWN_SECONDS)
            print(f"    cooldown after {self._requests_made} requests: "
                  f"{pause:.0f}s", flush=True)
            time.sleep(pause)

    # ── authentication ─────────────────────────────────────────────────────
    def login(self) -> None:
        """Log into the admin panel. CS-Cart needs a fresh per-session CSRF hash."""
        return_url = "aco_st_admin.php?dispatch=index.index"

        form_html = self._get({
            "dispatch": "auth.login_form",
            "return_url": return_url,
        })
        hash_input = BeautifulSoup(form_html, "html.parser").find(
            "input", {"name": "security_hash"})
        if not hash_input or not hash_input.get("value"):
            raise AdminError("security_hash not found on the login form")

        response = self._session.post(
            config.ADMIN_URL,
            data={
                "return_url": return_url,
                "user_login": config.ADMIN_LOGIN,
                "password": config.ADMIN_PASSWORD,
                "security_hash": hash_input["value"],
                "dispatch[auth.login]": "ავტორიზაცია",
            },
            timeout=config.REQUEST_TIMEOUT,
        )
        response.raise_for_status()

        if "auth.login_form" in response.url:
            raise AdminError("login rejected - check ADMIN_LOGIN / ADMIN_PASSWORD")
        print(f"  logged in as {config.ADMIN_LOGIN}", flush=True)

    # ── pages ──────────────────────────────────────────────────────────────
    def orders_page(self, date_from: str, date_to: str, page: int) -> str:
        """One page of the order list, filtered to the MM/DD/YYYY range."""
        if page > 1:
            self._sleep(config.DELAY_LIST_PAGE)
        return self._get({
            "dispatch": "orders.manage",
            "period": "custom",
            "time_from": date_from,
            "time_to": date_to,
            "items_per_page": 250,
            "page": page,
        })

    def order_detail(self, order_id: str) -> str:
        """The detail page of a single order."""
        self._sleep(config.DELAY_DETAIL)
        return self._get({"dispatch": "orders.details", "order_id": order_id})
