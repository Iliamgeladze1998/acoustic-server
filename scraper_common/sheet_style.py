#!/usr/bin/env python3
"""Unified visual styling for every price-comparison tab of the Acoustic sheet.

Purely cosmetic: it never reads, writes or reorders any cell value, it only
touches formatting. Run it after a scraper finished uploading:

    python3 /root/scraper_common/sheet_style.py Mireli
    python3 /root/scraper_common/sheet_style.py --all

What it does per tab:
  * clears leftover formatting outside the current data range (the stale yellow
    blocks that appeared when a previous run had more rows/columns)
  * applies one identical header / body style everywhere
  * right-aligns and unit-formats price columns, signs the price difference
  * colour-scales Price_Diff  (competitor cheaper -> red, we are cheaper -> green)
  * greys out rows where the competitor price is missing (0 / empty)
  * sizes columns per semantic role and freezes the header row
"""

import argparse
import json
import os
import sys

import gspread
from google.oauth2.service_account import Credentials

SPREADSHEET_ID = "1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]

CREDENTIAL_CANDIDATES = [
    "/root/Acoustic-Largo/credentials.json",
    "/root/Acoustic-Mireli/credentials.json",
    "/root/Acoustic-JinoMusic/credentials.json",
    "/root/Acoustic-Geovoice/credentials.json",
    "/root/Acoustic-Musicroom/credentials.json",
    "/root/Acoustic-Musikissaxli/credentials.json",
]

TABS = ["Largo", "JinoMusic", "Musikis-saxli", "Musicroom", "Geovoice", "Mireli"]

# scraper name (run_single_scraper.sh) -> sheet tab
SCRAPER_TO_TAB = {
    "largo": "Largo",
    "jinomusic": "JinoMusic",
    "musichouse": "Musikis-saxli",
    "musicroom": "Musicroom",
    "geovoice": "Geovoice",
    "mireli": "Mireli",
}

# ── palette ────────────────────────────────────────────────────────────────
BRAND = {"red": 0.051, "green": 0.400, "blue": 0.400}          # header teal
WHITE = {"red": 1.0, "green": 1.0, "blue": 1.0}
GREY_ROW = {"red": 0.953, "green": 0.953, "blue": 0.953}       # missing price
GREY_TEXT = {"red": 0.502, "green": 0.502, "blue": 0.502}
RED = {"red": 0.878, "green": 0.400, "blue": 0.400}            # competitor cheaper
GREEN = {"red": 0.576, "green": 0.769, "blue": 0.490}          # we are cheaper
LINK_BLUE = {"red": 0.067, "green": 0.333, "blue": 0.800}
BORDER_GREY = {"red": 0.851, "green": 0.851, "blue": 0.851}
ZEBRA = {"red": 0.969, "green": 0.976, "blue": 0.976}       # every 2nd row

# NB: optional-decimal patterns such as '#,##0.##' render a dangling decimal
# separator in this spreadsheet's ru_RU locale, so fixed 2 decimals are used.
PRICE_FORMAT = '#,##0.00" ₾"'
DIFF_FORMAT = '"+"#,##0.00" ₾";"-"#,##0.00" ₾";0" ₾"'

COLUMN_WIDTHS = {
    "matching_style": 120,
    "match_key": 150,
    "product_name": 300,
    "price": 95,
    "price_diff": 110,
    "link": 240,
    "last_updated": 150,
    "feedback": 120,
    "default": 130,
}


def _credentials_path():
    for path in CREDENTIAL_CANDIDATES:
        if os.path.exists(path):
            return path
    raise FileNotFoundError("No credentials.json found in any Acoustic project")


def _client():
    with open(_credentials_path()) as handle:
        info = json.load(handle)
    info["private_key"] = info["private_key"].replace("\\n", "\n")
    return gspread.authorize(Credentials.from_service_account_info(info, scopes=SCOPES))


def _a1_column(index):
    """0-based column index -> A1 letter."""
    letters = ""
    index += 1
    while index:
        index, rest = divmod(index - 1, 26)
        letters = chr(65 + rest) + letters
    return letters


def _role(header):
    """Classify a header into a semantic role (case/naming agnostic)."""
    name = header.strip().lower()
    if "matching_style" in name or name in ("matching style", "matching_style"):
        return "matching_style"
    if "match_key" in name or name == "match key":
        return "match_key"
    if name.startswith("product_name") or name.startswith("product name"):
        return "product_name"
    if "price_diff" in name or "price diff" in name:
        return "price_diff"
    if name.startswith("price"):
        return "price"
    if name.startswith("link"):
        return "link"
    if "last" in name and ("updated" in name or "update" in name):
        return "last_updated"
    if "feedback" in name:
        return "feedback"
    return "default"


def _alignment(role):
    if role in ("price", "price_diff"):
        return "RIGHT"
    if role in ("matching_style", "feedback", "last_updated"):
        return "CENTER"
    return "LEFT"


def _grid(sheet_id, start_row=None, end_row=None, start_col=None, end_col=None):
    grid = {"sheetId": sheet_id}
    if start_row is not None:
        grid["startRowIndex"] = start_row
    if end_row is not None:
        grid["endRowIndex"] = end_row
    if start_col is not None:
        grid["startColumnIndex"] = start_col
    if end_col is not None:
        grid["endColumnIndex"] = end_col
    return grid


def _parse_number(text):
    """Parse a sheet-rendered number ('1 250,50', '-700', '22.5') into a float."""
    cleaned = str(text).replace("\xa0", "").replace(" ", "").replace("₾", "").strip()
    if not cleaned:
        return None
    if "," in cleaned and "." in cleaned:
        cleaned = cleaned.replace(".", "").replace(",", ".")
    else:
        cleaned = cleaned.replace(",", ".")
    try:
        return float(cleaned)
    except ValueError:
        return None


def _colour_scale_bound(diff_values):
    """Symmetric bound around zero, clamped at the 90th percentile of |diff|.

    Keeps the red/green scale comparable between tabs and stops a single huge
    outlier from flattening every other row to white.
    """
    magnitudes = sorted(abs(v) for v in diff_values if v)
    if not magnitudes:
        return 100.0
    bound = magnitudes[min(len(magnitudes) - 1, int(len(magnitudes) * 0.9))]
    return max(bound, 1.0)


def build_requests(worksheet, headers, data_rows, existing_rule_count, diff_values=()):
    """Return the batchUpdate requests that style one tab."""
    sheet_id = worksheet.id
    used_cols = len(headers)
    grid_rows = worksheet.row_count
    grid_cols = worksheet.col_count
    last_row = max(data_rows + 1, 2)  # exclusive end index of the data block
    roles = [_role(h) for h in headers]
    requests = []

    # 1. drop every existing conditional format rule (rebuilt below, uniformly)
    for index in range(existing_rule_count - 1, -1, -1):
        requests.append({"deleteConditionalFormatRule": {"sheetId": sheet_id, "index": index}})

    # 2. wipe leftover formatting outside the live data range
    if grid_rows > last_row:
        requests.append({
            "repeatCell": {
                "range": _grid(sheet_id, last_row, grid_rows, 0, grid_cols),
                "cell": {"userEnteredFormat": {}},
                "fields": "userEnteredFormat",
            }
        })
    if grid_cols > used_cols:
        requests.append({
            "repeatCell": {
                "range": _grid(sheet_id, 0, grid_rows, used_cols, grid_cols),
                "cell": {"userEnteredFormat": {}},
                "fields": "userEnteredFormat",
            }
        })

    # 3. header row
    requests.append({
        "repeatCell": {
            "range": _grid(sheet_id, 0, 1, 0, used_cols),
            "cell": {
                "userEnteredFormat": {
                    "backgroundColor": BRAND,
                    "horizontalAlignment": "CENTER",
                    "verticalAlignment": "MIDDLE",
                    "wrapStrategy": "WRAP",
                    "textFormat": {
                        "foregroundColor": WHITE,
                        "bold": True,
                        "fontSize": 10,
                        "fontFamily": "Google Sans",
                    },
                }
            },
            "fields": "userEnteredFormat(backgroundColor,horizontalAlignment,"
                      "verticalAlignment,wrapStrategy,textFormat)",
        }
    })
    requests.append({
        "updateDimensionProperties": {
            "range": {"sheetId": sheet_id, "dimension": "ROWS", "startIndex": 0, "endIndex": 1},
            "properties": {"pixelSize": 34},
            "fields": "pixelSize",
        }
    })

    # 4. body: clean white canvas, consistent typography and row height
    requests.append({
        "repeatCell": {
            "range": _grid(sheet_id, 1, last_row, 0, used_cols),
            "cell": {
                "userEnteredFormat": {
                    "backgroundColor": WHITE,
                    "verticalAlignment": "MIDDLE",
                    "wrapStrategy": "CLIP",
                    "textFormat": {
                        "bold": False,
                        "italic": False,
                        "fontSize": 10,
                        "fontFamily": "Google Sans",
                        "foregroundColor": {"red": 0.13, "green": 0.13, "blue": 0.13},
                    },
                }
            },
            "fields": "userEnteredFormat(backgroundColor,verticalAlignment,wrapStrategy,textFormat)",
        }
    })
    if last_row > 1:
        requests.append({
            "updateDimensionProperties": {
                "range": {"sheetId": sheet_id, "dimension": "ROWS",
                          "startIndex": 1, "endIndex": last_row},
                "properties": {"pixelSize": 26},
                "fields": "pixelSize",
            }
        })

    # 5. per-column role styling
    for index, role in enumerate(roles):
        cell_format = {"horizontalAlignment": _alignment(role)}
        fields = ["horizontalAlignment"]
        if role == "price":
            cell_format["numberFormat"] = {"type": "NUMBER", "pattern": PRICE_FORMAT}
            fields.append("numberFormat")
        elif role == "price_diff":
            cell_format["numberFormat"] = {"type": "NUMBER", "pattern": DIFF_FORMAT}
            cell_format["textFormat"] = {"bold": True, "fontSize": 10}
            fields.extend(["numberFormat", "textFormat"])
        elif role == "link":
            cell_format["textFormat"] = {"foregroundColor": LINK_BLUE, "underline": True,
                                         "fontSize": 10}
            fields.append("textFormat")
        elif role == "last_updated":
            cell_format["textFormat"] = {"foregroundColor": GREY_TEXT, "fontSize": 9}
            fields.append("textFormat")

        requests.append({
            "repeatCell": {
                "range": _grid(sheet_id, 1, last_row, index, index + 1),
                "cell": {"userEnteredFormat": cell_format},
                "fields": "userEnteredFormat(%s)" % ",".join(fields),
            }
        })
        requests.append({
            "updateDimensionProperties": {
                "range": {"sheetId": sheet_id, "dimension": "COLUMNS",
                          "startIndex": index, "endIndex": index + 1},
                "properties": {"pixelSize": COLUMN_WIDTHS.get(role, COLUMN_WIDTHS["default"])},
                "fields": "pixelSize",
            }
        })

    # 6. freeze the header, keep gridlines, add a crisp line under the header
    requests.append({
        "updateSheetProperties": {
            "properties": {"sheetId": sheet_id, "gridProperties": {"frozenRowCount": 1}},
            "fields": "gridProperties.frozenRowCount",
        }
    })
    requests.append({
        "updateBorders": {
            "range": _grid(sheet_id, 0, 1, 0, used_cols),
            "bottom": {"style": "SOLID_MEDIUM", "color": BRAND},
        }
    })
    if last_row > 1:
        requests.append({
            "updateBorders": {
                "range": _grid(sheet_id, 1, last_row, 0, used_cols),
                "innerHorizontal": {"style": "SOLID", "color": BORDER_GREY},
            }
        })

    if last_row <= 1:
        return requests

    # 7. conditional formatting (order matters: first match wins)
    competitor_price_col = None
    diff_col = None
    for index, (header, role) in enumerate(zip(headers, roles)):
        if role == "price_diff":
            diff_col = index
        elif role == "price" and not header.strip().lower().endswith("_ac"):
            competitor_price_col = index

    rule_index = 0
    if competitor_price_col is not None:
        letter = _a1_column(competitor_price_col)
        requests.append({
            "addConditionalFormatRule": {
                "index": rule_index,
                "rule": {
                    "ranges": [_grid(sheet_id, 1, last_row, 0, used_cols)],
                    "booleanRule": {
                        "condition": {
                            "type": "CUSTOM_FORMULA",
                            # single-argument formula: locale independent
                            # (this sheet is ru_RU, where ';' separates arguments)
                            "values": [{"userEnteredValue": f'=NOT(${letter}2>0)'}],
                        },
                        "format": {
                            "backgroundColor": GREY_ROW,
                            "textFormat": {"foregroundColor": GREY_TEXT, "italic": True},
                        },
                    },
                },
            }
        })
        rule_index += 1

    if diff_col is not None:
        bound = _colour_scale_bound(diff_values)
        requests.append({
            "addConditionalFormatRule": {
                "index": rule_index,
                "rule": {
                    "ranges": [_grid(sheet_id, 1, last_row, diff_col, diff_col + 1)],
                    "gradientRule": {
                        # values are parsed like user input, so keep them integer
                        # formulas (a bare '-604.5' is rejected in this locale)
                        "minpoint": {"color": RED, "type": "NUMBER",
                                     "value": f"=-{int(round(bound))}"},
                        "midpoint": {"color": WHITE, "type": "NUMBER", "value": "0"},
                        "maxpoint": {"color": GREEN, "type": "NUMBER",
                                     "value": str(int(round(bound)))},
                    },
                },
            }
        })
        rule_index += 1

    # subtle zebra striping, lowest priority so it never hides a signal colour
    requests.append({
        "addConditionalFormatRule": {
            "index": rule_index,
            "rule": {
                "ranges": [_grid(sheet_id, 1, last_row, 0, used_cols)],
                "booleanRule": {
                    "condition": {
                        "type": "CUSTOM_FORMULA",
                        "values": [{"userEnteredValue": "=ISEVEN(ROW())"}],
                    },
                    "format": {"backgroundColor": ZEBRA},
                },
            },
        }
    })

    # a basic filter lets the reviewer sort by price difference in one click
    requests.append({
        "setBasicFilter": {
            "filter": {"range": _grid(sheet_id, 0, last_row, 0, used_cols)}
        }
    })

    return requests


def style_tab(spreadsheet, tab_name):
    worksheet = spreadsheet.worksheet(tab_name)
    values = worksheet.get_all_values()
    if not values:
        print(f"  [{tab_name}] empty tab, skipped")
        return

    headers = [h for h in values[0] if h.strip()]
    if not headers:
        print(f"  [{tab_name}] no header row, skipped")
        return
    data_rows = sum(1 for row in values[1:] if any(cell.strip() for cell in row))

    metadata = spreadsheet.fetch_sheet_metadata(
        {"fields": "sheets(properties(sheetId,title),conditionalFormats)"}
    )
    existing = 0
    for sheet in metadata["sheets"]:
        if sheet["properties"]["title"] == tab_name:
            existing = len(sheet.get("conditionalFormats", []))
            break

    diff_values = []
    diff_index = next((i for i, h in enumerate(headers) if _role(h) == "price_diff"), None)
    if diff_index is not None:
        for row in values[1:]:
            if diff_index < len(row):
                number = _parse_number(row[diff_index])
                if number is not None:
                    diff_values.append(number)

    requests = build_requests(worksheet, headers, data_rows, existing, diff_values)
    spreadsheet.batch_update({"requests": requests})
    print(f"  [{tab_name}] styled: {len(headers)} columns, {data_rows} data rows, "
          f"{len(requests)} formatting requests")


def main():
    parser = argparse.ArgumentParser(description="Apply the unified look to the price tabs")
    parser.add_argument("tab", nargs="?", help="tab name or scraper name (e.g. Mireli / mireli)")
    parser.add_argument("--all", action="store_true", help="style every price tab")
    args = parser.parse_args()

    if not args.all and not args.tab:
        parser.error("give a tab name or --all")

    targets = TABS if args.all else [SCRAPER_TO_TAB.get(args.tab.lower(), args.tab)]

    spreadsheet = _client().open_by_key(SPREADSHEET_ID)
    print("Applying unified styling...")
    for tab in targets:
        try:
            style_tab(spreadsheet, tab)
        except gspread.exceptions.WorksheetNotFound:
            print(f"  [{tab}] not found, skipped")
        except Exception as error:  # styling must never break a pipeline
            print(f"  [{tab}] styling failed: {type(error).__name__}: {error}")
    print("Done.")


if __name__ == "__main__":
    sys.exit(main())
