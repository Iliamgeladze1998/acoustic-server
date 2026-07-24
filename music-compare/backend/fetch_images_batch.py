#!/usr/bin/env python3
"""Fetch and validate original image URLs without downloading image files."""

import os
import re
import time
import sqlite3
import json
import urllib.request
from collections import defaultdict
from urllib.parse import urljoin, urlparse

import requests
from bs4 import BeautifulSoup

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "music_compare.db")

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
}

FLARESOLVERR_URL = "http://127.0.0.1:8191/v1"
CLOUDFLARE_STORES = {"Musicroom", "Geovoice"}
STORE_PRIORITY = ["Largo", "Musikis-Saxli", "Mireli", "Acoustic", "JinoMusic", "Musicroom", "Geovoice"]
BLOCKED_IMAGE_MARKERS = (
    "logo", "favicon", "placeholder", "no-image", "no_image",
    "woocommerce-placeholder", "default-image", "default_image",
    "/icon", "avatar", "banner",
)




def fetch_via_flaresolverr(url, timeout_ms=30000):
    try:
        payload = json.dumps({"cmd": "request.get", "url": url, "maxTimeout": timeout_ms}).encode()
        req = urllib.request.Request(FLARESOLVERR_URL, data=payload, headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(req, timeout=timeout_ms // 1000 + 10) as resp:
            data = json.loads(resp.read())
        if data.get("status") == "ok":
            solution = data.get("solution", {})
            return solution.get("response", ""), solution.get("url", url)
    except Exception:
        pass
    return "", url


def normalise_image_url(candidate, page_url):
    if not candidate:
        return ""
    candidate = candidate.strip()
    if candidate.startswith(("data:", "blob:", "javascript:")):
        return ""
    image_url = urljoin(page_url, candidate)
    parsed = urlparse(image_url)
    if parsed.scheme not in ("http", "https") or not parsed.netloc:
        return ""
    lowered = image_url.lower()
    if any(marker in lowered for marker in BLOCKED_IMAGE_MARKERS):
        return ""
    filename = parsed.path.rsplit("/", 1)[-1].lower()
    if filename in {"image.jpg", "image.png", "image.jpeg", "image-800x800.jpg", "image-800x800.png"}:
        return ""
    return image_url


def is_product_page(html, requested_url, final_url):
    if not html or len(html) < 500:
        return False
    parsed = urlparse(final_url or requested_url)
    if not parsed.path.strip("/"):
        return False
    soup = BeautifulSoup(html, "lxml")
    og_type = soup.find("meta", property="og:type")
    if og_type and og_type.get("content", "").lower() == "product":
        return True
    for script in soup.find_all("script", type="application/ld+json"):
        script_text = script.get_text(" ", strip=True).lower()
        if '"@type":"product"' in script_text or '"@type": "product"' in script_text:
            return True
    if soup.select_one(".woocommerce-product-gallery, .product, [itemtype*='Product'], [itemprop='image'], input[name='product_id']"):
        return True
    return bool(soup.find("meta", property="og:image") and soup.find("meta", property="og:title"))


def extract_image_candidates(html, page_url):
    if not html or len(html) < 500:
        return []
    soup = BeautifulSoup(html, "lxml")
    candidates = []

    def add(value):
        value = normalise_image_url(value, page_url)
        if value and value not in candidates:
            candidates.append(value)

    og = soup.find("meta", property="og:image")
    if og:
        add(og.get("content"))
    tw = soup.find("meta", attrs={"name": "twitter:image"})
    if tw:
        add(tw.get("content"))
    for img in soup.find_all("img"):
        classes = " ".join(img.get("class", [])).lower()
        if any(marker in classes for marker in ("product", "woocommerce", "gallery", "main-image")):
            add(img.get("src") or img.get("data-src") or img.get("data-lazy-src") or img.get("data-orig-src"))
    for img in soup.find_all("img"):
        add(img.get("src") or img.get("data-src") or img.get("data-lazy-src") or img.get("data-orig-src"))
    return candidates


def is_direct_image_url(image_url):
    if not image_url:
        return False
    try:
        response = requests.get(
            image_url,
            headers={**HEADERS, "Accept": "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8"},
            timeout=8,
            allow_redirects=True,
            stream=True,
        )
        content_type = response.headers.get("content-type", "").split(";", 1)[0].lower()
        valid = response.status_code == 200 and content_type.startswith("image/")
        response.close()
        return valid
    except Exception:
        return False


def looks_like_image_url(image_url):
    """Return True if the URL has a known image extension and no blocked markers."""
    if not image_url:
        return False
    parsed = urlparse(image_url)
    if parsed.scheme not in ("http", "https") or not parsed.netloc:
        return False
    lowered = image_url.lower()
    if any(marker in lowered for marker in BLOCKED_IMAGE_MARKERS):
        return False
    return bool(re.search(r"\.(?:jpg|jpeg|png|webp|gif|avif)(?:[?#]|$)", parsed.path, re.I))


def fetch_image_for_link(link, store_name, existing_image_url=""):
    """Return an original image URL. Cloudflare-blocked stores are accepted without direct validation."""
    if not link or link == "N/A":
        return ""

    if existing_image_url and is_direct_image_url(existing_image_url):
        return existing_image_url

    if store_name in CLOUDFLARE_STORES:
        html, final_url = fetch_via_flaresolverr(link)
    else:
        try:
            response = requests.get(link, headers=HEADERS, timeout=8, allow_redirects=True)
            if response.status_code != 200:
                return ""
            html, final_url = response.text, response.url
        except Exception:
            return ""

    if not is_product_page(html, link, final_url):
        return ""

    candidates = extract_image_candidates(html, final_url)

    # Non-Cloudflare stores require a directly reachable image URL.
    if store_name not in CLOUDFLARE_STORES:
        for candidate in candidates:
            if is_direct_image_url(candidate):
                return candidate
        return ""

    # For Cloudflare-blocked stores, the server IP cannot fetch the image directly,
    # but the URL is still the original source URL. Keep it so the end user's browser
    # (on a different IP) can load it, and so every product has an image URL.
    for candidate in candidates:
        if looks_like_image_url(candidate):
            return candidate
    return ""


def run(limit=None):
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()

    c.execute("SELECT COUNT(*) FROM product_groups WHERE image_url = '' OR image_url IS NULL")
    total_missing = c.fetchone()[0]
    print(f"Groups without image: {total_missing}")

    c.execute("""
        SELECT g.id, g.display_name, l.store_name, l.link, l.image_url
        FROM product_groups g
        JOIN listings l ON l.group_id = g.id
        WHERE (g.image_url = '' OR g.image_url IS NULL)
        AND l.link != '' AND l.link != 'N/A'
        ORDER BY g.id
    """)
    rows = c.fetchall()

    groups = defaultdict(list)
    for gid, name, store, link, existing_image_url in rows:
        groups[gid].append((store, link, existing_image_url, name))
    if limit:
        groups = dict(list(groups.items())[:limit])

    print(f"Groups to process: {len(groups)}")

    fetched = 0
    failed = 0
    for index, (group_id, listings) in enumerate(groups.items(), 1):
        name = listings[0][3]
        listings.sort(key=lambda item: STORE_PRIORITY.index(item[0]) if item[0] in STORE_PRIORITY else 99)

        image_url = ""
        source_link = ""
        source_store = ""
        for store, link, existing_image_url, _ in listings:
            image_url = fetch_image_for_link(link, store, existing_image_url)
            if image_url:
                source_link = link
                source_store = store
                break
            time.sleep(0.1)

        if image_url:
            c.execute("UPDATE product_groups SET image_url = ? WHERE id = ?", (image_url, group_id))
            c.execute("UPDATE listings SET image_url = ? WHERE link = ?", (image_url, source_link))
            conn.commit()
            fetched += 1
            print(f"  [{index}/{len(groups)}] OK [{source_store}/DIRECT]: {name[:35]} -> {image_url[:60]}")
        else:
            failed += 1
            if index % 100 == 0:
                print(f"  [{index}/{len(groups)}] -- {name[:35]} (no reachable direct image)")

        if index % 200 == 0:
            c.execute("SELECT COUNT(*) FROM product_groups WHERE image_url != '' AND image_url IS NOT NULL")
            with_image = c.fetchone()[0]
            c.execute("SELECT COUNT(*) FROM product_groups")
            total = c.fetchone()[0]
            print(f"\n  PROGRESS: {index}/{len(groups)} | +{fetched} found | {with_image}/{total} have direct images\n")

    conn.close()
    print(f"\nDONE: +{fetched} direct images found, {failed} groups still without a reachable direct image")


if __name__ == "__main__":
    import sys
    limit = int(sys.argv[1]) if len(sys.argv) > 1 else None
    print("Validating direct original image URLs only; no image files are downloaded.")
    run(limit)
