#!/usr/bin/env python3
"""Fetch all category links from jinomusic.ge/en/."""

import requests
from bs4 import BeautifulSoup
import sys
import os
import time

BASE_URL = "https://jinomusic.ge/en/"
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "category_links.txt")

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9",
}

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

    try:
        response = requests.get(BASE_URL, headers=HEADERS, timeout=30)
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"⚠️  Failed to fetch main page: {e}")
        print("Using fallback categories")
        return FALLBACK_CATEGORIES

    soup = BeautifulSoup(response.text, "html.parser")
    links = set()

    # Look for category links in the products page navigation
    for a_tag in soup.find_all("a", href=True):
        href = a_tag["href"]
        # Match category URLs like /en/guitar/, /en/drums/, etc.
        if "jinomusic.ge/en/" in href and href.endswith("/"):
            # Exclude non-category pages
            exclude = [
                "about-us", "cart", "contact", "feed", "privacy",
                "wp-json", "comments", "products", "checkout",
                "my-account", "shop", "home", "/en/"
            ]
            if not any(exc in href for exc in exclude):
                # Make sure it's a category (not a product)
                if "/en/product/" not in href:
                    links.add(href)

    # Also check /en/products/ page
    try:
        response2 = requests.get("https://jinomusic.ge/en/products/", headers=HEADERS, timeout=30)
        soup2 = BeautifulSoup(response2.text, "html.parser")
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
    except requests.RequestException:
        pass

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
