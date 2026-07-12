"""Cloudflare bypass helper.

Historically this module used FlareSolverr, but musicroom.ge upgraded to an
interactive Cloudflare Turnstile challenge that FlareSolverr can no longer
solve. It now uses Camoufox (stealth Firefox) with a persistent browser
session: the challenge is solved once (by locating the Turnstile widget on a
screenshot via the orange Cloudflare logo and clicking its checkbox), after
which the cf_clearance cookie makes subsequent requests fast.

The public API (flaresolverr_available / fetch_via_flaresolverr) is kept
unchanged so existing scraper scripts keep working without modification.
"""

import atexit
import io
import time

_browser = None
_page = None
_camoufox_cm = None


def _get_page():
    """Lazily start a persistent Camoufox browser and return a shared page."""
    global _browser, _page, _camoufox_cm
    if _page is not None:
        return _page
    from camoufox.sync_api import Camoufox
    _camoufox_cm = Camoufox(headless='virtual', geoip=True, humanize=True, locale='en-US')
    _browser = _camoufox_cm.__enter__()
    _page = _browser.new_page()
    atexit.register(_shutdown)
    return _page


def _shutdown():
    global _browser, _page, _camoufox_cm
    try:
        if _camoufox_cm is not None:
            _camoufox_cm.__exit__(None, None, None)
    except Exception:
        pass
    _browser = None
    _page = None
    _camoufox_cm = None


def _is_challenge(html):
    return 'challenge-platform' in html or 'cf-turnstile' in html or 'cf_chl_opt' in html


def _find_turnstile_checkbox(page):
    """Locate the Turnstile checkbox on a screenshot via the orange CF logo.

    The Turnstile iframe lives in a closed shadow DOM, so DOM locators cannot
    reach it. Instead we find the orange Cloudflare logo pixels on a
    screenshot; the checkbox sits ~185px to the left of the logo.
    """
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


def _solve_challenge(page, max_iterations=12, wait_ms=7000):
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


def flaresolverr_available():
    """Check that the Camoufox-based fetcher can start. Kept for API compatibility."""
    try:
        _get_page()
        return True
    except Exception as e:
        print(f"  Camoufox unavailable: {str(e)[:120]}")
        return False


def fetch_via_flaresolverr(url, timeout_ms=120000, return_url=False, max_retries=3):
    """Fetch a page through Camoufox, bypassing Cloudflare.

    Returns HTML by default, or (html, final_url) tuple if return_url=True.
    final_url is the URL after any redirects (useful for detecting invalid pages).
    """
    last_error = None
    for attempt in range(1, max_retries + 1):
        try:
            page = _get_page()
            page.goto(url, timeout=timeout_ms, wait_until='domcontentloaded')
            page.wait_for_timeout(1500)
            if _is_challenge(page.content()):
                print("  Cloudflare challenge detected, solving...")
                if not _solve_challenge(page):
                    last_error = 'Cloudflare challenge not solved'
                    print(f"  Camoufox error (attempt {attempt}/{max_retries}): {last_error}")
                    if attempt < max_retries:
                        print("  Retrying in 5 seconds...")
                        time.sleep(5)
                    continue
                print("  Cloudflare challenge solved.")
            html = page.content()
            if return_url:
                return html, page.url
            return html
        except Exception as e:
            last_error = str(e)[:120]
            print(f"  Camoufox request failed (attempt {attempt}/{max_retries}): {last_error}")
            # Restart the browser on hard failures (crash, closed connection)
            try:
                _shutdown()
            except Exception:
                pass
            if attempt < max_retries:
                print("  Retrying in 5 seconds...")
                time.sleep(5)

    return (None, None) if return_url else None
