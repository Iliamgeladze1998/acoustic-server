"""Auto-loaded via PYTHONPATH (see /root/run_single_scraper.sh).

Adds exponential-backoff retries to every gspread HTTP call so that transient
Google Sheets errors (429 rate limits, 5xx, and the sporadic 403 the API returns
when several scrapers write to the same spreadsheet at once) no longer abort a
whole scraping pipeline.
"""

import os
import random
import time

_MAX_ATTEMPTS = int(os.environ.get("GSPREAD_RETRY_ATTEMPTS", "6"))
_BASE_DELAY = float(os.environ.get("GSPREAD_RETRY_BASE_DELAY", "5"))
_RETRY_STATUSES = (403, 408, 429, 500, 502, 503, 504)


def _install():
    try:
        from gspread.http_client import HTTPClient
        from gspread.exceptions import APIError
    except Exception:
        return

    if getattr(HTTPClient, "_retry_patched", False):
        return

    original_request = HTTPClient.request

    def request(self, *args, **kwargs):
        last_error = None
        for attempt in range(1, _MAX_ATTEMPTS + 1):
            try:
                return original_request(self, *args, **kwargs)
            except APIError as error:
                status = getattr(getattr(error, "response", None), "status_code", None)
                if status not in _RETRY_STATUSES or attempt == _MAX_ATTEMPTS:
                    raise
                last_error = error
                delay = _BASE_DELAY * (2 ** (attempt - 1)) + random.uniform(0, 2)
                print(
                    f"[gspread-retry] {status} on attempt {attempt}/{_MAX_ATTEMPTS}; "
                    f"retrying in {delay:.1f}s",
                    flush=True,
                )
                time.sleep(delay)
        raise last_error

    HTTPClient.request = request
    HTTPClient._retry_patched = True


try:
    _install()
except Exception as exc:  # never break interpreter startup
    print(f"[gspread-retry] disabled: {exc}", flush=True)
