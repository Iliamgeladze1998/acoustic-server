"""
MyMarket → Google Sheets tracker.

1. Scrapes all listings from seller profile (https://mymarket.ge/ka/sellers/{USER_ID}/)
2. Visits each listing page to extract:
   - MyMarket ID (from URL)
   - Title, price, condition
   - "Art:" code from description (Temu product code)
3. Builds Temu URL from Art code
4. Writes everything to Google Sheets
"""
from __future__ import annotations

import json
import re
import time
import os
from playwright.sync_api import sync_playwright
from google.oauth2 import service_account
from googleapiclient.discovery import build

# ── Config ──────────────────────────────────────────────────────────────
USER_ID = "4867838"
USER_NAME = "Ilia Mgeladze"
SELLER_URL = f"https://mymarket.ge/ka/sellers/{USER_ID}/"

CREDS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                          "avid-keel-464403-k8-66dfded4aa4f.json")
SHEET_ID = "16VTT_nkGbuagwgpo1bWEtE0dxWzS00ZCZLfRCznwntk"
SHEET_RANGE = "Sheet1!A:K"

# Column layout in Google Sheets:
# A: MyMarket ID | B: დასახელება | C: MyMarket ფასი | D: Temu ფასი | E: შიპინგი | F: მარაგი | G: მიწოდების დრო | H: მდგომარეობა | I: Art Code | J: Temu ლინკი | K: MyMarket ლინკი

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]

# Temu cookies for authenticated access
TEMU_COOKIES = [
    {"name": "AccessToken", "value": "ARACFBC5RBEVFNI57XMYQN36BBQOQHXISDKOIICBG3XIBQG6LQTA01104b933404", "domain": ".temu.com", "path": "/"},
    {"name": "isLogin", "value": "1784208087103", "domain": ".temu.com", "path": "/"},
    {"name": "user_uin", "value": "BDB775KX3KTIEWLIBJBGS3OK3MROJKR7MYFT6YVM", "domain": ".temu.com", "path": "/"},
    {"name": "currency", "value": "GEL", "domain": "www.temu.com", "path": "/"},
    {"name": "language", "value": "en", "domain": "www.temu.com", "path": "/"},
    {"name": "region", "value": "75", "domain": "www.temu.com", "path": "/"},
    {"name": "timezone", "value": "Asia%2FTbilisi", "domain": "www.temu.com", "path": "/"},
    {"name": "_bee", "value": "ZTKNEmd2I8HMq4LkfRJwY1Js6RPP1g0H", "domain": ".temu.com", "path": "/"},
    {"name": "api_uid", "value": "CnDwOGpY2sAYLIhO+9LAAg==", "domain": ".temu.com", "path": "/"},
    {"name": "dilx", "value": "uFaOoVE4wtQ9NppwG6ajh", "domain": ".temu.com", "path": "/"},
    {"name": "njrpl", "value": "ZTKNEmd2I8HMq4LkfRJwY1Js6RPP1g0H", "domain": ".temu.com", "path": "/"},
    {"name": "hfsc", "value": "L3yCfIsw4T7w1pfIfw==", "domain": ".temu.com", "path": "/"},
    {"name": "_nano_fp", "value": "GWZoSmi2Ini2kji2L_ik3#mfTTSt6fjWljkWurxJwZJ", "domain": "www.temu.com", "path": "/"},
    {"name": "_ttc", "value": "3.fnw8kS6MT9Ef.1815744087", "domain": "www.temu.com", "path": "/"},
]


# ── Google Sheets ───────────────────────────────────────────────────────
def get_sheets_service():
    creds = service_account.Credentials.from_service_account_file(CREDS_FILE, scopes=SCOPES)
    return build("sheets", "v4", credentials=creds)


def read_sheet(service) -> list[list[str]]:
    result = service.spreadsheets().values().get(
        spreadsheetId=SHEET_ID, range=SHEET_RANGE
    ).execute()
    return result.get("values", [])


def write_sheet(service, rows: list[list[str]]):
    # Read existing Temu prices (column D, index 3) keyed by MyMarket ID (column A, index 0)
    existing_temu_prices = {}
    try:
        existing = read_sheet(service)
        for row in existing[1:]:  # skip header
            if len(row) > 3 and row[0] and row[3]:
                existing_temu_prices[row[0]] = row[3]
    except Exception:
        pass

    # Fill in preserved Temu prices
    for row in rows:
        mid = row[0]
        if mid in existing_temu_prices and not row[3]:
            row[3] = existing_temu_prices[mid]

    # Clear existing data
    service.spreadsheets().values().clear(
        spreadsheetId=SHEET_ID, range=SHEET_RANGE
    ).execute()

    # Write header + data
    header = [["MyMarket ID", "დასახელება", "MyMarket ფასი", "Temu ფასი", "შიპინგი", "მარაგი", "მიწოდების დრო", "მდგომარეობა", "Art Code", "Temu ლინკი", "MyMarket ლინკი"]]
    all_rows = header + rows

    body = {"values": all_rows}
    service.spreadsheets().values().update(
        spreadsheetId=SHEET_ID, range=SHEET_RANGE,
        valueInputOption="RAW", body=body
    ).execute()


# ── MyMarket Scraper ────────────────────────────────────────────────────
def scrape_listing_urls() -> list[dict]:
    """Scrape seller profile to get all listing URLs and basic info."""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )
        page = context.new_page()

        page.goto(SELLER_URL, timeout=20000)
        time.sleep(3)
        page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
        time.sleep(2)

        listings = page.evaluate("""
        () => {
            const results = [];
            const seen = new Set();
            const cards = document.querySelectorAll('article.product-card-search, [data-testid="product-card"]');

            for (const card of cards) {
                const link = card.closest('a') || card.querySelector('a');
                if (!link) continue;
                const fullUrl = link.href;
                if (seen.has(fullUrl)) continue;
                seen.add(fullUrl);

                const allText = card.innerText.trim();
                const lines = allText.split('\\n').map(l => l.trim()).filter(l => l);

                let title = '';
                for (const line of lines) {
                    if (line === 'ახალი' || line === 'მეორადი') continue;
                    if (line === 'ფიზიკური პირი' || line === 'იურიდიული პირი') continue;
                    if (line.match(/^\\d+[.,]?\\d*\\s*₾/)) continue;
                    if (line === 'ფასი შეთანხმებით') continue;
                    title = line;
                    break;
                }

                let price = '';
                const priceMatch = allText.match(/([\\d\\s]+\\.\\d{2})\\s*₾/);
                if (priceMatch) price = priceMatch[0].trim();
                else if (allText.includes('ფასი შეთანხმებით')) price = 'ფასი შეთანხმებით';

                let condition = '';
                if (allText.includes('ახალი')) condition = 'ახალი';
                else if (allText.includes('მეორადი')) condition = 'მეორადი';

                // Extract MyMarket ID from URL
                const idMatch = fullUrl.match(/\\/pr\\/(\\d+)\\//);
                const mymarketId = idMatch ? idMatch[1] : '';

                if (title && mymarketId) {
                    results.push({
                        mymarket_id: mymarketId,
                        title: title.substring(0, 200),
                        price: price,
                        condition: condition,
                        url: fullUrl
                    });
                }
            }
            return results;
        }
        """)

        browser.close()
        return listings


def scrape_listing_detail(url: str) -> str:
    """Visit a listing page and extract 'Art:' code from description."""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )
        page = context.new_page()

        page.goto(url, timeout=20000)
        time.sleep(3)

        body_text = page.inner_text("body")

        # Search for "Art:" pattern in description
        art_match = re.search(r'[Aa]rt[:\s]+(\d+)', body_text)
        art_code = art_match.group(1) if art_match else ""

        browser.close()
        return art_code


def scrape_temu_info(art_code: str) -> dict:
    """Visit Temu product page and extract price, shipping, stock, delivery time."""
    if not art_code:
        return {"price": "", "shipping": "", "stock": "", "delivery": ""}

    temu_url = build_temu_url(art_code)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )
        context.add_cookies(TEMU_COOKIES)
        page = context.new_page()

        try:
            page.goto(temu_url, timeout=20000)
            time.sleep(5)

            body = page.inner_text("body")
            lines = [l.strip() for l in body.split("\n") if l.strip()]

            # ── Price ──
            price = ""
            for line in lines:
                m = re.match(r"^(\d+\.\d{2})\s*₾$", line)
                if m:
                    val = float(m.group(1))
                    if val >= 40.0:
                        continue
                    price = f"{m.group(1)} ₾"
                    break
            if not price:
                gel_prices = re.findall(r'(\d+\.\d{2})\s*₾', body)
                for p_val in gel_prices:
                    if float(p_val) < 40.0:
                        price = f"{p_val} ₾"
                        break

            # ── Shipping ──
            shipping = ""
            for line in lines:
                if 'Standard:' in line and ('FREE' in line or 'free' in line):
                    shipping = "უფასო"
                    break
                elif 'Standard:' in line and re.search(r'(\d+\.\d{2})\s*₾', line):
                    ship_match = re.search(r'(\d+\.\d{2})\s*₾', line)
                    if ship_match:
                        shipping = f"{ship_match.group(1)} ₾"
                        break
            if not shipping and 'Free shipping' in body:
                shipping = "უფასო"

            # ── Delivery time ──
            delivery = ""
            for line in lines:
                if 'Delivery:' in line and 'business days' in line:
                    delivery_match = re.search(r'Delivery:\s*(.+?)(?:\.|$)', line)
                    if delivery_match:
                        delivery = delivery_match.group(1).strip()
                        break
            if not delivery:
                delivery_match = re.search(r'(\d+\s*-\s*\d+\s*business days)', body)
                if delivery_match:
                    delivery = delivery_match.group(1)

            # ── Stock ──
            stock = ""
            if 'sold out' in body.lower() or 'out of stock' in body.lower() or 'unavailable' in body.lower():
                stock = "არ არის მარაგში"
            elif 'low stock' in body.lower():
                stock = "მცირე მარაგი"
            else:
                # Check for "Only X left" pattern
                only_match = re.search(r'Only\s+(\d+)\s+left', body, re.IGNORECASE)
                if only_match:
                    stock = f"მცირე მარაგი ({only_match.group(1)} ცალი)"
                elif 'Add to cart' in body or 'Buy now' in body:
                    stock = "მარაგშია"

            browser.close()
            return {"price": price, "shipping": shipping, "stock": stock, "delivery": delivery}

        except Exception as e:
            print(f"       Temu info error: {e}")

        browser.close()
        return {"price": "", "shipping": "", "stock": "", "delivery": ""}


def build_temu_url(art_code: str) -> str:
    """Build a Temu product URL from Art code."""
    if not art_code:
        return ""
    return f"https://www.temu.com/ge-en/g-{art_code}.html"


# ── Main ────────────────────────────────────────────────────────────────
def main():
    print(f"Scraping listings for {USER_NAME} (ID: {USER_ID})...")
    print(f"URL: {SELLER_URL}\n")

    # Step 1: Get all listing URLs
    listings = scrape_listing_urls()
    print(f"Found {len(listings)} listing(s)\n")

    if not listings:
        print("No listings found. Exiting.")
        return

    # Step 2: Visit each listing to extract Art code
    rows = []
    for i, item in enumerate(listings, 1):
        print(f"  [{i}/{len(listings)}] {item['title'][:50]}...")
        print(f"       MyMarket ID: {item['mymarket_id']}")

        art_code = scrape_listing_detail(item["url"])
        temu_url = build_temu_url(art_code)

        temu_info = {"price": "", "shipping": "", "stock": "", "delivery": ""}
        if art_code:
            print(f"       Art Code: {art_code}")
            print(f"       Temu URL: {temu_url[:60]}...")
            temu_info = scrape_temu_info(art_code)
            print(f"       Temu Price: {temu_info['price'] or '(not found)'}")
            print(f"       Shipping: {temu_info['shipping'] or '(not found)'}")
            print(f"       Stock: {temu_info['stock'] or '(not found)'}")
            print(f"       Delivery: {temu_info['delivery'] or '(not found)'}")
        else:
            print(f"       Art Code: (not found)")

        rows.append([
            item["mymarket_id"],
            item["title"],
            item["price"],
            temu_info["price"],
            temu_info["shipping"],
            temu_info["stock"],
            temu_info["delivery"],
            item["condition"],
            art_code,
            temu_url,
            item["url"]
        ])
        print()

    # Step 3: Write to Google Sheets
    print("Writing to Google Sheets...")
    service = get_sheets_service()
    write_sheet(service, rows)
    print(f"Done! {len(rows)} row(s) written to sheet.")
    print(f"Sheet: https://docs.google.com/spreadsheets/d/{SHEET_ID}/edit")


if __name__ == "__main__":
    main()
