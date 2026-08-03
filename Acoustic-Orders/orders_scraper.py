"""Fetch orders from the Acoustic.ge admin panel and save them to Excel.

Usage:
    python3 orders_scraper.py                         # current half-month
    python3 orders_scraper.py --from 08/01/2026 --to 08/15/2026
    python3 orders_scraper.py --from 08/01/2026 --to 08/15/2026 --no-sheet
"""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import sys

import config
from admin_client import AdminClient
from parsers import parse_order_rows, parse_payment_method, parse_total_count

OUTPUT_CSV = config.EXCEL_PATH.replace(".xlsx", ".csv")


def half_month_range(today: dt.date | None = None) -> tuple[str, str]:
    today = today or dt.date.today()
    if today.day <= 15:
        start = today.replace(day=1)
        end = today.replace(day=15)
    else:
        start = today.replace(day=16)
        last_day = (today.replace(month=today.month % 12 + 1, day=1)
                     - dt.timedelta(days=1)) if today.month < 12 \
                    else dt.date(today.year, 12, 31)
        end = last_day
    return start.strftime("%m/%d/%Y"), end.strftime("%m/%d/%Y")


def fetch_orders(client: AdminClient, date_from: str, date_to: str) -> list[dict]:
    all_orders: list[dict] = []
    page = 1
    while True:
        print(f"  fetching list page {page} ({date_from} – {date_to})...", flush=True)
        html = client.orders_page(date_from, date_to, page)
        rows = parse_order_rows(html)
        if not rows:
            break
        all_orders.extend(rows)
        total = parse_total_count(html)
        if total and len(all_orders) >= total:
            break
        if len(rows) < 250:
            break
        page += 1

    print(f"  found {len(all_orders)} orders; fetching payment details...", flush=True)
    for i, order in enumerate(all_orders, 1):
        detail_html = client.order_detail(order["order_id"])
        order["bank"] = parse_payment_method(detail_html)
        print(f"    [{i}/{len(all_orders)}] #{order['invoice']} "
              f"{order['status']:12} {order['total']:>10}  {order['bank'][:40]}",
              flush=True)

    return all_orders


def save_csv(orders: list[dict], path: str) -> None:
    fields = config.COLUMNS
    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        for order in orders:
            writer.writerow({
                "ინვოისი": order["invoice"],
                "თარიღი": order["date"],
                "სახელი გვარი": order["name"],
                "პირადი ნომერი": order["personal_id"],
                "ტელეფონი": order["phone"],
                "თანხა (GEL)": order["total"],
                "ბანკი": order["bank"],
                "სტატუსი": order["status"],
            })
    print(f"  saved {len(orders)} rows to {path}", flush=True)


def main() -> int:
    parser = argparse.ArgumentParser(description="Export Acoustic.ge orders")
    parser.add_argument("--from", dest="date_from", help="MM/DD/YYYY")
    parser.add_argument("--to", dest="date_to", help="MM/DD/YYYY")
    parser.add_argument("--no-sheet", action="store_true",
                        help="skip Google Sheets upload")
    args = parser.parse_args()

    date_from = args.date_from
    date_to = args.date_to
    if not date_from or not date_to:
        date_from, date_to = half_month_range()

    print(f"Acoustic.ge order export: {date_from} – {date_to}", flush=True)

    client = AdminClient()
    client.login()

    orders = fetch_orders(client, date_from, date_to)
    if not orders:
        print("  no orders found for this period", flush=True)
        return 0

    save_csv(orders, OUTPUT_CSV)

    if not args.no_sheet:
        try:
            from sheet_uploader import upload_to_sheet
            upload_to_sheet(OUTPUT_CSV)
        except Exception as error:
            print(f"  sheet upload failed: {error}", flush=True)

    print("done.", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
