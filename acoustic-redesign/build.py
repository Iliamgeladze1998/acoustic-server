"""Render the redesigned acoustic.ge home page from the extracted data."""
import html
import json
import re
from pathlib import Path

BASE = Path(__file__).parent
DATA = BASE / "data.local.json" if (BASE / "data.local.json").exists() else BASE / "data.json"
OUT = BASE / "dist" / "index.html"

ICONS = {
    "phone": '<path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 1.9.7 2.8a2 2 0 0 1-.5 2.1L8.1 9.9a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4c.9.3 1.8.6 2.8.7a2 2 0 0 1 1.7 2z"/>',
    "clock": '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    "mail": '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/>',
    "pin": '<path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 1 1 16 0z"/><circle cx="12" cy="10" r="3"/>',
    "search": '<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>',
    "heart": '<path d="M20.8 5.6a5.2 5.2 0 0 0-7.4 0L12 7l-1.4-1.4a5.2 5.2 0 1 0-7.4 7.4L12 21.5l8.8-8.5a5.2 5.2 0 0 0 0-7.4z"/>',
    "user": '<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>',
    "cart": '<circle cx="9" cy="20" r="1.6"/><circle cx="18" cy="20" r="1.6"/><path d="M2 3h2.2l2.4 12.1a2 2 0 0 0 2 1.6h8.6a2 2 0 0 0 2-1.6L21 7H5.5"/>',
    "compare": '<path d="M4 20V10M10 20V4M16 20v-7M22 20V7"/>',
    "chev-down": '<path d="m6 9 6 6 6-6"/>',
    "chev-right": '<path d="m9 6 6 6-6 6"/>',
    "chev-left": '<path d="m15 6-6 6 6 6"/>',
    "menu": '<path d="M4 7h16M4 12h16M4 17h16"/>',
    "arrow-up": '<path d="M12 19V5M5 12l7-7 7 7"/>',
    "arrow-left": '<path d="M19 12H5M12 19l-7-7 7-7"/>',
    "arrow-right": '<path d="M5 12h14M12 5l7 7-7 7"/>',
    "eye": '<path d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/>',
    "map": '<path d="m9 4 6 2 5-2v14l-5 2-6-2-5 2V6z"/><path d="M9 4v14M15 6v14"/>',
    "shield": '<path d="M12 3l8 3v6c0 5-3.4 8.4-8 9.5C7.4 20.4 4 17 4 12V6z"/>',
    "star": '<path d="m12 3.5 2.6 5.4 5.9.8-4.3 4.1 1 5.9-5.2-2.8-5.2 2.8 1-5.9L3.5 9.7l5.9-.8z"/>',
}


def icon(name, cls="icon"):
    return f'<svg class="{cls}" viewBox="0 0 24 24" aria-hidden="true">{ICONS[name]}</svg>'


def e(text):
    return html.escape(text or "", quote=True)


def load():
    return json.loads(DATA.read_text(encoding="utf-8"))


def render_topbar(d):
    top = d["top"]
    nav = "".join(f'<a href="{e(i["href"])}">{e(i["title"])}</a>' for i in top["nav"])
    phone = top["phones"][0] if top["phones"] else ""
    email = top["emails"][0] if top["emails"] else ""
    return f"""
<div class="topbar">
  <div class="container topbar__row">
    <nav class="topbar__nav">{nav}</nav>
    <div class="topbar__meta">
      <a href="tel:{e(phone)}">{icon('phone', 'icon icon-sm')}<bdo dir="ltr">{e(phone)}</bdo></a>
      <span>{icon('clock', 'icon icon-sm')}{e(top['hours'])}</span>
      <a href="mailto:{e(email)}">{icon('mail', 'icon icon-sm')}{e(email)}</a>
      <span>{icon('pin', 'icon icon-sm')}{e(top['address'])}</span>
    </div>
  </div>
</div>"""


def render_mega(d):
    items, panels = [], []
    for idx, m in enumerate(d["menu"]):
        active = " is-active" if idx == 0 else ""
        img = f'<img src="{e(m["icon"])}" alt="" loading="lazy">' if m["icon"] else ""
        chev = icon("chev-right", "icon icon-sm chev") if m["children"] else ""
        items.append(
            f'<button class="mega__item{active}" data-mega="{idx}">{img}<span>{e(m["title"])}</span>{chev}</button>'
        )
        links = "".join(f'<a href="{e(c["href"])}">{e(c["title"])}</a>' for c in m["children"])
        panels.append(
            f'<div class="mega__panel{active}" data-panel="{idx}">'
            f'<h3 class="mega__title">{e(m["title"])}</h3>'
            f'<div class="mega__links">{links}</div></div>'
        )
    return f"""
      <div class="megawrap">
        <button class="catbtn" id="catbtn">{icon('menu')}<span>პროდუქცია</span>{icon('chev-down', 'icon icon-sm chev')}</button>
        <div class="mega" id="mega">
          <div class="mega__list">{''.join(items)}</div>
          <div class="mega__panels">{''.join(panels)}</div>
        </div>
      </div>"""


def render_header(d):
    return f"""
<header class="header" id="header">
  <div class="container header__row">
    <a class="logo" href="/"><img src="{e(d['logo'])}" alt="Acoustic.ge"></a>
    {render_mega(d)}
    <form class="search" role="search" onsubmit="return false">
      <input type="search" placeholder="ძებნა: გიტარა, მიკროფონი, სიმები…" aria-label="ძებნა">
      <button type="submit" aria-label="ძებნა">{icon('search', 'icon icon-sm')}</button>
    </form>
    <div class="actions">
      <a class="act" href="#">{icon('compare')}<span>შედარება</span></a>
      <a class="act" href="#">{icon('heart')}<span>რჩეული</span></a>
      <a class="act" href="#">{icon('user')}<span>ანგარიში</span></a>
      <a class="act" href="#">{icon('cart')}<span class="badge">0</span><span>ურიკა</span></a>
    </div>
  </div>
</header>"""


def render_hero(d):
    cards = ""
    for s in d["banners"][0]["slides"]:
        cards += f"""
        <a class="bcard" href="{e(s['href'])}">
          <img src="{e(s['image'])}" alt="{e(s['title'])}" loading="lazy">
          <div class="bcard__body">
            <h3 class="bcard__title">{e(s['title'])}</h3>
            <p class="bcard__sub">{e(s['description'])}</p>
            <span class="btn-ghost">{e(s['button'])}{icon('arrow-right', 'icon icon-sm')}</span>
          </div>
        </a>"""
    promos = "".join(
        f"""<a class="promo" href="{e(s['href'])}">
          <img src="{e(s['image'])}" alt="" loading="lazy">
          <span>{e(s['button'])}{icon('arrow-right', 'icon icon-sm')}</span>
        </a>"""
        for s in d["banners"][1]["slides"]
    )
    return f"""
<section class="section hero">
  <div class="container">
    <div class="shead">
      <h2><span class="accent">ახალი ბრენდები</span> აკუსტიკაში</h2>
      <div class="rule"></div>
    </div>
    <div class="bcards">{cards}</div>
    <div class="promos">{promos}</div>
  </div>
</section>"""


def render_categories(d):
    tiles = "".join(
        f"""<a class="cat" href="{e(c['href'])}">
          <span class="cat__img"><img src="{e(c['image'])}" alt="" loading="lazy"></span>
          <span class="cat__name">{e(c['title'])}</span>
        </a>"""
        for c in d["categories"]
    )
    return f"""
<section class="section">
  <div class="container">
    <div class="shead"><h2>პროდუქციის <span class="accent">კატალოგი</span></h2><div class="rule"></div></div>
    <div class="cats">{tiles}</div>
  </div>
</section>"""


def render_services(d):
    cards = "".join(
        f"""<article class="service">
          <img src="{e(s['image'])}" alt="" loading="lazy">
          <div class="service__body">
            <h3 class="service__title">{e(s['title'])}</h3>
            <p class="service__desc">{e(s['description'])}</p>
            <a class="service__tel" href="tel:{e(s['button'])}">{icon('phone', 'icon icon-sm')}<bdo dir="ltr">{e(s['button'])}</bdo></a>
          </div>
        </article>"""
        for s in d["banners"][2]["slides"]
    )
    return f"""
<section class="section">
  <div class="container">
    <div class="shead"><h2>ჩვენი <span class="accent">სერვისები</span></h2><div class="rule"></div></div>
    <div class="services">{cards}</div>
  </div>
</section>"""


def discount_pct(old, new):
    def num(v):
        m = re.search(r"[\d.,]+", v or "")
        if not m:
            return 0.0
        try:
            return float(m.group(0).replace(",", ""))
        except ValueError:
            return 0.0
    o, n = num(old), num(new)
    if o > 0 and n > 0 and n < o:
        return f"-{round((o - n) / o * 100)}%"
    return ""


def render_product(p, badge_new=False):
    in_stock = "გაყიდვაშია" in p["stock"]
    tag = ""
    pct = discount_pct(p["old_price"], p["price"])
    if pct:
        tag = f'<span class="tag">{pct}</span>'
    elif badge_new:
        tag = '<span class="tag tag--new">ახალი</span>'
    if p["price"]:
        price = f'<span class="price-now{" is-sale" if p["old_price"] else ""}">{e(p["price"])}</span>'
        if p["old_price"]:
            price += f'<span class="price-old">{e(p["old_price"])}</span>'
    else:
        price = f'<span class="price-ask">{e(p["note"] or "ფასის დასაზუსტებლად გთხოვთ დაგვიკავშრდეთ")}</span>'
    srcset = f' srcset="{e(p.get("image_2x", ""))} 2x"' if p.get("image_2x") else ""
    stars = "".join(icon("star") for _ in range(5))
    return f"""
    <article class="pcard">
      <div class="pcard__media">
        {tag}
        <a href="{e(p['href'])}"><img src="{e(p['image'])}"{srcset} alt="{e(p['name'])}" loading="lazy"></a>
        <div class="quick">
          <button title="რჩეულებში">{icon('heart', 'icon icon-sm')}</button>
          <button title="შედარება">{icon('compare', 'icon icon-sm')}</button>
          <button title="სწრაფი ნახვა">{icon('eye', 'icon icon-sm')}</button>
        </div>
      </div>
      <a class="pcard__name" href="{e(p['href'])}">{e(p['name'])}</a>
      <div class="stars">{stars}<span>{e(p['rating'])}</span></div>
      <div class="pcard__price">{price}</div>
      <div class="pcard__foot">
        <span class="stock{'' if in_stock else ' out'}"><i></i>{e(p['stock'])}</span>
        <button class="buy" title="დაამატე ურიკაში"{'' if in_stock else ' disabled'}>{icon('cart', 'icon icon-sm')}</button>
      </div>
    </article>"""


def render_rail(block, idx, badge_new=False):
    cards = "".join(render_product(p, badge_new) for p in block["products"])
    words = block["title"].split()
    head = f'<span class="accent">{e(words[0])}</span> ' + e(" ".join(words[1:])) if len(words) > 1 else e(block["title"])
    return f"""
<section class="section">
  <div class="container">
    <div class="shead">
      <h2>{head}</h2>
      <div class="rule"></div>
      <div class="navbtns">
        <button class="navbtn" data-rail="rail{idx}" data-dir="-1" aria-label="prev">{icon('arrow-left', 'icon icon-sm')}</button>
        <button class="navbtn" data-rail="rail{idx}" data-dir="1" aria-label="next">{icon('arrow-right', 'icon icon-sm')}</button>
      </div>
    </div>
    <div class="rail" id="rail{idx}">{cards}</div>
  </div>
</section>"""


def render_brands(d):
    row = "".join(
        f'<a class="brand" href="{e(b["href"])}"><img src="{e(b["image"])}" alt="" loading="lazy"></a>'
        for b in d["brands"]
    )
    return f"""
<section class="section section--tight">
  <div class="container">
    <div class="brands"><div class="brands__track">{row}{row}</div></div>
  </div>
</section>"""


def render_footer(d):
    cols = d["footer"]
    site_map = "".join(f'<li><a href="{e(l["href"])}">{e(l["title"])}</a></li>' for l in cols[0]["links"])
    terms = "".join(f'<li><a href="{e(l["href"])}">{e(l["title"])}</a></li>' for l in cols[1]["links"])
    contact = d["footer"][2]
    map_href = next((l["href"] for l in contact["links"] if "google" in l["href"]), "#")
    email = next((l["title"] for l in contact["links"] if "@" in l["title"]), "")
    phone = re.search(r"\+995\d+", contact["text"])
    account = cols[3]
    login = next((l for l in account["links"] if "auth" in l["href"]), None)
    register = next((l for l in account["links"] if "profiles-add" in l["href"]), None)
    return f"""
<footer class="footer">
  <div class="container footer__top">
    <div>
      <h3>საიტის რუკა</h3>
      <ul class="footer__links">{site_map}</ul>
    </div>
    <div>
      <h3>წესები და პირობები</h3>
      <ul class="footer__links">{terms}</ul>
    </div>
    <div>
      <h3>კონტაქტი</h3>
      <ul class="fcontact">
        <li>{icon('pin', 'icon icon-sm')}<span>თბილისი, აკაკი წერეთლის 142</span></li>
        <li>{icon('phone', 'icon icon-sm')}<a href="tel:{e(phone.group(0) if phone else '')}"><bdo dir="ltr">{e(phone.group(0) if phone else '')}</bdo></a></li>
        <li>{icon('clock', 'icon icon-sm')}<span>ყოველდღე 11:00-19:00</span></li>
        <li>{icon('mail', 'icon icon-sm')}<a href="mailto:{e(email)}">{e(email)}</a></li>
      </ul>
      <div class="fbtns"><a class="fbtn" href="{e(map_href)}" target="_blank" rel="noopener">{icon('map', 'icon icon-sm')}მოგვძებნე რუკაზე</a></div>
    </div>
    <div>
      <h3>ჩემი ანგარიში</h3>
      <div class="fbtns">
        <a class="fbtn fbtn--solid" href="{e(login['href'] if login else '#')}">{e(login['title'] if login else 'ავტორიზაცია')}</a>
        <a class="fbtn" href="{e(register['href'] if register else '#')}">{e(register['title'] if register else 'რეგისტრაცია')}</a>
      </div>
      <p class="footer__note">გაიარე ავტორიზაცია, ან დარეგისტრირდი</p>
    </div>
  </div>
  <div class="container footer__bottom">
    <span>&copy; 2020-2026 აკუსტიკა. ყველა უფლება დაცულია.</span>
    <span class="pays">{icon('shield', 'icon icon-sm')}Supported by: <a href="https://cscart.ge" target="_blank" rel="noopener">Geopay</a></span>
  </div>
</footer>"""


def main():
    d = load()
    body = [
        render_topbar(d),
        render_header(d),
        render_hero(d),
        render_categories(d),
        render_services(d),
        render_rail(d["product_blocks"][0], 0),
        render_rail(d["product_blocks"][1], 1, badge_new=True),
        render_brands(d),
        render_footer(d),
    ]
    page = f"""<!DOCTYPE html>
<html lang="ka">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{e(d['title'])}</title>
<meta name="description" content="Acoustic.ge — მუსიკალური ინსტრუმენტების და აპარატურის მაღაზია.">
<link rel="icon" href="{e(d['logo'])}">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="assets/styles.css">
</head>
<body>
{''.join(body)}
<div class="scrim" id="scrim"></div>
<button class="up" id="up" aria-label="up">{icon('arrow-up', 'icon icon-sm')}</button>
<script src="assets/app.js"></script>
</body>
</html>
"""
    OUT.write_text(page, encoding="utf-8")
    print("written", OUT, len(page), "bytes")


if __name__ == "__main__":
    main()
