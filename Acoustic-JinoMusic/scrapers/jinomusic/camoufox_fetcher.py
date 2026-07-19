#!/usr/bin/env python3
"""Camoufox-based fetcher with Tor proxy for jinomusic.ge — bypasses JS challenge + IP blocks."""

import time
import random
import os
import sys
from camoufox.sync_api import Camoufox

TOR_PROXY = "socks5://127.0.0.1:9050"
BROWSER = None
PAGE = None
_cm = None

# How many pages to fetch before renewing Tor circuit (new IP)
RENEW_CIRCUIT_EVERY = 20
_page_count = 0


def _renew_tor_circuit():
    """Signal Tor to use a new circuit (new exit IP)."""
    try:
        import socket
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        s.connect(("127.0.0.1", 9051))
        s.sendall(b'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT\r\n')
        s.close()
        print("   🔄 Tor circuit renewed (new IP)")
        time.sleep(3)
    except Exception as e:
        print(f"   ⚠️  Tor circuit renewal failed: {e}")


def init_browser(max_attempts=3):
    """Initialize Camoufox browser with Tor proxy. Retries on failure."""
    global BROWSER, PAGE, _cm
    if BROWSER is not None:
        return
    for attempt in range(1, max_attempts + 1):
        try:
            print(f"🌐 Starting Camoufox with Tor proxy (attempt {attempt}/{max_attempts})...")
            _cm = Camoufox(headless='virtual', proxy={"server": TOR_PROXY}, geoip=True, humanize=True, locale='en-US')
            BROWSER = _cm.__enter__()
            context = BROWSER.new_context()
            PAGE = context.new_page()
            PAGE.set_default_timeout(60000)
            print("   ✅ Browser ready")
            return
        except Exception as e:
            print(f"   ❌ Camoufox launch failed (attempt {attempt}/{max_attempts}): {str(e)[:200]}")
            try:
                close_browser()
            except Exception:
                pass
            if attempt < max_attempts:
                wait = 10 * attempt
                print(f"   Waiting {wait}s before retry...")
                time.sleep(wait)
    raise RuntimeError(f"Camoufox failed to launch after {max_attempts} attempts")


def close_browser():
    """Close Camoufox browser."""
    global BROWSER, PAGE, _cm
    if PAGE:
        try:
            PAGE.close()
        except Exception:
            pass
        PAGE = None
    if _cm is not None:
        try:
            _cm.__exit__(None, None, None)
        except Exception:
            pass
    BROWSER = None
    _cm = None
    print("   🔒 Browser closed")


def fetch_page(url, wait_selector=None):
    """Fetch a page via Camoufox, returning HTML content. Handles JS challenge."""
    global _page_count

    if BROWSER is None:
        init_browser()

    # Renew Tor circuit periodically
    if _page_count > 0 and _page_count % RENEW_CIRCUIT_EVERY == 0:
        _renew_tor_circuit()

    # Occasional longer pause to simulate human browsing (every ~10 pages)
    if _page_count > 0 and _page_count % 10 == 0:
        pause = random.uniform(5.0, 10.0)
        print(f"   😌 Pausing {pause:.1f}s (human-like break)...")
        time.sleep(pause)

    max_retries = 3
    for attempt in range(max_retries):
        try:
            PAGE.goto(url, timeout=60000, wait_until="domcontentloaded")

            # Wait for JS challenge to resolve (up to 60s)
            for _ in range(12):
                PAGE.wait_for_timeout(5000)
                title = PAGE.title()
                if "One moment" not in title and "Just a moment" not in title:
                    break
            else:
                # Challenge still not resolved after 60s
                if attempt < max_retries - 1:
                    print(f"   ⚠️  JS challenge not resolved, retrying with new IP...")
                    _renew_tor_circuit()
                    continue

            # Extra wait for specific selector if provided
            if wait_selector:
                try:
                    PAGE.wait_for_selector(wait_selector, timeout=15000)
                except Exception:
                    pass

            content = PAGE.content()
            _page_count += 1

            # Varied delay: shorter for category pages, longer for product pages
            # Sometimes a longer pause to look like reading
            if random.random() < 0.15:
                delay = random.uniform(5.0, 8.0)
            else:
                delay = random.uniform(2.5, 5.0)
            time.sleep(delay)

            return content

        except Exception as e:
            print(f"   ⚠️  Attempt {attempt+1}/{max_retries} failed for {url}: {e}")
            if attempt < max_retries - 1:
                _renew_tor_circuit()
                time.sleep(5)
            else:
                print(f"   ❌ All retries exhausted for {url}")
                return None

    return None


def fetch_product_page(url):
    """Fetch a product page via Camoufox, wait for product content."""
    return fetch_page(url, wait_selector='script[type="application/ld+json"]')
