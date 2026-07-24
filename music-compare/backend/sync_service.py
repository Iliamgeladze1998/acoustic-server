#!/usr/bin/env python3
"""
Sync Service v2: Reads raw scraped Excel files from ALL stores,
matches products across ALL stores (not just Acoustic vs X),
and populates SQLite database.
Image URLs fetched from Acoustic only (hotlinking strategy).
"""

import os
import re
import time
import sqlite3
import requests
import pandas as pd
from datetime import datetime
from bs4 import BeautifulSoup
from rapidfuzz import fuzz, process
from fetch_images_batch import fetch_image_for_link

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "music_compare.db")

# Source Excel files (raw scraped data from each store)
STORE_FILES = {
    "Acoustic": "/root/Acoustic-Geovoice/scrapers/acoustic/acoustic_cleaned_models.xlsx",
    "Geovoice": "/root/Acoustic-Geovoice/scrapers/geovoice/geovoice_cleaned_models.xlsx",
    "JinoMusic": "/root/Acoustic-JinoMusic/scrapers/jinomusic/jinomusic_cleaned.xlsx",
    "Largo": "/root/Acoustic-Largo/scrapers/largo/largo_cleaned.xlsx",
    "Mireli": "/root/Acoustic-Mireli/scrapers/mireli/mireli_cleaned_models.xlsx",
    "Musicroom": "/root/Acoustic-Musicroom/scrapers/musicroom/musicroom_cleaned.xlsx",
    "Musikis-Saxli": "/root/Acoustic-Musikissaxli/scrapers/musikis-saxli/final_stock_cleaned.xlsx",
}

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
}


def clean_image_reference(value, store_name):
    if value is None:
        return ""
    image_url = str(value).strip()
    if not image_url or image_url.lower() == "nan":
        return ""
    lowered = image_url.lower()
    if any(marker in lowered for marker in ("logo", "favicon", "placeholder", "no-image", "default-image", "/icon", "banner")):
        return ""
    if "index.php?dispatch=products.view" in lowered:
        return ""
    if "/product/" in lowered and not re.search(r"\.(?:jpg|jpeg|png|webp|gif)(?:[?#]|$)", lowered):
        return ""
    return image_url

BRAND_BLACKLIST = [
    'Yamaha', 'Ibanez', 'Stagg', 'Alice', 'Istanbul', 'AKG', 'Korg', 'Casio',
    'Shelter', 'Harley Benton', 'Bose', 'AdamHall', 'KLOTZ', 'ALESIS',
    'Native-instruments', 'Behringer', 'Fender', 'Gibson', 'Roland', 'Boss',
    'Marshall', 'VOX', 'TC Electronic', 'Sennheiser', 'Shure', 'Mackie',
    'Pioneer', 'Allen', 'Heath', 'Focusrite', 'PreSonus', 'M-Audio',
    'Akai', 'Arturia', 'Novation', 'Kawai', 'Kurzweil', 'Dexibell',
]


def init_db():
    """Initialize SQLite database with fresh schema."""
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()

    # Drop old tables for clean rebuild, but preserve user feedback.
    c.execute("DROP TABLE IF EXISTS listings")
    c.execute("DROP TABLE IF EXISTS product_groups")
    c.execute("DROP TABLE IF EXISTS sync_log")
    # feedback is intentionally kept so user reports survive auto-sync.

    c.execute("""
        CREATE TABLE product_groups (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            match_key TEXT UNIQUE NOT NULL,
            display_name TEXT NOT NULL,
            image_url TEXT DEFAULT '',
            instrument_type TEXT DEFAULT '',
            store_count INTEGER DEFAULT 0,
            min_price REAL,
            max_price REAL,
            last_updated TEXT
        )
    """)

    c.execute("""
        CREATE TABLE listings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            group_id INTEGER,
            product_name TEXT NOT NULL,
            store_name TEXT NOT NULL,
            price REAL,
            link TEXT,
            image_url TEXT,
            clean_id TEXT DEFAULT '',
            clean_model TEXT DEFAULT '',
            UNIQUE(product_name, store_name, link),
            FOREIGN KEY (group_id) REFERENCES product_groups(id)
        )
    """)

    c.execute("""
        CREATE TABLE IF NOT EXISTS sync_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sync_time TEXT,
            rows_synced INTEGER,
            images_fetched INTEGER,
            errors INTEGER
        )
    """)

    c.execute("""
        CREATE TABLE IF NOT EXISTS feedback (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            group_id INTEGER,
            match_key TEXT NOT NULL,
            store_name TEXT DEFAULT '',
            listing_product_name TEXT DEFAULT '',
            status TEXT DEFAULT 'wrong',
            note TEXT DEFAULT '',
            created_at TEXT,
            reviewed INTEGER DEFAULT 0
        )
    """)

    c.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            first_name TEXT DEFAULT '',
            last_name TEXT DEFAULT '',
            created_at TEXT,
            last_login TEXT
        )
    """)

    c.execute("""
        CREATE TABLE IF NOT EXISTS favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            match_key TEXT NOT NULL,
            created_at TEXT,
            UNIQUE(user_id, match_key),
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    """)

    c.execute("""
        CREATE TABLE IF NOT EXISTS visitors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip TEXT,
            user_agent TEXT,
            path TEXT,
            user_id INTEGER,
            created_at TEXT
        )
    """)

    c.execute("CREATE INDEX IF NOT EXISTS idx_listings_group ON listings(group_id)")
    c.execute("CREATE INDEX IF NOT EXISTS idx_listings_store ON listings(store_name)")
    c.execute("CREATE INDEX IF NOT EXISTS idx_groups_key ON product_groups(match_key)")
    c.execute("CREATE INDEX IF NOT EXISTS idx_visitors_created ON visitors(created_at)")

    conn.commit()
    conn.close()
    print(f"[DB] Initialized fresh at {DB_PATH}")


def load_store_data(store_name, file_path):
    """Load a store's Excel file and normalize to common schema."""
    print(f"\n  Loading {store_name} from {file_path}")

    try:
        df = pd.read_excel(file_path)
    except Exception as e:
        print(f"  [ERROR] Could not read {file_path}: {e}")
        return []

    products = []
    for _, row in df.iterrows():
        # Handle different column names across stores
        name = (
            row.get("NAME") or row.get("name") or row.get("Product_Name") or
            row.get("CLEAN_NAME") or ""
        )
        price = row.get("PRICE") or row.get("Price") or row.get("price")
        link = row.get("LINK") or row.get("Link") or row.get("link") or ""
        clean_id = str(row.get("CLEAN_ID") or "")
        clean_model = str(row.get("CLEAN_MODEL") or "")
        raw_image = row.get("IMAGE") or row.get("Image_URL") or row.get("image_url") or ""
        image = clean_image_reference(raw_image, store_name)

        # Skip empty names
        if not name or str(name).strip() == "nan":
            continue

        name = str(name).strip()
        link = str(link).strip() if link and str(link) != "nan" else ""

        # Parse price
        try:
            if isinstance(price, str):
                price = float(re.sub(r'[^\d.]', '', price.replace(',', '.'))) if price.strip() else None
            else:
                price = float(price) if price and str(price) != "nan" else None
        except (ValueError, TypeError):
            price = None

        # Skip products with no price or zero price
        if not price or price <= 0:
            continue

        # Extract clean_model if not present
        if not clean_model or clean_model == "nan":
            clean_model = extract_model_from_name(name)

        products.append({
            "product_name": name,
            "store_name": store_name,
            "price": price,
            "link": link,
            "image_url": image,
            "clean_id": clean_id if clean_id and clean_id != "nan" else "",
            "clean_model": clean_model if clean_model and clean_model != "nan" else "",
        })

    print(f"    Loaded {len(products)} valid products")
    return products


def extract_model_from_name(name):
    """Extract a model identifier from product name."""
    if not name:
        return ""

    words = str(name).split()
    valid_models = []

    for word in words:
        # Remove Georgian characters
        clean_word = re.sub(r'[\u10D0-\u10F6]+', '', word)
        # Check if word has BOTH letters AND digits
        has_letter = re.search(r'[A-Za-z]', clean_word)
        has_digit = re.search(r'\d', clean_word)

        if has_letter and has_digit:
            word_lower = clean_word.lower()
            is_blacklisted = any(brand.lower() in word_lower for brand in BRAND_BLACKLIST)
            if not is_blacklisted:
                # Truncate at hyphen/dot/slash
                base = re.split(r'[-./]', clean_word)[0]
                if re.search(r'[A-Za-z]', base) and re.search(r'\d', base):
                    valid_models.append(base)

    return ''.join(valid_models).strip() if valid_models else ""


def clean_name_for_matching(name):
    """Clean product name for fuzzy matching."""
    if not name:
        return ""
    import string
    cleaned = str(name).lower()
    # Remove store suffixes
    for suffix in [' - music room', ' | geovoice.ge', ' - acoustic', ' - largo', ' - mireli']:
        cleaned = cleaned.replace(suffix, '')
    # Remove punctuation
    cleaned = cleaned.translate(str.maketrans('', '', string.punctuation))
    # Remove Georgian text (keep only latin for matching)
    cleaned = re.sub(r'[\u10D0-\u10F6]+', '', cleaned)
    # Remove brand names
    for brand in BRAND_BLACKLIST:
        cleaned = re.sub(re.escape(brand.lower()), '', cleaned, flags=re.IGNORECASE)
    # Normalize whitespace
    cleaned = ' '.join(cleaned.split())
    return cleaned


def extract_brand(name):
    """Extract brand from product name."""
    if not name:
        return ""
    name_lower = str(name).lower()
    for brand in BRAND_BLACKLIST:
        if brand.lower() in name_lower:
            return brand.lower()
    # Check first word
    first_word = str(name).split()[0].lower() if str(name).split() else ""
    if first_word and re.search(r'[A-Za-z]{3,}', first_word):
        return first_word
    return ""


def extract_product_type(name):
    """Extract product type (guitar, piano, mixer, etc.) from name."""
    if not name:
        return ""
    name_lower = str(name).lower()
    types = [
        'guitar', 'piano', 'keyboard', 'mixer', 'microphone', 'mic', 'headphone',
        'speaker', 'amplifier', 'amp', 'cable', 'stand', 'case', 'bag', 'pedal',
        'drum', 'cymbal', 'violin', 'flute', 'recorder', 'saxophone', 'trumpet',
        'clarinet', 'accordion', 'banjo', 'ukulele', 'mandolin', 'synth',
        'controller', 'interface', 'monitor', 'subwoofer', 'tuner', 'metronome',
        'strap', 'pick', 'string', 'bow', 'rosin', 'mute', 'capo', 'slide',
        'power supply', 'adapter', 'charger', 'battery', 'cable', 'connector',
        'adapter', 'holder', 'mount', 'bracket', 'rack', 'shelf', 'desk',
        'stool', 'chair', 'bench', 'stand', 'light', 'lamp',
    ]
    found = []
    for t in types:
        if t in name_lower:
            found.append(t)
    return ' '.join(found[:2]) if found else ""


def names_compatible(p1, p2):
    """Check if two products are compatible enough to be grouped."""
    brand1 = extract_brand(p1["product_name"])
    brand2 = extract_brand(p2["product_name"])
    type1 = extract_product_type(p1["product_name"])
    type2 = extract_product_type(p2["product_name"])

    # If both have brands and they differ, not compatible
    if brand1 and brand2 and brand1 != brand2:
        return False

    # If both have product types and they differ significantly, not compatible
    if type1 and type2:
        # Check if types overlap
        t1_words = set(type1.split())
        t2_words = set(type2.split())
        if not t1_words.intersection(t2_words):
            # "case" vs "guitar" = not compatible
            # But "guitar" vs "classical guitar" = compatible
            return False

    # Check name similarity
    n1 = clean_name_for_matching(p1["product_name"])
    n2 = clean_name_for_matching(p2["product_name"])
    if n1 and n2:
        score = fuzz.token_set_ratio(n1, n2)
        if score < 60:
            return False

    return True


def match_products(all_products):
    """
    Match products across ALL stores.
    Strategy:
    1. Group by exact clean_model match (min 5 chars) + brand/type verification
    2. For unmatched, use fuzzy name matching (threshold 90)
    Returns list of groups, each with products from multiple stores.
    """
    print(f"\n{'='*60}")
    print(f"[MATCH] Matching {len(all_products)} products across all stores")
    print(f"{'='*60}")

    groups = {}  # match_key -> list of products
    unmatched = []  # products that couldn't be matched by clean_model

    # Step 1: Group by clean_model (exact match, min 3 chars)
    # Only one product per store per group
    for p in all_products:
        cm = p["clean_model"]
        if cm and len(cm) >= 3:
            if cm not in groups:
                groups[cm] = []
            # Don't add if same store already in this group
            existing_stores = set(p2["store_name"] for p2 in groups[cm])
            if p["store_name"] not in existing_stores:
                groups[cm].append(p)
            else:
                # Same store, same model — keep the one with more info (longer name or lower price)
                existing = next(p2 for p2 in groups[cm] if p2["store_name"] == p["store_name"])
                if len(p["product_name"]) > len(existing["product_name"]):
                    groups[cm].remove(existing)
                    groups[cm].append(p)
                unmatched.append(p)
        else:
            unmatched.append(p)

    model_matched = sum(len(v) for v in groups.values())
    print(f"  Step 1 - Clean model (>=5 chars): {model_matched} products in {len(groups)} groups")
    print(f"  Unmatched: {len(unmatched)} products")

    # Step 1b: Validate groups — remove incompatible products from each group
    validated_groups = {}
    rejected_from_model = []
    for key, products in groups.items():
        if len(products) <= 1:
            validated_groups[key] = products
            continue

        # Keep the first product as anchor, check compatibility
        anchor = products[0]
        compatible = [anchor]
        for p in products[1:]:
            if names_compatible(anchor, p):
                compatible.append(p)
            else:
                rejected_from_model.append(p)

        validated_groups[key] = compatible

    groups = validated_groups
    rejected_count = len(rejected_from_model)
    print(f"  Step 1b - Validated: rejected {rejected_count} incompatible products from model groups")

    # Add rejected products to unmatched
    unmatched.extend(rejected_from_model)

    # Step 2: Fuzzy name matching for unmatched products
    existing_group_names = {}
    for key, products in groups.items():
        clean_name = clean_name_for_matching(products[0]["product_name"])
        if clean_name:
            existing_group_names[key] = clean_name

    fuzzy_matches = 0
    for p in unmatched:
        clean_n = clean_name_for_matching(p["product_name"])
        if not clean_n or len(clean_n) < 5:
            key = f"name_{p['store_name']}_{p['product_name'][:30]}"
            if key not in groups:
                groups[key] = []
            groups[key].append(p)
            continue

        # Try to find a match among existing groups
        if existing_group_names:
            result = process.extractOne(
                clean_n,
                list(existing_group_names.values()),
                scorer=fuzz.token_set_ratio,
                score_cutoff=90
            )

            if result:
                match_name, score, match_idx = result
                group_keys = list(existing_group_names.keys())
                match_key = group_keys[match_idx]

                # Verify compatibility
                anchor = groups[match_key][0]
                if names_compatible(anchor, p):
                    existing_stores = set(p2["store_name"] for p2 in groups[match_key])
                    if p["store_name"] not in existing_stores:
                        groups[match_key].append(p)
                        fuzzy_matches += 1
                        continue

        # No match found, create own group
        key = f"name_{p['store_name']}_{p['product_name'][:30]}"
        if key not in groups:
            groups[key] = []
        groups[key].append(p)

    print(f"  Step 2 - Fuzzy matching (>=90): {fuzzy_matches} products matched")
    print(f"  Step 3 - Solo groups: {len([k for k in groups if k.startswith('name_')])} products in solo groups")

    # Deduplicate within each group — one product per store
    final_groups = {}
    for key, products in groups.items():
        seen_stores = set()
        seen_sigs = set()
        deduped = []
        for p in products:
            sig = (p["store_name"], p["product_name"][:50])
            # Skip if same store already in group
            if p["store_name"] in seen_stores:
                continue
            if sig not in seen_sigs:
                seen_sigs.add(sig)
                seen_stores.add(p["store_name"])
                deduped.append(p)
        if deduped:
            final_groups[key] = deduped

    multi_store = sum(1 for v in final_groups.values() if len(set(p["store_name"] for p in v)) > 1)
    print(f"\n  Final: {len(final_groups)} product groups ({multi_store} with multiple stores)")

    return final_groups


def fetch_image_url(product_url):
    """Keep the legacy entry point while enforcing direct-image validation."""
    return fetch_image_for_link(product_url, "Acoustic")


def save_to_db(groups):
    """Save matched product groups to SQLite."""
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Store priority for display name and image
    STORE_PRIORITY = ["Largo", "Musikis-Saxli", "Mireli", "Acoustic", "JinoMusic", "Musicroom", "Geovoice"]

    # Store name variants that should be stripped from product display names
    STORE_NAME_PATTERNS = [
        r'\bMusic\s*Room\b',
        r'\bMusicroom\b',
        r'\bJinoMusic\b',
        r'\bJino\b',
        r'\bLargo\b',
        r'\bMusikis[-\s]?Saxli\b',
        r'\bMireli\b',
        r'\bAcoustic\b',
        r'\bGeovoice\b',
        r'\bGeo[-\s]?Voice\b',
        r'-\s*Music\s*Room$',
    ]
    store_name_re = re.compile('|'.join(STORE_NAME_PATTERNS), re.IGNORECASE)

    def clean_store_from_name(name):
        """Remove store names from product display name."""
        cleaned = store_name_re.sub('', name)
        # Clean up leftover artifacts: double spaces, leading/trailing dashes
        cleaned = re.sub(r'\s+', ' ', cleaned)
        cleaned = re.sub(r'\s*-\s*$', '', cleaned)
        cleaned = re.sub(r'^\s*-\s*', '', cleaned)
        return cleaned.strip()

    total_listings = 0
    for match_key, products in groups.items():
        # Pick best display name: prioritize by store, then pick cleanest
        def name_score(p):
            store_idx = STORE_PRIORITY.index(p["store_name"]) if p["store_name"] in STORE_PRIORITY else 99
            has_latin = 1 if re.search(r'[A-Za-z]{3,}', p["product_name"]) else 0
            has_brand = 1 if extract_brand(p["product_name"]) else 0
            # Prefer: store priority, then brand presence, then latin chars, then LONGER names (to avoid model-only)
            return (store_idx, -has_brand, -has_latin, -len(p["product_name"]))

        best_name_product = min(products, key=name_score)
        display_name = best_name_product["product_name"]

        # Strip any store names from the display name
        display_name = clean_store_from_name(display_name)

        # If the chosen name has no brand or is too short, enrich with brand from other listings
        current_brand = extract_brand(display_name)
        if not current_brand or len(display_name.strip()) < 15:
            for p in products:
                b = extract_brand(p["product_name"])
                if b and b.lower() not in display_name.lower():
                    # Use proper capitalization from BRAND_BLACKLIST if available
                    for bb in BRAND_BLACKLIST:
                        if bb.lower() == b:
                            b = bb
                            break
                    display_name = f"{b} {display_name}".strip()
                    break

        # Get image: try Acoustic first, then JinoMusic (has images in Excel), then any store
        image_url = ""
        for store in STORE_PRIORITY:
            for p in products:
                if p["store_name"] == store and p["image_url"]:
                    image_url = p["image_url"]
                    break
            if image_url:
                break

        prices = [p["price"] for p in products if p["price"] and p["price"] > 0]
        store_count = len(set(p["store_name"] for p in products))

        # Insert product group
        c.execute("""
            INSERT OR REPLACE INTO product_groups
            (match_key, display_name, image_url, store_count, min_price, max_price, last_updated)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (match_key, display_name, image_url, store_count,
              min(prices) if prices else None,
              max(prices) if prices else None,
              now))

        group_id = c.lastrowid

        # Insert listings
        for p in products:
            c.execute("""
                INSERT OR REPLACE INTO listings
                (group_id, product_name, store_name, price, link, image_url, clean_id, clean_model)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (group_id, p["product_name"], p["store_name"], p["price"],
                  p["link"], p["image_url"], p["clean_id"], p["clean_model"]))
            total_listings += 1

    conn.commit()

    # Log sync
    c.execute("""
        INSERT INTO sync_log (sync_time, rows_synced, images_fetched, errors)
        VALUES (?, ?, ?, ?)
    """, (now, total_listings, 0, 0))
    conn.commit()

    conn.close()
    print(f"\n  Saved {len(groups)} groups, {total_listings} listings to DB")
    return total_listings


def fetch_missing_images(limit=100):
    """Fetch only directly reachable original image URLs from all stores."""
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    store_order = ["Largo", "Musikis-Saxli", "Mireli", "Acoustic", "JinoMusic", "Musicroom", "Geovoice"]
    images_fetched = 0

    for store in store_order:
        remaining = max(1, limit - images_fetched)
        c.execute("""
            SELECT DISTINCT l.link, l.image_url
            FROM listings l
            JOIN product_groups g ON l.group_id = g.id
            WHERE l.store_name = ?
            AND l.link != '' AND l.link != 'N/A'
            AND (g.image_url = '' OR g.image_url IS NULL)
            LIMIT ?
        """, (store, remaining))
        listings = c.fetchall()

        if not listings:
            continue

        print(f"\n  Validating {len(listings)} image sources from {store}...")
        for link, existing_image_url in listings:
            image_url = fetch_image_for_link(link, store, existing_image_url)
            if image_url:
                c.execute("UPDATE listings SET image_url = ? WHERE link = ?", (image_url, link))
                c.execute("""
                    UPDATE product_groups SET image_url = ?
                    WHERE id = (SELECT group_id FROM listings WHERE link = ? LIMIT 1)
                """, (image_url, link))
                conn.commit()
                images_fetched += 1
                print(f"    [IMG] Direct URL accepted: {link[:50]}...")
            else:
                print(f"    [IMG] Direct URL unavailable: {link[:50]}...")
            time.sleep(0.2)
            if images_fetched >= limit:
                break

        if images_fetched >= limit:
            break

    c.execute("UPDATE sync_log SET images_fetched = ? WHERE id = last_insert_rowid()", (images_fetched,))
    conn.close()
    return images_fetched


def sync_all(image_limit=200):
    """Full sync: load all stores, match, save, fetch images."""
    print(f"\n{'='*60}")
    print(f"MUSIC COMPARE - FULL SYNC v2")
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'='*60}")

    # Preserve existing image URLs before dropping tables.
    # New products will still be missing images and fetched below.
    old_group_images = {}
    old_listing_images = {}
    if os.path.exists(DB_PATH):
        try:
            conn = sqlite3.connect(DB_PATH)
            c = conn.cursor()
            c.execute("SELECT match_key, image_url FROM product_groups WHERE image_url != '' AND image_url IS NOT NULL")
            old_group_images = {row[0]: row[1] for row in c.fetchall()}
            c.execute("SELECT link, image_url FROM listings WHERE image_url != '' AND image_url IS NOT NULL")
            old_listing_images = {row[0]: row[1] for row in c.fetchall()}
            conn.close()
            print(f"  Preserving {len(old_group_images)} group images and {len(old_listing_images)} listing images")
        except Exception as e:
            print(f"  [WARN] Could not preserve old image URLs: {e}")

    init_db()

    # Step 1: Load all store data
    print(f"\n[STEP 1] Loading all store data...")
    all_products = []
    for store_name, file_path in STORE_FILES.items():
        products = load_store_data(store_name, file_path)
        all_products.extend(products)

    print(f"\n  Total products loaded: {len(all_products)}")

    # Step 2: Match products across all stores
    print(f"\n[STEP 2] Matching products...")
    groups = match_products(all_products)

    # Step 3: Save to database
    print(f"\n[STEP 3] Saving to database...")
    total_listings = save_to_db(groups)

    # Step 3b: Restore previously known image URLs where keys/links still match.
    if old_group_images or old_listing_images:
        try:
            conn = sqlite3.connect(DB_PATH)
            c = conn.cursor()
            restored_groups = 0
            for match_key, image_url in old_group_images.items():
                c.execute("UPDATE product_groups SET image_url = ? WHERE match_key = ? AND (image_url = '' OR image_url IS NULL)", (image_url, match_key))
                restored_groups += c.rowcount
            restored_listings = 0
            for link, image_url in old_listing_images.items():
                c.execute("UPDATE listings SET image_url = ? WHERE link = ? AND (image_url = '' OR image_url IS NULL)", (image_url, link))
                restored_listings += c.rowcount
            conn.commit()
            conn.close()
            print(f"  Restored {restored_groups} group images and {restored_listings} listing images")
        except Exception as e:
            print(f"  [WARN] Could not restore old image URLs: {e}")

    # Step 4: Fetch images from any store (prioritize Acoustic)
    print(f"\n[STEP 4] Fetching missing images (limit={image_limit})...")
    images_fetched = fetch_missing_images(limit=image_limit)

    print(f"\n{'='*60}")
    print(f"SYNC COMPLETE")
    print(f"  Product groups: {len(groups)}")
    print(f"  Total listings: {total_listings}")
    print(f"  Images fetched: {images_fetched}")
    print(f"{'='*60}")

    return len(groups), total_listings, images_fetched


if __name__ == "__main__":
    sync_all()
