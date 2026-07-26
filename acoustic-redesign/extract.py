"""Extract structured content from the saved acoustic.ge home page into data.json."""
import json
import re
import unicodedata
from pathlib import Path

from bs4 import BeautifulSoup

BASE = Path(__file__).parent
SRC = BASE / "_src" / "index.html"
OUT = BASE / "data.json"
SITE = "https://acoustic.ge"


def clean(text):
    if text is None:
        return ""
    text = unicodedata.normalize("NFKC", text)
    return re.sub(r"\s+", " ", text).strip()


def absolutize(url):
    if not url:
        return ""
    if url.startswith("//"):
        return "https:" + url
    if url.startswith("/"):
        return SITE + url
    return url


def img_of(node):
    if node is None:
        return ""
    img = node.find("img")
    if not img:
        return ""
    return absolutize(img.get("src") or img.get("data-src") or "")


def parse_menu(soup):
    root = soup.select_one("ul.ty-menu__items")
    items = []
    if not root:
        return items
    for li in root.find_all("li", recursive=False):
        link = li.find("a", class_="ty-menu__item-link")
        if not link:
            continue
        entry = {
            "title": clean(link.get_text()),
            "href": absolutize(link.get("href")),
            "icon": img_of(link),
            "children": [],
        }
        for sub in li.select(".ty-menu__submenu a.ty-menu__submenu-link"):
            title = clean(sub.get_text())
            if not title or title == entry["title"]:
                continue
            child = {"title": title, "href": absolutize(sub.get("href"))}
            if child not in entry["children"]:
                entry["children"].append(child)
        items.append(entry)
    return items


def parse_banners(soup):
    groups = []
    for slider in soup.select("div.banners"):
        slides = []
        for banner in slider.select(".ut2-banner"):
            bg = banner.select_one(".ut2-a__bg-banner")
            image = ""
            if bg and bg.get("style"):
                m = re.search(r"url\(['\"]?(.*?)['\"]?\)", bg["style"])
                if m:
                    image = absolutize(m.group(1))
            title_el = banner.select_one(".ut2-a__title")
            title = ""
            if title_el:
                title = clean(title_el.get_text(" "))
            descr = clean(banner.select_one(".ut2-a__descr").get_text()) if banner.select_one(".ut2-a__descr") else ""
            btn = banner.select_one(".ut2-a__button a")
            if not image:
                image = img_of(banner)
            if not (image or title):
                continue
            slides.append({
                "image": image,
                "title": title,
                "description": descr,
                "button": clean(btn.get_text()) if btn else "",
                "href": absolutize(btn.get("href")) if btn else absolutize(
                    banner.find("a").get("href") if banner.find("a") else ""),
            })
        if slides:
            groups.append({"id": slider.get("id", ""), "slides": slides})
    return groups


def money(node):
    """Render a CS-Cart price node as e.g. '45.00 GEL'."""
    if node is None:
        return ""
    for sup in node.find_all("sup"):
        sup.replace_with("." + sup.get_text())
    text = clean(node.get_text(" ")).replace("GEL", "")
    text = re.sub(r"[\s,]", "", text)
    text = re.sub(r"\.(?=\d{3}\b)", "", text) if text.count(".") > 1 else text
    if not text:
        return ""
    try:
        value = float(text)
    except ValueError:
        return text + " GEL"
    return f"{value:,.2f} GEL"


def parse_products(soup):
    blocks = []
    for grid in soup.select("div.grid-list"):
        title_el = grid.find_previous("div", class_="ty-mainbox-title")
        title = clean(title_el.get_text()) if title_el else ""
        products = []
        for item in grid.select(".ut2-gl__item"):
            name_el = item.select_one("a.product-title")
            if not name_el:
                continue
            old = item.select_one(".ty-list-price .ty-strike")
            actual = item.select_one(".ty-price-update .ty-price")
            stock = item.select_one(".ty-qty-in-stock, .ty-qty-out-of-stock")
            rating = item.select_one(".ut2-rating-stars-num")
            btn = item.select_one(".ty-btn__primary, .ty-btn__add-to-cart")
            note = ""
            for cand in item.select(".ut2-gl__price span, .ut2-gl__price div"):
                t = clean(cand.get_text())
                if "ფასის დასაზუსტებლად" in t:
                    note = t
                    break
            products.append({
                "name": clean(name_el.get_text()),
                "href": absolutize(name_el.get("href")),
                "image": img_of(item.select_one(".ut2-gl__image")),
                "old_price": money(old),
                "price": money(actual),
                "note": note,
                "rating": clean(rating.get_text()) if rating else "",
                "stock": clean(stock.get_text()) if stock else "",
                "action": clean(btn.get_text()) if btn else "",
            })
        if products:
            blocks.append({"title": title, "products": products})
    return blocks


def parse_categories(soup):
    cats = []
    for a in soup.select(".ty-subcategories-block__a"):
        title = clean(a.get_text())
        image = img_of(a)
        if not title:
            continue
        cats.append({"title": title, "href": absolutize(a.get("href")), "image": image})
    return cats


def parse_brands(soup):
    brands = []
    for img in soup.select("img[src*='ab__fn_menu_icon'], img[src*='brand']"):
        src = absolutize(img.get("src"))
        parent = img.find_parent("a")
        brands.append({
            "image": src,
            "href": absolutize(parent.get("href")) if parent else "",
            "title": clean(img.get("alt") or (parent.get("title") if parent else "")),
        })
    return brands


def parse_top(soup):
    header = soup.select_one(".tygh-header")
    nav = []
    seen = set()
    if header:
        for a in header.select(".horz-list .ty-wysiwyg-content li a"):
            t = clean(a.get_text())
            if t and t not in seen:
                seen.add(t)
                nav.append({"title": t, "href": absolutize(a.get("href"))})
    text = clean(header.get_text(" ")) if header else ""
    phones = sorted(set(re.findall(r"\+995\d{9}", text)))
    emails = sorted(set(re.findall(r"[\w.+-]+@[\w.-]+\.\w+", text)))
    hours = re.search(r"\d{2}:\d{2}-\d{2}:\d{2}", text)
    address = re.search(r"(აკაკი წერეთლის \d+)", text)
    return {
        "nav": nav,
        "phones": phones,
        "emails": emails,
        "hours": hours.group(0) if hours else "",
        "address": clean(address.group(1)) if address else "",
    }


def parse_footer(soup):
    footer = soup.select_one(".tygh-footer")
    cols = []
    if footer:
        for block in footer.select(".span4, .span3, .footer-menu"):
            title_el = block.select_one(".ty-footer-menu__header, h3, .ty-mainbox-title")
            links = []
            for a in block.select("a"):
                t = clean(a.get_text())
                if t:
                    links.append({"title": t, "href": absolutize(a.get("href"))})
            text = clean(block.get_text(" "))
            cols.append({
                "title": clean(title_el.get_text()) if title_el else "",
                "links": links,
                "text": text,
            })
    return cols


def main():
    soup = BeautifulSoup(SRC.read_text(encoding="utf-8", errors="replace"), "lxml")
    data = {
        "title": clean(soup.title.get_text()) if soup.title else "",
        "logo": absolutize(soup.select_one("img[src*='logos']").get("src")) if soup.select_one("img[src*='logos']") else "",
        "top": parse_top(soup),
        "menu": parse_menu(soup),
        "banners": parse_banners(soup),
        "product_blocks": parse_products(soup),
        "categories": parse_categories(soup),
        "brands": parse_brands(soup),
        "footer": parse_footer(soup),
    }
    OUT.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print("top:", data["top"])
    print("menu:", [(m["title"], len(m["children"])) for m in data["menu"]])
    print("banner groups:", [(g["id"], len(g["slides"])) for g in data["banners"]])
    print("product blocks:", [(b["title"], len(b["products"])) for b in data["product_blocks"]])
    print("categories:", len(data["categories"]))
    print("brands:", len(data["brands"]))
    print("footer cols:", len(data["footer"]))


if __name__ == "__main__":
    main()
