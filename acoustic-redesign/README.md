# Acoustic.ge — home page redesign (visual only)

A pixel-fresh, modern re-skin of the acoustic.ge home page for client presentation.
**Content, sections and their order are identical to the live site** — only the visual
layer (layout polish, typography, spacing, colours, interactions) was reworked.

## Live preview

    http://178.104.173.138:5559/

(port 5558 was already taken by `review-redirect-dev/demo_server.py`)

## How it works

| file | purpose |
|---|---|
| `_src/index.html` | raw snapshot of the live https://acoustic.ge/ home page |
| `extract.py` | parses the snapshot into `data.json` (menu, banners, categories, products, brands, footer) |
| `fetch_assets.py` | mirrors every referenced image into `dist/assets/img/` → `data.local.json` |
| `build.py` | renders `dist/index.html` from the extracted data |
| `dist/assets/styles.css` | the redesign |
| `dist/assets/app.js` | mega menu, product rails, scroll reveal, back-to-top |

## Rebuild

```bash
curl -sL https://acoustic.ge/ -o _src/index.html   # refresh the snapshot (optional)
python3 extract.py        # snapshot  -> data.json
python3 fetch_assets.py   # data.json -> local images + data.local.json
python3 build.py          # -> dist/index.html
```

## Serve

```bash
python3 -m http.server 5559 --bind 0.0.0.0 --directory dist
```

## What changed visually

- gradient top bar with contacts, sticky glass header, pill search, labelled action icons
- category mega menu: icon list + 3-column subcategory panel
- brand banners as a 4-up card grid (no cropping — source art is portrait 409×497)
- wide promo banners in their own full-width row at their native 2.45 ratio
- category tiles with circular icon wells and lift-on-hover
- service blocks as cinematic cards with a call button
- product cards: discount badge, hover quick actions, clean price hierarchy, stock dot
- horizontal product rails with arrow navigation instead of a cramped grid
- animated grayscale→colour brand marquee
- dark structured footer, back-to-top button, scroll reveal, full responsive layout

Requirements: `python3`, `beautifulsoup4`, `lxml` (build time only — the output is static HTML/CSS/JS).
