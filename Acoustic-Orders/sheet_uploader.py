"""Upload the exported CSV to the Acoustic_orders tab of the shared sheet."""

from __future__ import annotations

import csv
import json

import gspread
from google.oauth2.service_account import Credentials

import config

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]


def _client():
    with open(config.CREDENTIALS_FILE) as f:
        info = json.load(f)
    info["private_key"] = info["private_key"].replace("\\n", "\n")
    return gspread.authorize(
        Credentials.from_service_account_info(info, scopes=SCOPES))


def upload_to_sheet(csv_path: str) -> None:
    print("  uploading to Google Sheets...", flush=True)

    with open(csv_path, encoding="utf-8-sig") as f:
        reader = csv.reader(f)
        rows = list(reader)

    if not rows:
        print("  CSV is empty, skipping upload", flush=True)
        return

    client = _client()
    spreadsheet = client.open_by_key(config.SPREADSHEET_ID)

    try:
        worksheet = spreadsheet.worksheet(config.TAB_NAME)
        print(f"  found existing tab '{config.TAB_NAME}'", flush=True)
    except gspread.WorksheetNotFound:
        worksheet = spreadsheet.add_worksheet(
            title=config.TAB_NAME, rows=max(len(rows) + 10, 100),
            cols=len(rows[0]))
        print(f"  created tab '{config.TAB_NAME}'", flush=True)

    worksheet.clear()
    worksheet.update(values=rows, range_name=f"A1")
    worksheet.format("1:1", {
        "textFormat": {"bold": True, "foregroundColor": {"red": 1, "green": 1, "blue": 1}},
        "backgroundColor": {"red": 0.051, "green": 0.400, "blue": 0.400},
    })
    worksheet.freeze(rows=1)

    print(f"  uploaded {len(rows) - 1} rows to '{config.TAB_NAME}'", flush=True)
