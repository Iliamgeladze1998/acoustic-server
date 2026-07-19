"""Camoufox-based Cloudflare bypass helper for Geovoice.

Uses Camoufox (stealth Firefox) with a persistent browser session to bypass
Cloudflare challenges. Falls back to FlareSolverr if Camoufox fails.
"""

import atexit
import io
import time
import json
import urllib.request
import logging

logger = logging.getLogger(__name__)

_browser = None
_page = None
_cm = None

# Circuit breaker for Camoufox
_fail_streak = 0
_tripped = False


def _get_page():
    """Lazily start a persistent Camoufox browser and return a shared page."""
    global _browser, _page, _cm
    if _page is not None:
        return _page
    from camoufox.sync_api import Camoufox
    _cm = Camoufox(headless='virtual', geoip=True, humanize=True, locale='en-US')
    _browser = _cm.__enter__()
    _page = _browser.new_page()
    atexit.register(_shutdown)
    return _page


def _shutdown():
    global _browser, _page, _cm
    try:
        if _cm is not None:
            _cm.__exit__(None, None, None)
    except Exception:
        pass
    _browser = None
    _page = None
    _cm = None


def _is_challenge(html):
    return 'challenge-platform' in html or 'cf-turnstile' in html or 'Just a moment' in html or 'cf_chl_opt' in html


def _find_turnstile_checkbox(page):
    """Locate the Turnstile checkbox on a screenshot via the orange CF logo."""
    from PIL import Image
    img = Image.open(io.BytesIO(page.screenshot())).convert('RGB')
    w, h = img.size
    px = img.load()
    pts = [(x, y) for y in range(0, h, 2) for x in range(0, w, 2)
           if abs(px[x, y][0] - 243) < 40 and abs(px[x, y][1] - 128) < 45 and abs(px[x, y][2] - 32) < 50]
    if not pts:
        return None
    ox = sum(p[0] for p in pts) / len(pts)
    oy = sum(p[1] for p in pts) / len(pts)
    return ox - 185, oy


def _solve_challenge(page, max_iterations=5, wait_ms=4000):
    """Wait out / click through the Cloudflare challenge. Returns True if solved."""
    for _ in range(max_iterations):
        html = page.content()
        if not _is_challenge(html):
            return True
        try:
            cb = _find_turnstile_checkbox(page)
            if cb:
                page.mouse.click(*cb)
        except Exception:
            pass
        page.wait_for_timeout(wait_ms)
    return not _is_challenge(page.content())


def _fetch_via_flaresolverr(url, timeout_ms=60000):
    """Fallback: use FlareSolverr HTTP API at localhost:8191."""
    try:
        payload = json.dumps({
            "cmd": "request.get",
            "url": url,
            "maxTimeout": timeout_ms,
        }).encode()
        req = urllib.request.Request(
            "http://127.0.0.1:8191/v1",
            data=payload,
            headers={"Content-Type": "application/json"},
        )
        with urllib.request.urlopen(req, timeout=timeout_ms // 1000 + 10) as resp:
            data = json.loads(resp.read())
        if data.get("status") == "ok":
            return data.get("solution", {}).get("response", "")
    except Exception as e:
        logger.error(f"FlareSolverr error: {str(e)[:80]}")
    return None


def fetch_page(url, timeout_ms=30000, max_retries=2):
    """Fetch a page bypassing Cloudflare using Camoufox, with FlareSolverr fallback.

    Returns HTML string or None.
    """
    global _fail_streak, _tripped

    # Circuit breaker: skip Camoufox if it keeps failing
    if _tripped:
        logger.info("Camoufox circuit breaker tripped — trying FlareSolverr directly")
        html = _fetch_via_flaresolverr(url)
        if html and not _is_challenge(html):
            return html
        # Reset and try Camoufox again
        _fail_streak = 0
        _tripped = False

    for attempt in range(1, max_retries + 1):
        try:
            page = _get_page()
            page.goto(url, timeout=timeout_ms, wait_until='domcontentloaded')
            page.wait_for_timeout(1500)
            if _is_challenge(page.content()):
                logger.info("Cloudflare challenge detected, solving...")
                if not _solve_challenge(page):
                    logger.error(f"Camoufox challenge not solved (attempt {attempt}/{max_retries})")
                    if attempt < max_retries:
                        time.sleep(3)
                    continue
                logger.info("Cloudflare challenge solved.")
            html = page.content()
            _fail_streak = 0
            _tripped = False
            return html
        except Exception as e:
            logger.error(f"Camoufox failed (attempt {attempt}/{max_retries}): {str(e)[:120]}")
            try:
                _shutdown()
            except Exception:
                pass
            if attempt < max_retries:
                time.sleep(3)

    # Camoufox failed — update circuit breaker
    _fail_streak += 1
    if _fail_streak >= 3:
        _tripped = True
        logger.error(f"Camoufox circuit breaker tripped ({_fail_streak} consecutive failures)")

    # Fallback: FlareSolverr
    logger.info("Trying FlareSolverr fallback...")
    html = _fetch_via_flaresolverr(url)
    if html and not _is_challenge(html):
        logger.info("FlareSolverr fallback succeeded!")
        return html

    return None


def is_available():
    """Check if Camoufox can start."""
    try:
        _get_page()
        return True
    except Exception as e:
        logger.error(f"Camoufox unavailable: {str(e)[:120]}")
        return False
