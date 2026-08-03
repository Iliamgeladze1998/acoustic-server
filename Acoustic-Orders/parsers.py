"""HTML -> structured data for the CS-Cart admin order pages.

Cell lookup goes through the ``data-th`` attribute rather than column indexes,
so re-ordering columns in the admin panel cannot silently corrupt the export.
"""

from __future__ import annotations

import re
import urllib.parse

from bs4 import BeautifulSoup

ORDER_ID_RE = re.compile(r"order_id=(\d+)")
INVOICE_RE = re.compile(r"#\s*(\d+)")


def _cell(row, header: str):
    return row.find("td", attrs={"data-th": header})


def _text(node) -> str:
    return node.get_text(" ", strip=True) if node else ""


def _clean_amount(raw: str) -> str:
    """'GEL 1.570.00' -> '1570.00'  (CS-Cart uses '.' as thousands separator)."""
    digits = re.sub(r"[^\d.]", "", raw)
    if not digits:
        return ""
    head, _, decimals = digits.rpartition(".")
    if len(decimals) == 2:
        return f"{head.replace('.', '')}.{decimals}"
    return digits.replace(".", "")


def parse_order_rows(html: str) -> list[dict]:
    """Every order on one list page.

    Only real table rows are read; the admin sidebar also links to orders
    (recently viewed) and must not leak into the export.
    """
    soup = BeautifulSoup(html, "html.parser")
    orders: list[dict] = []

    for row in soup.select("tr"):
        id_cell = _cell(row, "ID")
        if id_cell is None:
            continue
        link = id_cell.find("a", href=ORDER_ID_RE)
        if link is None:
            continue

        order_id = ORDER_ID_RE.search(link["href"]).group(1)
        invoice_match = INVOICE_RE.search(_text(id_cell))

        # The status cell holds a dropdown: the toggle carries the current value,
        # the <ul> below it lists every other selectable status.
        status_cell = _cell(row, "სტატუსი")
        toggle = status_cell.select_one("a.dropdown-toggle") if status_cell else None
        status = toggle.find(string=True, recursive=False) if toggle else None
        status = status.strip() if status else _text(status_cell).split()[0:1]
        if isinstance(status, list):
            status = status[0] if status else ""

        customer_cell = _cell(row, "მომხმარებელი")
        name = personal_id = email = ""
        if customer_cell:
            profile = customer_cell.find("a", href=re.compile("profiles.update"))
            name = _text(profile)
            muted = customer_cell.find("p", class_="muted")
            personal_id = _text(muted)
            mailto = customer_cell.find("a", href=re.compile(r"^mailto:", re.I))
            if mailto:
                email = urllib.parse.unquote(mailto["href"][len("mailto:"):])

        orders.append({
            "order_id": order_id,
            "invoice": invoice_match.group(1) if invoice_match else order_id,
            "status": status,
            "date": _text(_cell(row, "თარიღი")),
            "name": name,
            "personal_id": personal_id,
            "email": email,
            "phone": _text(_cell(row, "ტელეფონი")),
            "total": _clean_amount(_text(_cell(row, "სულ"))),
        })

    return orders


def parse_total_count(html: str) -> int | None:
    """The '1-50 of 1452' counter, so pagination can stop at the right page."""
    match = re.search(r"of\s+([\d,]+)", BeautifulSoup(html, "html.parser").get_text(" "))
    return int(match.group(1).replace(",", "")) if match else None


def parse_payment_method(html: str) -> str:
    """The bank / payment method from an order detail page.

    Detail pages render every extra payment field as a
    ``div.control-label`` + ``div.controls`` pair; 'მეთოდი' is the human-readable
    payment method (e.g. 'საქართველოს ბანკის ბარათით გადახდა').
    """
    soup = BeautifulSoup(html, "html.parser")
    for label in soup.select("div.control-label"):
        if _text(label) != "მეთოდი":
            continue
        controls = label.parent.select_one("div.controls")
        if controls:
            return _text(controls)
    return ""
