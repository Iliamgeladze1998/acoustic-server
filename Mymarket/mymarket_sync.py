#!/usr/bin/env python3
"""
MyMarket → Google Sheet სინქრონიზაცია.

ყოველ N წამში შეამოწმებს MyMarket-ის "ჩემი განცხადებები" გვერდს,
ამოიღებს ახალ განცხადებებს და შეიყვანს "მარაგები" ტაბში.
უნიკალური MyMarket ID-ით შეამოწმებს დუბლიკატებს.

'მარაგები' tab სვეტები:
A: MyMarket ID, B: დასახელება, C: MyMarket ფასი, D: Temu ფასი, E: შიპინგი,
F: მარაგი, G: მიწოდების დრო, H: მდგომარეობა, I: Art Code, J: Temu ლინკი, K: MyMarket ლინკი
"""

import os
import re
import time
import json
import gspread
from google.oauth2.service_account import Credentials
from playwright.sync_api import sync_playwright

# ── Config ──────────────────────────────────────────────────────────────
SHEET_ID = "16VTT_nkGbuagwgpo1bWEtE0dxWzS00ZCZLfRCznwntk"
CREDENTIALS_FILE = "/root/Mymarket/avid-keel-464403-k8-66dfded4aa4f.json"
MYMARKET_COOKIES_FILE = "/root/Mymarket/mymarket_cookies.json"
TAB_INVENTORY = "მარაგები"
POLL_INTERVAL = 60  # წამები

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


def get_spreadsheet():
    scopes = [
        "https://spreadsheets.google.com/feeds",
        "https://www.googleapis.com/auth/drive",
    ]
    creds = Credentials.from_service_account_file(CREDENTIALS_FILE, scopes=scopes)
    client = gspread.authorize(creds)
    return client.open_by_key(SHEET_ID)


def get_existing_ids(inv_sheet):
    """აბრუნებს უკვე შეყვანილი პროდუქტების ID-ების სეტს."""
    records = inv_sheet.get_all_records()
    ids = set()
    for row in records:
        pid = str(row.get("MyMarket ID", "")).strip()
        if pid:
            ids.add(pid)
    return ids


def scrape_mymarket_product(page, mymarket_link):
    """MyMarket პროდუქტის გვერდიდან Art Code და ფასის მოძებნა."""
    art_code = ""
    price = ""
    try:
        page.goto(mymarket_link, timeout=30000, wait_until="domcontentloaded")
        time.sleep(8)

        # ვაღიტავებთ სრულ აღწერას
        expand = page.locator("xpath=/html/body/div[2]/main/main/div[1]/div/div[3]/div[2]/div[2]/div[4]/span[2]")
        if expand.count() > 0:
            expand.first.click()
            time.sleep(3)

        # ვეძებთ Art Code-ს მთელ ტექსტში
        body_text = page.inner_text("body")
        art_match = re.search(r'[Aa]rt[:\s]+(\d+)', body_text)
        if art_match:
            art_code = art_match.group(1)

        # ვეძებთ ფასს — ყველაზე დიდი font-ის მქონე ფასი მთავარია
        price_els = page.evaluate("""() => {
            const results = [];
            const all = document.querySelectorAll('*');
            for (const el of all) {
                const text = el.innerText?.trim() || '';
                if (text.match(/^\\d+\\.\\d{2}\\s*₾$/) && el.offsetParent !== null) {
                    const style = window.getComputedStyle(el);
                    const fontSize = parseFloat(style.fontSize);
                    const rect = el.getBoundingClientRect();
                    if (rect.top > 0 && rect.top < 600) {
                        results.push({text: text, fontSize: fontSize, y: Math.round(rect.top)});
                    }
                }
            }
            results.sort((a, b) => b.fontSize - a.fontSize);
            return results;
        }""")
        if price_els:
            price = price_els[0]['text']

    except Exception as e:
        print(f"      Product page error: {e}")
    return art_code, price


def scrape_temu_info(page, art_code):
    """Temu პროდუქტის გვერდიდან ფასი, შიპინგი, მარაგი, მიწოდების დრო."""
    if not art_code:
        return {"price": "", "shipping": "", "stock": "", "delivery": ""}

    temu_url = f"https://www.temu.com/ge-en/g-{art_code}.html"

    try:
        page.goto(temu_url, timeout=20000)
        time.sleep(5)

        body = page.inner_text("body")
        lines = [l.strip() for l in body.split("\n") if l.strip()]

        # Price — ვეძებთ ფასდაკლებულ ფასს (რაც რეალურად დაუჯდება)
        price = ""

        # 1. "after applying promos to X.XX ₾" — ფასდაკლებული ფასი
        promo_match = re.search(r'after applying promos to\s+(\d+\.\d{2})\s*₾', body)
        if promo_match:
            price = f"{promo_match.group(1)} ₾"
        else:
            # 2. პირველი ფასი რომელიც < 40-ია (უკვე ფასდაკლებული შესაძლოა)
            for line in lines:
                m = re.match(r"^(\d+\.\d{2})\s*₾$", line)
                if m:
                    val = float(m.group(1))
                    if 0.5 <= val < 40.0:
                        price = f"{m.group(1)} ₾"
                        break
            if not price:
                gel_prices = re.findall(r'(\d+\.\d{2})\s*₾', body)
                for p_val in gel_prices:
                    if 0.5 <= float(p_val) < 40.0:
                        price = f"{p_val} ₾"
                        break

        # Shipping
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

        # Delivery time
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

        # Stock — ყურადღება: "sold out" != "sold" (გაყიდული რაოდენობა)
        stock = ""
        body_lower = body.lower()
        # ზუსტად "sold out" ან "out of stock"
        if re.search(r'sold\s*out', body_lower) or 'out of stock' in body_lower or 'unavailable' in body_lower:
            stock = "არ არის მარაგში"
        else:
            only_match = re.search(r'Only\s+(\d+)\s+left', body, re.IGNORECASE)
            if only_match:
                stock = f"მცირე მარაგი ({only_match.group(1)} ცალი)"
            elif 'almost sold out' in body_lower or 'low stock' in body_lower:
                stock = "მცირე მარაგი"
            elif 'Add to cart' in body or 'Buy now' in body or 'Go to cart' in body:
                stock = "მარაგშია"

        return {"price": price, "shipping": shipping, "stock": stock, "delivery": delivery}

    except Exception as e:
        print(f"      Temu info error: {e}")

    return {"price": "", "shipping": "", "stock": "", "delivery": ""}


def fetch_mymarket_products(context):
    """MyMarket-ის API-დან პროდუქტების მიღება browser response capture-ით."""
    page = context.new_page()
    api_data = {}

    def handle_response(response):
        url = response.url
        if "user/products" in url and "StatusID=1" in url:
            try:
                api_data["body"] = response.json()
            except:
                try:
                    api_data["text"] = response.text()
                except:
                    pass

    page.on("response", handle_response)

    try:
        page.goto("https://mymarket.ge/ka/myproducts", timeout=60000, wait_until="networkidle")
        time.sleep(5)
    except Exception as e:
        print(f"  Navigation error: {e}")
        try:
            page.goto("https://mymarket.ge/ka/myproducts", timeout=60000, wait_until="domcontentloaded")
            time.sleep(10)
        except Exception as e2:
            print(f"  Navigation retry error: {e2}")

    page.close()

    if api_data.get("body"):
        prs = api_data["body"].get("data", {}).get("Prs", [])
        products = []
        for pr in prs:
            pid = str(pr.get("product_id", ""))
            title = pr.get("title_4", pr.get("title", pr.get("title_1", "")))
            price = pr.get("price", "")
            slug = pr.get("slug", "")

            mymarket_link = f"https://mymarket.ge/ka/pr/{pid}"
            if slug:
                mymarket_link += f"/{slug}"

            products.append({
                "id": pid,
                "title": title,
                "price": str(price),
                "mymarket_link": mymarket_link,
            })
        return products

    # Fallback: scrape from DOM
    print("  API capture failed, trying DOM scrape...")
    page2 = context.new_page()
    page2.goto("https://mymarket.ge/ka/myproducts", timeout=60000, wait_until="domcontentloaded")
    time.sleep(10)

    products = page2.evaluate("""() => {
        const rows = document.querySelectorAll('#my-products-list .tr');
        const results = [];
        for (const row of rows) {
            if (row.classList.contains('my-products-head')) continue;
            const link = row.querySelector('a[href*="/ka/pr/"]');
            if (!link) continue;
            const href = link.getAttribute('href') || '';
            const idMatch = href.match(/\\/pr\\/(\\d+)/);
            const id = idMatch ? idMatch[1] : '';
            if (!id) continue;
            
            // Get title from row text
            const text = row.innerText.trim();
            // Remove ID prefix
            const title = text.replace(/^ID\\d+/, '').trim().split('\\n')[0];
            
            // Get price — ვეძებთ ფასს ტექსტში (რადგან class-ი არ აქვს)
            let price = '';
            const textParts = text.split('\\n');
            for (const part of textParts) {
                const m = part.trim().match(/^(\\d+\\.\\d{2})$/);
                if (m) {
                    price = m[1];
                    break;
                }
            }
            
            results.push({
                id,
                title: title.substring(0, 100),
                price,
                mymarket_link: 'https://mymarket.ge' + href.split('?')[0],
                cat_id: 0
            });
        }
        return results;
    }""")
    page2.close()
    return products


def sync_to_sheet(ss, context, products):
    """ახალი პროდუქტების დამატება 'მარაგები' ტაბში — სრული ინფორმაციით."""
    inv_sheet = ss.worksheet(TAB_INVENTORY)
    existing_ids = get_existing_ids(inv_sheet)

    # ცალკე გვერდი Art Code-ის და Temu ინფორმაციის მოსაძებნად
    detail_page = context.new_page()
    # Temu cookies დამატება იმავე context-ში უკვე არის

    new_count = 0
    for pr in products:
        pid = pr["id"]
        if pid in existing_ids:
            continue

        title = pr["title"]
        mymarket_price = pr["price"]
        mymarket_link = pr["mymarket_link"]

        print(f"  ახალი პროდუქტი: ID={pid} | {title[:50]} | {mymarket_price}")

        # 1. Art Code და MyMarket ფასი პროდუქტის გვერდიდან
        print(f"      პროდუქტის გვერდის დამუშავება...")
        art_code, mm_page_price = scrape_mymarket_product(detail_page, mymarket_link)
        print(f"      Art Code: {art_code or '(ვერ მოიძებნა)'} | MM ფასი: {mm_page_price or '(ვერ მოიძებნა)'}")

        # თუ ფასი ცარიელია API/DOM-დან, გამოვიყენოთ გვერდიდან მოსული
        if not mymarket_price and mm_page_price:
            mymarket_price = mm_page_price

        # 2. Temu ლინკი და Temu-დან ინფორმაცია
        temu_link = f"https://www.temu.com/ge-en/g-{art_code}.html" if art_code else ""
        temu_price = ""
        shipping = ""
        stock = ""
        delivery = ""

        if art_code:
            print(f"      Temu-დან ინფორმაციის მიღება...")
            temu_info = scrape_temu_info(detail_page, art_code)
            temu_price = temu_info["price"]
            shipping = temu_info["shipping"]
            stock = temu_info["stock"]
            delivery = temu_info["delivery"]
            print(f"      Temu ფასი: {temu_price or '-'} | შიპინგი: {shipping or '-'} | მარაგი: {stock or '-'} | მიწოდება: {delivery or '-'}")

        # 3. MyMarket ფასის ფორმატირება
        mm_price_display = mymarket_price
        if mm_price_display and not mm_price_display.endswith("₾"):
            mm_price_display = f"{mm_price_display} ₾"
        if not mm_price_display:
            mm_price_display = mm_page_price or ""

        new_row = [
            pid,              # A: MyMarket ID
            title,            # B: დასახელება
            mm_price_display, # C: MyMarket ფასი
            temu_price,       # D: Temu ფასი
            shipping,         # E: შიპინგი
            stock,            # F: მარაგი
            delivery,         # G: მიწოდების დრო
            "ახალი",          # H: მდგომარეობა
            art_code,         # I: Art Code
            temu_link,        # J: Temu ლინკი
            mymarket_link,    # K: MyMarket ლინკი
        ]

        inv_sheet.append_row(new_row)
        existing_ids.add(pid)
        new_count += 1
        print(f"      → შიტში დაემატა!")

    detail_page.close()
    return new_count


def remove_deleted_products(ss, mymarket_ids):
    """შიტიდან წაშლის პროდუქტებს რომლებიც MyMarket-ზე აღარ არის."""
    inv_sheet = ss.worksheet(TAB_INVENTORY)
    records = inv.get_all_records()
    
    rows_to_delete = []
    for i, row in enumerate(records, start=2):  # row 1 = headers
        pid = str(row.get("MyMarket ID", "")).strip()
        if pid and pid not in mymarket_ids:
            rows_to_delete.append((i, pid, row.get("დასახელება", "")[:30]))
    
    # წაშლა ქვედა რიგიდან ზედაზე (რომ row numbers არ შეიცვალოს)
    for row_num, pid, title in reversed(rows_to_delete):
        inv_sheet.delete_rows(row_num)
        print(f"  წაიშალა: ID={pid} | {title} (MyMarket-ზე აღარ არის)")
    
    return len(rows_to_delete)


def main():
    print(f"[{time.strftime('%H:%M:%S')}] MyMarket Sync დაიწყო")

    # Google Sheet
    try:
        ss = get_spreadsheet()
        print("  Google Sheet დაკავშირდა")
    except Exception as e:
        print(f"  Google Sheet error: {e}")
        return

    # MyMarket cookies
    with open(MYMARKET_COOKIES_FILE) as f:
        mymarket_cookies = json.load(f)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True, args=[
            "--no-sandbox",
            "--disable-setuid-sandbox",
            "--disable-dev-shm-usage",
        ])
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            viewport={"width": 1280, "height": 800},
        )
        context.add_cookies(mymarket_cookies)
        context.add_cookies(TEMU_COOKIES)

        print(f"  სინქრონიზაციის ლუპი დაიწყო (ყოველ {POLL_INTERVAL} წამში)")

        while True:
            print(f"\n[{time.strftime('%H:%M:%S')}] სინქრონიზაცია...")

            try:
                products = fetch_mymarket_products(context)
                print(f"  MyMarket-ზე ნაპოვნია {len(products)} განცხადება")

                if products:
                    # 1. ახალი პროდუქტების დამატება
                    new_count = sync_to_sheet(ss, context, products)
                    if new_count > 0:
                        print(f"  დაემატა {new_count} ახალი პროდუქტი 'მარაგები'ში")
                    else:
                        print(f"  ახალი პროდუქტი არ არის")

                    # 2. წაშლილი პროდუქტების მოცილება შიტიდან
                    mymarket_ids = {pr["id"] for pr in products}
                    deleted_count = remove_deleted_products(ss, mymarket_ids)
                    if deleted_count > 0:
                        print(f"  წაიშალა {deleted_count} პროდუქტი (MyMarket-ზე აღარ არის)")
                else:
                    print(f"  პროდუქტები ვერ მოიძებნა")

            except Exception as e:
                print(f"  შეცდომა: {e}")

            time.sleep(POLL_INTERVAL)


if __name__ == "__main__":
    main()
