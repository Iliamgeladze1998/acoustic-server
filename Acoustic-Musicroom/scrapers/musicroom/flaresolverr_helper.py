"""Cloudflare bypass helper using FlareSolverr HTTP API.

Uses the FlareSolverr service at localhost:8191 to bypass Cloudflare challenges.
The public API (flaresolverr_available / fetch_via_flaresolverr) is kept
unchanged so existing scraper scripts keep working without modification.
"""

import json
import urllib.request
import time


FLARESOLVERR_URL = 'http://127.0.0.1:8191/v1'


def flaresolverr_available():
    """Check if FlareSolverr HTTP API is running."""
    try:
        req = urllib.request.Request('http://127.0.0.1:8191/')
        with urllib.request.urlopen(req, timeout=5) as resp:
            return resp.status == 200
    except Exception:
        return False


def _fetch_via_flaresolverr(url, timeout_ms=60000):
    """Fetch a page through FlareSolverr HTTP API. Returns (html, final_url) or (None, None)."""
    try:
        payload = json.dumps({
            "cmd": "request.get",
            "url": url,
            "maxTimeout": timeout_ms,
        }).encode()
        req = urllib.request.Request(
            FLARESOLVERR_URL,
            data=payload,
            headers={"Content-Type": "application/json"},
        )
        with urllib.request.urlopen(req, timeout=timeout_ms // 1000 + 10) as resp:
            data = json.loads(resp.read())
        if data.get("status") == "ok":
            solution = data.get("solution", {})
            html = solution.get("response", "")
            final_url = solution.get("url", url)
            return html, final_url
        else:
            print(f"  FlareSolverr error: {data.get('message', 'unknown')}")
    except Exception as e:
        print(f"  FlareSolverr request failed: {str(e)[:120]}")
    return None, None


def fetch_via_flaresolverr(url, timeout_ms=60000, return_url=False, max_retries=2):
    """Fetch a page bypassing Cloudflare via FlareSolverr.

    Returns HTML by default, or (html, final_url) tuple if return_url=True.
    """
    for attempt in range(1, max_retries + 1):
        html, final_url = _fetch_via_flaresolverr(url, timeout_ms=timeout_ms)
        if html is not None and len(html) > 1000:
            if return_url:
                return html, final_url
            return html
        print(f"  FlareSolverr attempt {attempt}/{max_retries} failed")
        if attempt < max_retries:
            time.sleep(3)

    return (None, None) if return_url else None
