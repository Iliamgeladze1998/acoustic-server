#!/usr/bin/env python3
"""Fetch all category links from jinomusic.ge/en/ using Camoufox + Tor."""

from bs4 import BeautifulSoup
import sys
import os
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from camoufox_fetcher import init_browser, close_browser, fetch_page

BASE_URL = "https://jinomusic.ge/en/"
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "category_links.txt")

# Known categories as fallback
FALLBACK_CATEGORIES = [
    "https://jinomusic.ge/en/guitar/",
    "https://jinomusic.ge/en/drums/",
    "https://jinomusic.ge/en/keyboard/",
    "https://jinomusic.ge/en/audio-equipment/",
    "https://jinomusic.ge/en/commutation/",
    "https://jinomusic.ge/en/lighting/",
    "https://jinomusic.ge/en/folk-instruments/",
    "https://jinomusic.ge/en/orchestral-instrument/",
    "https://jinomusic.ge/en/wind-instrument/",
]


def get_category_links():
    """Fetch category links from the main products page."""
    print(f"Fetching category links from {BASE_URL}")

    init_browser()

    html = fetch_page(BASE_URL)
    if not html or "One moment" in html:
        print("⚠️  Could not fetch main page, using fallback categories")
        close_browser()
        links = sorted(FALLBACK_CATEGORIES)
        with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
            for link in links:
                f.write(link + "\n")
        return links

    soup = BeautifulSoup(html, "html.parser")
    links = set()

    for a_tag in soup.find_all("a", href=True):
        href = a_tag["href"]
        if "jinomusic.ge/en/" in href and href.endswith("/"):
            exclude = [
                "about-us", "cart", "contact", "feed", "privacy",
                "wp-json", "comments", "products", "checkout",
                "my-account", "shop", "home", "/en/"
            ]
            if not any(exc in href for exc in exclude):
                if "/en/product/" not in href:
                    links.add(href)

    # Also check /en/products/ page
    html2 = fetch_page("https://jinomusic.ge/en/products/")
    if html2 and "One moment" not in html2:
        soup2 = BeautifulSoup(html2, "html.parser")
        for a_tag in soup2.find_all("a", href=True):
            href = a_tag["href"]
            if "jinomusic.ge/en/" in href and href.endswith("/"):
                exclude = [
                    "about-us", "cart", "contact", "feed", "privacy",
                    "wp-json", "comments", "products", "checkout",
                    "my-account", "shop", "home", "/en/"
                ]
                if not any(exc in href for exc in exclude):
                    if "/en/product/" not in href:
                        links.add(href)

    close_browser()

    # Deduplicate: wind-instrument and wind-instruments are the same
    # Keep only one of them
    if "https://jinomusic.ge/en/wind-instruments/" in links:
        links.discard("https://jinomusic.ge/en/wind-instruments/")

    if not links:
        print("⚠️  No category links found, using fallback")
        links = set(FALLBACK_CATEGORIES)

    links = sorted(links)
    print(f"✅ Found {len(links)} categories:")
    for link in links:
        print(f"   {link}")

    # Save to file
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        for link in links:
            f.write(link + "\n")
    print(f"💾 Saved to {OUTPUT_FILE}")

    return links


if __name__ == "__main__":
    get_category_links()
