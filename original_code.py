#!/usr/bin/env python3
"""
MyMarket Uploader — Temu-დან მონაცემების ამოღება და MyMarket-ზე ატვირთვა.

სტრუქტურა:
1. 'გამოსაწერი პროდუქცია' tab-დან წაიკითხავს Temu-ს ლინკებს (A სვეტი)
2. Temu-დან ამოიღებს: ფოტო, სახელი, ფასი, აღწერა
3. ფასს +25 ლარს დაუმატებს
4. MyMarket-ზე ატვირთავს cookie-ებით
5. წერს 'გამოწერილია' სტატუსს B სვეტში
6. როცა მონიშნავ 'ვნახე' G სვეტში — პროდუქტი გადადის 'მარაგები' tab-ში და 'გამოსაწერი'დან ამოიშლება

'გამოსაწერი პროდუქცია' tab სვეტები:
A: Temu ლინკი
B: სტატუსი (pending/გამოწერილია/error)
C: MyMarket ლინკი
D: Temu ფასი
E: MyMarket ფასი (+25₾)
F: თარიღი
G: ვნახე (dropdown)

'მარაგები' tab სვეტები:
A: MyMarket ID, B: დასახელება, C: MyMarket ფასი, D: Temu ფასი, E: შიპინგი, F: მარაგი, G: მიწოდების დრო, H: მდგომარეობა, I: Art Code, J: Temu ლინკი, K: MyMarket ლინკი
"""

import os
import re
import time
import json
import requests
from pathlib import Path
from playwright.sync_api import sync_playwright

# Google Sheets
import gspread
from google.oauth2.service_account import Credentials

# Gemini AI
import google.generativeai as genai
GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
genai.configure(api_key=GEMINI_API_KEY)
_gemini_model = genai.GenerativeModel("gemini-flash-lite-latest")

# ── Config ──────────────────────────────────────────────────────────────
SHEET_ID = "16VTT_nkGbuagwgpo1bWEtE0dxWzS00ZCZLfRCznwntk"
CREDENTIALS_FILE = "/root/Mymarket/avid-keel-464403-k8-66dfded4aa4f.json"
TEMU_COOKIES_FILE = "/root/Mymarket/temu_cookies.json"
MYMARKET_COOKIES_FILE = "/root/Mymarket/mymarket_cookies.json"

# Temu cookies for authenticated access (from scraper.py)
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
PHOTO_DIR = "/root/Mymarket/photos"
PRICE_MARKUP = 25  # ლარი
TAB_PENDING = "გამოსაწერი პროდუქცია"
TAB_INVENTORY = "მარაგები"

# MyMarket login credentials
MYMARKET_EMAIL = "mgeladzeilia39@gmail.com"
MYMARKET_PASSWORD = "Setembrini1"

# MyMarket კატეგორიები (ქართულად)
MYMARKET_CATEGORIES = [
    "სახლი და ბაღი", "საოჯახო ტექნიკა", "ტექნიკა", "ნადირობა და თევზაობა", "მუსიკა",
    "საბავშვო", "სილამაზე და მოდა", "მშენებლობა და რემონტი", "სოფლის მეურნეობა", "ცხოველები",
    "სპორტი და დასვენება", "ბიზნესი და დანადგარები", "წიგნები და კანცელარია", "ხელოვნება და საკოლექციო",
    "ავტომობილები", "მოტოციკლეტები", "საავტომობილო ნაწილები", "ჯანდაცვა", "კომპიუტერული ტექნიკა",
    "ტელეფონები და აქსესუარები", "ელექტრონიკა", "სათამაშოები", "სპორტის ინვენტარი",
]

DEFAULT_CATEGORY = "სპორტი და დასვენება"
DEFAULT_SUBCATEGORY = "ველოსიპედის ნაწილი/აქსესუარი"

os.makedirs(PHOTO_DIR, exist_ok=True)


# ── Gemini AI description generation ────────────────────────────────────
def ai_select_from_options(product, options, field_name):
    """Gemini AI-ით გააანალიზებს პროდუქტს და აირჩევს საუკეთესო option-ს მოცემული სიიდან."""
    title = product.get("title", "")
    temu_desc = product.get("description", "")[:500]
    
    options_str = "\n".join([f"{i+1}. {opt}" for i, opt in enumerate(options)])
    prompt = f"""შენ ხარ MyMarket.ge-ის ასისტენტი. გთხოვ გააანალიზო პროდუქტი და აირჩიო ყველაზე შესაბამისი {field_name}.

პროდუქტის სახელი: {title}
პროდუქტის აღწერა: {temu_desc}

ხელმისაწვდომი {field_name}:
{options_str}

უპასუხე მხოლოდ ნომრით (მაგ. 3) ან ზუსტი სახელით, როგორც ჩამონათვალშია. არაფერი დაამატო."""
    
    try:
        response = _gemini_model.generate_content(prompt)
        answer = response.text.strip()
        # ჯერ ვცდილობთ ნომრით
        m = re.match(r'^(\d+)', answer)
        if m:
            idx = int(m.group(1)) - 1
            if 0 <= idx < len(options):
                return options[idx]
        # შემდეგ სახელით
        for opt in options:
            if opt in answer or answer in opt:
                return opt
        # პირველი option
        return options[0] if options else ""
    except Exception as e:
        print(f"  AI select error: {e}")
        return options[0] if options else ""


def generate_description(product):
    """Gemini AI-ით დააგენერირებს მარკეტინგულ აღწერას ქართულად."""
    title = product.get("title", "")
    temu_desc = product.get("description", "")[:800]
    art_code = product.get("art_code", "")
    
    prompt = f"""შექმენი მოკლე, მიმზიდველი მარკეტინგული აღწერა ქართულად MyMarket-ისთვის ამ პროდუქტისთვის:

სახელი: {title}
Temu-ს აღწერა: {temu_desc}

მოთხოვნები:
- ტექსტი უნდა იყოს ქართულად, პროფესიონალური და გასაყიდი ტონით
- აღწერე პროდუქტის თვისებები, გამოყენება, მატერიალი და უპირატესობები
- არ დაწერო ფასი აღწერაში
- 100-150 სიტყვა
- არ დაამატო შესავალი ფრაზები როგორიცაა "აი", "ესაა", "შემოთავაზება", "აღწერა" და ა.შ.
- დაიწყე პირდაპირ პროდუქტის აღწერით
- ბოლოში დაამატე: Art: {art_code}"""
    
    try:
        response = _gemini_model.generate_content(prompt)
        text = response.text.strip()[:3000]
        # მოვშოროთ შესავალი ფრაზები რომ AI-ით გენერაცია არ ჩანდეს
        intro_patterns = [
            "აი,", "აი ", "ესაა", "შემოთავაზება", "აღწერა:", "აღწერა -",
            "MyMarket-ისთვის ოპტიმიზებული", "მიმზიდველი აღწერა",
            "აი, შემოთავაზებული", "აი, MyMarket",
        ]
        for pattern in intro_patterns:
            if text.lower().startswith(pattern.lower()):
                text = text[len(pattern):].strip()
        # მოვშოროთ პირველი ხაზი თუ ის მხოლოდ შესავალია (პირველი \n-მდე)
        if "\n" in text:
            first_line = text.split("\n")[0].strip()
            if len(first_line) < 50 and any(w in first_line.lower() for w in ["აღწერა", "შემოთავაზ", "mymarket", "ოპტიმიზ"]):
                text = "\n".join(text.split("\n")[1:]).strip()
        # დარწმუნდით რომ Art code არის ბოლოში
        if art_code and f"Art: {art_code}" not in text:
            text = text + f"\n\nArt: {art_code}"
        return text
    except Exception as e:
        print(f"  Gemini error: {e}")
        # Fallback — Temu-ს აღწერა + Art code
        if temu_desc:
            return f"{temu_desc}\n\nArt: {art_code}"
        return f"{title}\n\nArt: {art_code}"


# ── MyMarket auto-login ────────────────────────────────────────────────
def login_to_mymarket(context):
    """ავტომატური ლოგინი MyMarket-ზე ემეილით და პაროლით."""
    page = context.new_page()
    try:
        page.goto("https://mymarket.ge/ka/", timeout=30000, wait_until="networkidle")
        time.sleep(5)
        
        # დავხუროთ dialog/cookie consent თუ არსებობს
        try:
            dialog = page.locator("dialog[open]")
            if dialog.count() > 0:
                # დავაჭიროთ დახურვის ღილაკს ან მივიღოთ cookie-ები
                close_btn = dialog.locator("button:has-text('დახურვა'), button:has-text('კარგი'), button:has-text('Accept'), button:has-text('Close'), button:has-text('OK')")
                if close_btn.count() > 0:
                    close_btn.first.click()
                else:
                    page.evaluate("() => document.querySelector('dialog[open]')?.close()")
                time.sleep(2)
        except:
            pass
        
        # შევამოწმოთ უკვე შესვლა
        body = page.inner_text("body")
        if "Ilia" in body:
            print("  უკვე შესულია")
            page.close()
            return True
        
        # დავაჭიროთ შესვლას
        page.locator("text=შესვლა").first.click()
        time.sleep(3)
        
        # შევავსოთ ემეილი და პაროლი
        page.locator("input[name='Email']").fill(MYMARKET_EMAIL)
        time.sleep(0.5)
        page.locator("input[name='Password']").fill(MYMARKET_PASSWORD)
        time.sleep(0.5)
        
        # დავაჭიროთ შესვლის ღილაკს
        page.locator("button:has-text('შესვლა')").first.click()
        time.sleep(5)
        
        # შევამოწმოთ შესვლა
        page.goto("https://mymarket.ge/ka/", timeout=20000)
        time.sleep(3)
        body = page.inner_text("body")
        success = "Ilia" in body
        
        if success:
            # შევინახოთ cookie-ები
            cookies = context.cookies()
            saved = []
            for c in cookies:
                if c['domain'] in ['.mymarket.ge', '.tnet.ge']:
                    saved.append({
                        "name": c['name'],
                        "value": c['value'],
                        "domain": c['domain'],
                        "path": c['path'],
                    })
            with open(MYMARKET_COOKIES_FILE, "w") as f:
                json.dump(saved, f, indent=2)
            print(f"  შესვლა წარმატებულია, {len(saved)} cookie შენახულია")
        else:
            print("  შესვლა ვერ მოხერხდა")
        
        page.close()
        return success
    except Exception as e:
        print(f"  Login error: {e}")
        page.close()
        return False


# ── Google Sheets ───────────────────────────────────────────────────────
def get_spreadsheet():
    scopes = [
        "https://spreadsheets.google.com/feeds",
        "https://www.googleapis.com/auth/drive",
    ]
    creds = Credentials.from_service_account_file(CREDENTIALS_FILE, scopes=scopes)
    client = gspread.authorize(creds)
    return client.open_by_key(SHEET_ID)


def read_pending_links(sheet):
    """წაიკითხავს 'გამოსაწერი პროდუქცია' tab-დან Temu-ს ლინკებს, სადაც B სვეტი ცარიელია ან 'pending'."""
    records = sheet.get_all_records()
    pending = []
    for i, row in enumerate(records, start=2):  # row 1 = header
        link = str(row.get("Temu ლინკი", "") or row.get("temu_link", "") or "").strip()
        status = str(row.get("სტატუსი", "") or row.get("status", "") or "").strip()
        if link and "temu.com" in link and (not status or status == "pending"):
            pending.append({"row": i, "link": link})
    return pending


def update_sheet_row(sheet, row_num, status="", mymarket_link="", temu_price="", mymarket_price=""):
    """განაახლებს 'გამოსაწერი პროდუქცია' tab-ის მწკრივს."""
    if status:
        sheet.update(range_name=f"B{row_num}", values=[[status]])
    if mymarket_link:
        sheet.update(range_name=f"C{row_num}", values=[[mymarket_link]])
    if temu_price:
        sheet.update(range_name=f"D{row_num}", values=[[temu_price]])
    if mymarket_price:
        sheet.update(range_name=f"E{row_num}", values=[[mymarket_price]])
    sheet.update(range_name=f"F{row_num}", values=[[time.strftime("%Y-%m-%d %H:%M")]])


def move_to_inventory(ss, pending_sheet, row_num):
    """გადაიტანს მწკრივს 'გამოსაწერი პროდუქცია'დან 'მარაგები' tab-ში და წაშლის პირველიდან."""
    inv_sheet = ss.worksheet(TAB_INVENTORY)
    row_data = pending_sheet.row_values(row_num)
    # row_data: A=Temu link, B=status, C=MyMarket link, D=Temu price, E=MyMarket price, F=date, G=ვნახე

    if len(row_data) < 3:
        return False

    temu_link = row_data[0] if len(row_data) > 0 else ""
    mymarket_link = row_data[2] if len(row_data) > 2 else ""
    temu_price = row_data[3] if len(row_data) > 3 else ""
    mymarket_price = row_data[4] if len(row_data) > 4 else ""

    # MyMarket ID ლინკიდან
    mymarket_id = ""
    match = re.search(r"/pr/(\d+)", mymarket_link)
    if match:
        mymarket_id = match.group(1)

    # Art code Temu ლინკიდან
    art_code = ""
    match = re.search(r"g-(\d+)", temu_link)
    if match:
        art_code = match.group(1)

    # დასახელება MyMarket ლინკიდან ან Temu-დან
    title = ""
    # ვნახოთ მარაგებიში უკვე არის თუ არა ეს ID
    existing = inv_sheet.findall(mymarket_id) if mymarket_id else []
    if existing:
        # უკვე არსებობს — განვაახლოთ
        r = existing[0].row
        inv_sheet.update(range_name=f"D{r}", values=[[temu_price]])
        inv_sheet.update(range_name=f"C{r}", values=[[mymarket_price]])
    else:
        # ახალი მწკრივი
        new_row = [mymarket_id, title, mymarket_price, temu_price, "", "", "", "ახალი", art_code, temu_link, mymarket_link]
        inv_sheet.append_row(new_row)

    # წავშალოთ 'გამოსაწერი პროდუქცია'დან
    pending_sheet.delete_rows(row_num)
    return True


def check_seen_items(ss, pending_sheet):
    """შეამოწმებს 'ვნახე' სვეტს (G) და გადაიტანს 'მარაგები'ში."""
    records = pending_sheet.get_all_records()
    moved = 0
    # უკან წავიდეთ რომ row numbers არ აირიოს წაშლის შემდეგ
    rows_to_move = []
    for i, row in enumerate(records, start=2):
        seen = str(row.get("ვნახე", "") or "").strip()
        status = str(row.get("სტატუსი", "") or "").strip()
        if seen == "ვნახე" and status == "ატვირთულია":
            rows_to_move.append(i)

    # უკან წაშლა რომ row numbers არ შეიცვალოს
    for row_num in reversed(rows_to_move):
        if move_to_inventory(ss, pending_sheet, row_num):
            moved += 1
            print(f"    გადატანა 'მარაგები'ში: row {row_num}")

    return moved


# ── Temu scraping ───────────────────────────────────────────────────────
def load_temu_cookies():
    if os.path.exists(TEMU_COOKIES_FILE):
        with open(TEMU_COOKIES_FILE) as f:
            return json.load(f)
    return TEMU_COOKIES


def scrape_temu_product(page, url):
    """Temu-დან ამოიღებს პროდუქტის მონაცემებს."""
    try:
        page.goto(url, timeout=30000)
        time.sleep(5)

        # სახელი
        title = ""
        try:
            title = page.locator("h1").first.inner_text().strip()
        except:
            try:
                title = page.title().replace(" - Temu Georgia", "").strip()
            except:
                pass

        # ფასი — ვეძებთ რეალურ გაყიდვის ფასს (after promos / Est.)
        price = ""
        body = page.inner_text("body")
        lines = [l.strip() for l in body.split("\n") if l.strip()]
        
        # პრიორიტეტი: "after applying promos" ხაზის შემდეგ მყოფი ფასი
        for i, line in enumerate(lines):
            if "after applying promos" in line.lower() or "after promo" in line.lower():
                # შემდეგი ხაზებიდან ვეძებთ ფასს
                for j in range(i, min(i+5, len(lines))):
                    m = re.search(r'(\d+\.\d{2})\s*₾', lines[j])
                    if m:
                        price = m.group(1)
                        break
                if price:
                    break
        
        # თუ ვერ ვიპოვე, ვეძებთ "Est." ფასს
        if not price:
            for i, line in enumerate(lines):
                if "est" in line.lower() and "₾" in line:
                    m = re.search(r'(\d+\.\d{2})\s*₾', line)
                    if m:
                        price = m.group(1)
                        break
        
        # თუ ვერ ვიპოვე, ვიყენებთ ყველაზე პატარა ფასს (მაგრამ არა credit/delay)
        if not price:
            gel_prices = re.findall(r'(\d+\.\d{2})\s*₾', body)
            if gel_prices:
                # გავფილტროთ credit for delay (ჩვეულებრივ ძალიან პატარაა, მაგ. 3.0)
                valid_prices = [float(p) for p in gel_prices if float(p) >= 4.0 and float(p) < 1000]
                if valid_prices:
                    price = str(min(valid_prices))
                else:
                    valid_prices = [float(p) for p in gel_prices if float(p) < 1000]
                    if valid_prices:
                        price = str(min(valid_prices))

        # ფოტო — მთავარი ფოტო XPath-იდან (პროდუქტის გალერეის მთავარი სურათი)
        photos = []
        try:
            # ჯერ XPath-ით — მთავარი ფოტოს კონტეინერი
            main_photo_el = page.locator("xpath=/html/body/div[2]/div[2]/div/div[2]/div[2]/div[2]/div[1]/div[1]/div[2]/div/div/ol/li[2]/div/div/img")
            if main_photo_el.count() > 0:
                src = main_photo_el.first.get_attribute("src") or ""
                if src:
                    photos.append(src)
                    print(f"    მთავარი ფოტო (XPath): {src[:60]}...")
        except:
            pass
        
        # Fallback: ვეძებთ aimg.kwcdn.com და material-put.kwcdn.com დომენებიდან
        if not photos:
            try:
                img_elements = page.locator("img").all()
                for img in img_elements:
                    src = img.get_attribute("src") or ""
                    if ("aimg.kwcdn.com" in src or "material-put.kwcdn.com" in src) and "flag" not in src and "login" not in src and "openingemail" not in src:
                        if src not in photos:
                            photos.append(src)
                        if len(photos) >= 1:
                            break
            except:
                pass

        # აღწერა
        description = ""
        try:
            full_text = page.inner_text("body")
            # Temu-ს აღწერის სექცია
            if "Description" in full_text:
                idx = full_text.index("Description")
                description = full_text[idx:idx+2000].strip()
            elif "description" in full_text.lower():
                idx = full_text.lower().index("description")
                description = full_text[idx:idx+2000].strip()
        except:
            pass

        # Art code URL-დან
        art_code = ""
        match = re.search(r"g-(\d+)", url)
        if match:
            art_code = match.group(1)

        # Art code აღწერის ბოლოში — აუცილებელია scraper.py-სთვის
        if art_code:
            description = description + f"\n\nArt: {art_code}"

        return {
            "title": title,
            "price": price,
            "photos": photos,
            "description": description,
            "art_code": art_code,
            "url": url,
        }
    except Exception as e:
        print(f"  Temu scrape error: {e}")
        return None


def download_photo(url, filepath):
    """ჩამოტვირთავს ფოტოს."""
    try:
        resp = requests.get(url, timeout=15)
        if resp.status_code == 200:
            with open(filepath, "wb") as f:
                f.write(resp.content)
            return True
    except Exception as e:
        print(f"  Photo download error: {e}")
    return False


def select_from_portal_menu(page, target_text=None, skip_back=True):
    """Selects an option from a visible sg-selectbox__menu portal.
    If target_text is given, clicks that option. Otherwise clicks first valid option.
    Returns the selected option text, or None on failure."""
    menus = page.locator(".sg-selectbox__menu")
    for i in range(menus.count()):
        menu = menus.nth(i)
        try:
            if not menu.is_visible():
                continue
            menu_text = menu.inner_text()
            if not menu_text.strip():
                continue
            # Found a visible menu with content
            opts = menu.locator("div[class*='sg-selectbox__option']")
            for j in range(opts.count()):
                opt = opts.nth(j)
                if not opt.is_visible():
                    continue
                txt = opt.inner_text().strip()
                if not txt:
                    continue
                if skip_back and ("უკან" in txt or "დაბრუნება" in txt):
                    continue
                if target_text:
                    if target_text in txt:
                        opt.click()
                        time.sleep(1)
                        return txt
                else:
                    opt.click()
                    time.sleep(1)
                    return txt
            # Fallback: try all divs in menu
            divs = menu.locator("div")
            for j in range(divs.count()):
                d = divs.nth(j)
                if d.is_visible():
                    txt = d.inner_text().strip()
                    if not txt or (skip_back and ("უკან" in txt or "დაბრუნება" in txt)):
                        continue
                    if target_text:
                        if target_text in txt:
                            d.click()
                            time.sleep(1)
                            return txt
                    else:
                        d.click()
                        time.sleep(1)
                        return txt[:50]
            break
        except:
            continue
    return None


# ── MyMarket upload ─────────────────────────────────────────────────────
def load_mymarket_cookies():
    if os.path.exists(MYMARKET_COOKIES_FILE):
        with open(MYMARKET_COOKIES_FILE) as f:
            return json.load(f)
    return []


def upload_to_mymarket(page, product, photo_paths):
    """MyMarket-ზე ატვირთავს განცხადებას Playwright-ით."""
    try:
        # 1. გავხსნათ მთავარი გვერდი (cookie-ების დასამატებლად)
        page.goto("https://mymarket.ge/ka/", timeout=20000)
        time.sleep(3)

        # შევამოწმოთ შესვლა
        body = page.inner_text("body")
        if "შესვლა" in body and "Ilia" not in body:
            return {"success": False, "error": "Not logged in — AccessToken expired"}

        # 2. დავაჭიროთ განცხადების დამატებას
        page.locator("text=განცხადების დამატება").first.click()
        time.sleep(5)

        # 3. ავირჩიოთ გაყიდვა (არა შეძენა)
        # radio-AdTypeID-1 = გაყიდვა, radio-AdTypeID-2 = შეძენა
        page.locator("label[for='radio-AdTypeID-1']").click()
        time.sleep(2)

        # 4. კატეგორია — ვხსნით dropdown-ს, ვკითხულობთ options-ს, AI ირჩევს
        print("    კატეგორიის არჩევა...")
        page.locator("#CatID .sg-selectbox__input-container").first.click()
        time.sleep(2)
        # ვკითხულობთ ყველა option-ს
        cat_opts = page.locator("[role='option']")
        cat_options = []
        for i in range(cat_opts.count()):
            txt = cat_opts.nth(i).inner_text().strip()
            if txt and "უკან" not in txt:
                cat_options.append(txt)
        print(f"    კატეგორიები: {cat_options}")
        # AI ირჩევს
        ai_category = ai_select_from_options(product, cat_options, "კატეგორია")
        print(f"    AI აირჩია: {ai_category}")
        try:
            page.locator(f"[role='option']:has-text('{ai_category}')").click()
        except:
            print(f"    კატეგორია ვერ დავაკლიკე, ვცდილობთ პირველს")
            if cat_opts.count() > 0:
                cat_opts.first.click()
        time.sleep(3)

        # ქვეკატეგორია — ვხსნით, ვკითხულობთ, AI ირჩევს
        print("    ქვეკატეგორიის არჩევა...")
        sub_opts = page.locator("[role='option']")
        sub_options = []
        for i in range(sub_opts.count()):
            txt = sub_opts.nth(i).inner_text().strip()
            if txt and "უკან" not in txt and "დაბრუნება" not in txt:
                sub_options.append(txt)
        print(f"    ქვეკატეგორიები: {sub_options[:10]}...")
        ai_subcategory = ai_select_from_options(product, sub_options, "ქვეკატეგორია")
        print(f"    AI აირჩია: {ai_subcategory}")
        selected_sub = False
        for i in range(sub_opts.count()):
            txt = sub_opts.nth(i).inner_text().strip()
            if txt == ai_subcategory or ai_subcategory in txt:
                sub_opts.nth(i).click()
                selected_sub = True
                print(f"    ქვეკატეგორია არჩეულია: {txt[:40]}")
                break
        if not selected_sub:
            # Fallback: first non-back option
            for i in range(sub_opts.count()):
                txt = sub_opts.nth(i).inner_text().strip()
                if txt and "უკან" not in txt:
                    sub_opts.nth(i).click()
                    selected_sub = True
                    print(f"    ქვეკატეგორია (fallback): {txt[:40]}")
                    break
        time.sleep(2)

        # 5. ფოტოს ატვირთვა — ქვეკატეგორიის შემდეგ
        if photo_paths:
            file_input = page.locator("input[name='Photos']")
            if file_input.count() == 0:
                file_input = page.locator("#Photos")
            if file_input.count() == 0:
                file_input = page.locator("input[type='file']").first
            print(f"    File input found: {file_input.count()}")
            file_input.set_input_files(photo_paths[:1])
            time.sleep(5)
            print("    ფოტო ატვირთულია")

        # 6. სათაური
        title = product["title"][:80] if product["title"] else f"პროდუქტი {product.get('art_code', '')}"
        page.locator("input[name='Title_4']").fill(title)
        time.sleep(1)

        # 7. ფასი
        temu_price = 0
        try:
            temu_price = float(product["price"].replace(",", ".")) if product["price"] else 0
        except:
            pass
        mymarket_price = int(temu_price + PRICE_MARKUP)
        page.locator("input[name='Price']").fill(str(mymarket_price))
        time.sleep(1)

        # 8. ვალუტა — უკვე "ლარი" არჩეულია by default, მაგრამ შევამოწმოთ
        curr_text = page.evaluate("""
        () => {
            const input = document.querySelector('#react-select-4-input');
            if (!input) return '';
            let el = input;
            while (el && !el.className.includes('sg-selectbox__value-container')) el = el.parentElement;
            return el ? el.innerText.trim() : '';
        }
        """)
        if 'ლარი' not in curr_text:
            page.evaluate("""
            () => {
                const input = document.querySelector('#react-select-4-input');
                if (input) {
                    let el = input;
                    while (el && !el.className.includes('sg-selectbox__input-container')) el = el.parentElement;
                    if (el) el.click();
                }
            }
            """)
            time.sleep(2)
            page.locator("[role='option']:has-text('ლარი')").first.click()
            time.sleep(1)
        else:
            print("    ვალუტა უკვე ლარი")

        # 9. აღწერა — Gemini AI-ით დაგენერირებული ქართულად
        print("    აღწერის გენერაცია...")
        desc_text = generate_description(product)
        print(f"    აღწერა: {desc_text[:80]}...")
        desc_editor = page.locator("[contenteditable='true']").first
        if desc_editor.is_visible():
            desc_editor.click()
            time.sleep(1)
            page.keyboard.type(desc_text[:3000])
            time.sleep(1)
        else:
            print("    აღწერის ველი ვერ ვიპოვე!")

        # 10. ტელეფონი და სახელი
        page.locator("input[name='Phone']").fill("511308724")
        time.sleep(0.5)
        page.locator("input[name='User']").fill("Ilia Mgeladze")
        time.sleep(0.5)

        # 11. პროდუქტის სახეობა — დინამიური ID, ვირჩევთ პირველ option-ს
        print("    პროდუქტის სახეობა...")
        # ვეძებთ ნებისმიერ Attr- იდან სავალდებულო ველს
        attr_id = page.evaluate("""
        () => {
            const attrs = document.querySelectorAll('[id^="Attr-"]');
            for (const attr of attrs) {
                const label = attr.querySelector('label');
                if (label && label.innerText.includes('*')) {
                    return attr.id;
                }
            }
            return null;
        }
        """)
        print(f"    Attr ID: {attr_id}")
        attr_selected = False
        if attr_id:
            # Playwright force click
            attr_control = page.locator(f"#{attr_id} .sg-selectbox__control").first
            if attr_control.count() > 0:
                attr_control.click(force=True)
                time.sleep(3)
                # ვეძებთ options
                attr_opts = page.locator("[role='option']")
                print(f"    სახეობის options (role): {attr_opts.count()}")
                if attr_opts.count() > 0:
                    # ვკითხულობთ ყველა option-ს AI-სთვის
                    attr_options = []
                    for i in range(attr_opts.count()):
                        txt = attr_opts.nth(i).inner_text().strip()
                        if txt and "უკან" not in txt:
                            attr_options.append(txt)
                    print(f"    სახეობის options: {attr_options[:10]}...")
                    # AI ირჩევს
                    ai_attr = ai_select_from_options(product, attr_options, "პროდუქტის სახეობა")
                    print(f"    AI აირჩია: {ai_attr}")
                    for i in range(attr_opts.count()):
                        txt = attr_opts.nth(i).inner_text().strip()
                        if txt == ai_attr or ai_attr in txt:
                            attr_opts.nth(i).click()
                            time.sleep(1)
                            print(f"    სახეობა არჩეულია: {txt[:40]}")
                            attr_selected = True
                            break
                    if not attr_selected:
                        # Fallback: first non-back
                        for i in range(attr_opts.count()):
                            txt = attr_opts.nth(i).inner_text().strip()
                            if txt and "უკან" not in txt:
                                attr_opts.nth(i).click()
                                time.sleep(1)
                                print(f"    სახეობა (fallback): {txt[:40]}")
                                attr_selected = True
                                break
                if not attr_selected:
                    # Portal menu
                    selected_attr = select_from_portal_menu(page, skip_back=True)
                    if selected_attr:
                        print(f"    სახეობა არჩეულია: {selected_attr[:40]}")
                        attr_selected = True
            if not attr_selected:
                # Try input-container click
                attr_input = page.locator(f"#{attr_id} .sg-selectbox__input-container").first
                if attr_input.count() > 0:
                    attr_input.click(force=True)
                    time.sleep(3)
                    attr_opts = page.locator("[role='option']")
                    if attr_opts.count() > 0:
                        for i in range(attr_opts.count()):
                            txt = attr_opts.nth(i).inner_text().strip()
                            if txt and "უკან" not in txt:
                                attr_opts.nth(i).click()
                                time.sleep(1)
                                print(f"    სახეობა არჩეულია: {txt[:40]}")
                                attr_selected = True
                                break
                    if not attr_selected:
                        selected_attr = select_from_portal_menu(page, skip_back=True)
                        if selected_attr:
                            print(f"    სახეობა არჩეულია: {selected_attr[:40]}")
                            attr_selected = True
        if not attr_selected:
            print("    სახეობა ვერ არჩეულა!")

        # 12. მდებარეობა — ვირჩევთ თბილისს
        print("    მდებარეობა...")
        page.evaluate("() => document.querySelector('#LocID')?.scrollIntoView({block: 'center'})")
        time.sleep(2)
        page.locator("#LocID .sg-selectbox__control").first.click(force=True)
        time.sleep(3)
        # ვეძებთ თბილისს [role='option'] ან portal menu-ში
        loc_opts = page.locator("[role='option']:has-text('თბილისი')")
        if loc_opts.count() > 0:
            loc_opts.first.click()
            time.sleep(1)
            print("    მდებარეობა არჩეულია (თბილისი)")
        else:
            loc_selected = select_from_portal_menu(page, target_text="თბილისი")
            if loc_selected:
                print(f"    მდებარეობა არჩეულია ({loc_selected})")
            else:
                page.screenshot(path="/tmp/location_fail.png", full_page=True)
                print("    მდებარეობა ვერ არჩეულა!")

        # 13. გამოქვეყნება — XPath-ით შენი მითითებული მისამართიდან
        submit_btn = page.locator("xpath=/html/body/div[2]/main/div/div/div/div[2]/form/div[1]/div[1]/div[9]/div/button[2]")
        if submit_btn.count() > 0:
            submit_btn.first.click()
        else:
            # Fallback
            page.locator("button:has-text('გამოქვეყნება')").click()
        time.sleep(8)

        # შედეგის შემოწმება
        current_url = page.url
        body = page.inner_text("body")
        print(f"    Submit URL: {current_url}")
        print(f"    Body (first 200): {body[:200]}")

        # შემოწმება — წარმატებულია თუ არა
        # წარმატების შემთხვევაში URL იცვლება pr-form-დან
        # ან გვერდზე ჩნდება წარმატების შეტყობინება / პროდუქტის ლინკი
        success = False
        if "pr-form" not in current_url and "pr_form" not in current_url:
            success = True
        elif "წარმატებ" in body or "გამოქვეყნდა" in body or "წარმატებით დაემატა" in body:
            success = True
        elif page.locator("a[href*='/ka/pr/']").count() > 0:
            success = True
        
        if success:
            # ვეძებთ პროდუქტის ლინკს
            product_link = ""
            try:
                link_el = page.locator("a[href*='/ka/pr/']").first
                if link_el.is_visible():
                    product_link = link_el.get_attribute("href")
                    if product_link and not product_link.startswith("http"):
                        product_link = "https://mymarket.ge" + product_link
            except:
                pass
            return {"success": True, "url": product_link or current_url, "price": str(mymarket_price)}

        # შეცდომები — ვეძებთ ყველა შესაძლო შეცდომის შეტყობინებას
        page.screenshot(path="/tmp/mymarket_submit_error.png")
        errors = page.evaluate("""
        () => {
            const results = [];
            // Error/danger/invalid classes
            const errs = document.querySelectorAll('[class*="error"], [class*="danger"], .alert, [class*="Error"], [class*="invalid"], [class*="required"]');
            for (const e of errs) {
                const t = (e.innerText || '').trim();
                if (t && t.length < 200) results.push(t);
            }
            // Toast/notification messages
            const toasts = document.querySelectorAll('[class*="toast"], [class*="notification"], [class*="alert"]');
            for (const e of toasts) {
                const t = (e.innerText || '').trim();
                if (t && t.length < 200) results.push('TOAST: ' + t);
            }
            return results.slice(0, 15);
        }
        """)
        
        # შევამოწმოთ ცარიელი სავალდებულო ველები
        missing = page.evaluate("""
        () => {
            const results = [];
            // Check required inputs
            const required = document.querySelectorAll('[required], [aria-required="true"]');
            required.forEach(el => {
                if (el.tagName === 'INPUT' && !el.value) {
                    const name = el.name || el.id || el.placeholder || 'unknown';
                    results.push(name);
                }
            });
            // Check required selectboxes (sg-selectbox with * in label)
            const groups = document.querySelectorAll('.form-group');
            for (const g of groups) {
                const label = g.querySelector('label');
                if (label && label.innerText.includes('*')) {
                    const placeholder = g.querySelector('.sg-selectbox__placeholder');
                    if (placeholder && placeholder.innerText.trim()) {
                        results.push('selectbox: ' + label.innerText.trim().replace('*', '').trim());
                    }
                }
            }
            return results;
        }
        """)
        
        error_msg = "; ".join(errors) if errors else ""
        if missing:
            error_msg += f" Missing fields: {', '.join(missing)}" if error_msg else f"Missing fields: {', '.join(missing)}"
        if not error_msg:
            error_msg = f"Form not submitted (URL: {current_url})"
        
        return {"success": False, "error": error_msg[:200]}

    except Exception as e:
        return {"success": False, "error": str(e)}


# ── Main ────────────────────────────────────────────────────────────────
POLL_INTERVAL = 30  # წამები შითს შემოწმების ინტერვალი


def process_pending(p, browser, context, ss, pending_sheet):
    """ამუშავებს ყველა pending ლინკს და აბრუნებს დამუშავებული რაოდენობას."""
    # ჯერ გადავიტანოთ 'ვნახე' მონიშნული პროდუქტები 'მარაგები'ში
    moved = check_seen_items(ss, pending_sheet)
    if moved:
        print(f"  {moved} პროდუქტი გადატანილია 'მარაგები'ში")

    # წაიკითხოთ pending ლინკები
    pending = read_pending_links(pending_sheet)
    print(f"  ნაპოვნია {len(pending)} pending ლინკი")

    if not pending:
        return 0

    page = context.new_page()
    processed = 0

    for item in pending:
        row_num = item["row"]
        temu_url = item["link"]
        print(f"\n  [{row_num}] Processing: {temu_url[:60]}...")

        # 1. Temu-დან მონაცემების ამოღება
        product = scrape_temu_product(page, temu_url)
        if not product:
            update_sheet_row(pending_sheet, row_num, status="error")
            print(f"    Temu scrape failed")
            continue

        print(f"    Title: {product['title'][:40]}")
        print(f"    Price: {product['price']}")
        print(f"    Photos: {len(product['photos'])}")

        # 2. ფოტოს ჩამოტვირთვა — მხოლოდ 1 მთავარი ფოტო
        photo_paths = []
        if product["photos"]:
            filepath = f"{PHOTO_DIR}/temu_{product.get('art_code', 'unknown')}_0.jpg"
            if download_photo(product["photos"][0], filepath):
                photo_paths.append(filepath)

        # 3. MyMarket-ზე ატვირთვა
        result = upload_to_mymarket(page, product, photo_paths)

        # 4. ფოტოების წაშლა სერვერიდან
        for fp in photo_paths:
            try:
                os.remove(fp)
                print(f"    ფოტო წაშლილი: {fp}")
            except:
                pass

        if result["success"]:
            update_sheet_row(
                pending_sheet, row_num,
                status="ატვირთულია",
                mymarket_link=result.get("url", ""),
                temu_price=product["price"],
                mymarket_price=result.get("price", ""),
            )
            print(f"    Uploaded! URL: {result.get('url', '')}")
        else:
            update_sheet_row(pending_sheet, row_num, status=f"error: {result.get('error', '')[:50]}")
            print(f"    Failed: {result.get('error', '')}")

        processed += 1

    page.close()
    return processed


def main():
    print(f"[{time.strftime('%H:%M:%S')}] MyMarket Uploader დაიწყო (continuous mode)")

    # Google Sheet
    try:
        ss = get_spreadsheet()
        pending_sheet = ss.worksheet(TAB_PENDING)
        print("  Google Sheet დაკავშირდა")
    except Exception as e:
        print(f"  Google Sheet error: {e}")
        return

    mymarket_cookies = load_mymarket_cookies()

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

        # Temu cookies (hardcoded)
        context.add_cookies(TEMU_COOKIES)

        # MyMarket cookies
        if mymarket_cookies:
            context.add_cookies(mymarket_cookies)

        # ავტო-ლოგინი MyMarket-ზე
        print("  MyMarket-ზე ავტო-ლოგინი...")
        logged_in = login_to_mymarket(context)
        if not logged_in:
            print("  შესვლა ვერ მოხერხდა — ვაგრძელებთ cookie-ებით")

        # მუდმივი მონიტორინგის ლუპი
        print(f"  მუდმივი მონიტორინგი დაიწყო (ყოველ {POLL_INTERVAL} წამში)")
        cycle = 0
        while True:
            cycle += 1
            print(f"\n[{time.strftime('%H:%M:%S')}] ციკლი #{cycle}")

            try:
                # გადავტვირთოთ sheet — ახალი მონაცემებისთვის
                pending_sheet = ss.worksheet(TAB_PENDING)

                # ვნახე → მარაგები + pending ლინკების დამუშავება
                processed = process_pending(p, browser, context, ss, pending_sheet)

                if processed == 0:
                    print("  არანაირი pending ლინკი არ არის — ველოდები...")

            except Exception as e:
                print(f"  ციკლის შეცდომა: {e}")

            # დაველოდოთ შემდეგ ციკლამდე
            time.sleep(POLL_INTERVAL)

    browser.close()


if __name__ == "__main__":
    main()
