"""Shared local cache for acoustic.ge/products.json.

Instead of every scraper and the invoice bot fetching products.json
independently (which caused IP bans), this module provides a single
file-based cache that is refreshed by a cron job every 30 minutes.

All consumers call ``load_products()`` which:
  1. Reads the local cache file if it exists and is fresh enough.
  2. Falls back to a direct fetch only if the cache is missing or stale
     AND the caller passes ``allow_fetch=True`` (scrapers do this on
     their first run; the invoice bot never fetches directly).

The cache file: /root/scraper_common/products_cache.json
"""

from __future__ import annotations

import json
import os
import time
from pathlib import Path

CACHE_FILE = Path("/root/scraper_common/products_cache.json")
CACHE_MAX_AGE = 1800  # 30 minutes – the cron refresher runs at the same interval
REMOTE_URL = "https://acoustic.ge/data/products.json"
_FETCH_TIMEOUT = 30


def _is_fresh() -> bool:
    return CACHE_FILE.exists() and (
        time.time() - CACHE_FILE.stat().st_mtime < CACHE_MAX_AGE
    )


def _fetch_remote() -> dict | list | None:
    """Fetch products.json from acoustic.ge. Returns None on failure."""
    import requests

    try:
        resp = requests.get(REMOTE_URL, timeout=_FETCH_TIMEOUT)
        resp.raise_for_status()
        return resp.json()
    except Exception as exc:
        print(f"[products_cache] fetch failed: {exc}", flush=True)
        return None


def refresh_cache() -> bool:
    """Download products.json and write it to the cache file.

    Returns True on success, False on failure.
    """
    data = _fetch_remote()
    if data is None:
        return False

    CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)
    tmp = CACHE_FILE.with_suffix(".json.tmp")
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False)
    tmp.replace(CACHE_FILE)
    print(f"[products_cache] refreshed {CACHE_FILE} "
          f"({len(data) if isinstance(data, list) else 'dict'} items)",
          flush=True)
    return True


def load_products(allow_fetch: bool = False) -> dict | list | None:
    """Return the products payload.

    - If the local cache is fresh, return it immediately (no network).
    - If the cache is stale but exists, return it anyway (stale data is
      better than no data for scrapers that already have old data).
    - If the cache is missing entirely and *allow_fetch* is True,
      fetch from acoustic.ge once and cache the result.
    - If the cache is missing and *allow_fetch* is False, return None.
    """
    if CACHE_FILE.exists():
        try:
            with open(CACHE_FILE, "r", encoding="utf-8") as f:
                return json.load(f)
        except (json.JSONDecodeError, OSError) as exc:
            print(f"[products_cache] cache file corrupt: {exc}", flush=True)

    if allow_fetch:
        if refresh_cache() and CACHE_FILE.exists():
            with open(CACHE_FILE, "r", encoding="utf-8") as f:
                return json.load(f)

    return None


def cache_age_seconds() -> float | None:
    """Return the age of the cache file in seconds, or None if missing."""
    if not CACHE_FILE.exists():
        return None
    return time.time() - CACHE_FILE.stat().st_mtime


if __name__ == "__main__":
    import sys

    if "--refresh" in sys.argv:
        ok = refresh_cache()
        sys.exit(0 if ok else 1)
    else:
        age = cache_age_seconds()
        data = load_products()
        if data is not None:
            count = len(data) if isinstance(data, list) else len(data.get("products", []))
            print(f"Cache: {CACHE_FILE}")
            print(f"Age: {age:.0f}s" if age else "Age: unknown")
            print(f"Items: {count}")
        else:
            print("No cache available. Run: python products_cache.py --refresh")
            sys.exit(1)
