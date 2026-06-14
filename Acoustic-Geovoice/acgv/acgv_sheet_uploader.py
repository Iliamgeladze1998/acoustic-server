#!/usr/bin/env python3
"""
Google Sheets Uploader for Acoustic & Geovoice Price Comparison
Uploads comparison data to Geovoice tab with self-learning blacklist logic
"""

import os
import sys
import json
import time
import re
import requests
import pandas as pd
import numpy as np
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from datetime import datetime, timedelta

# --- Telegram Configuration ---
TELEGRAM_BOT_TOKEN = "8835894573:AAGkC2YHR8DnSvmII-bA3fvtO1GaW5CcHFA"
CHAT_ID = "-1003712689651"

# Store names for price change alerts
STORE_NAMES = {
    'Price_AC': 'Acoustic',
    'Price_GV': 'Geovoice',
}


def escape_md(text):
    """Escape special characters for Telegram MarkdownV2."""
    special_chars = r'\_*[]()~`>#+-=|{}.!'
    return ''.join(f'\\{c}' if c in special_chars else c for c in str(text))


def send_telegram_message(token, chat_id, message):
    """Send a formatted message via Telegram Bot API using MarkdownV2."""
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": message,
        "parse_mode": "MarkdownV2",
        "disable_web_page_preview": False,
    }
    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()
        print("   ✅ Telegram message sent successfully")
        return True
    except requests.exceptions.RequestException as e:
        print(f"   ⚠️  Failed to send Telegram message: {e}")
        return False


def load_blacklist():
    """Load blacklisted pairs from JSON file"""
    blacklist_file = os.path.join(os.path.dirname(__file__), 'data', 'blacklist.json')

    if not os.path.exists(blacklist_file):
        return []

    try:
        with open(blacklist_file, 'r', encoding='utf-8') as f:
            return json.load(f)
    except:
        return []


def save_blacklist(blacklist):
    """Save blacklisted pairs to JSON file"""
    blacklist_file = os.path.join(os.path.dirname(__file__), 'data', 'blacklist.json')
    os.makedirs(os.path.dirname(blacklist_file), exist_ok=True)

    with open(blacklist_file, 'w', encoding='utf-8') as f:
        json.dump(blacklist, f, indent=2, ensure_ascii=False)


def is_pair_blacklisted(link_ac, link_gv, blacklist):
    """Check if a pair of links is blacklisted"""
    return any(
        item["link_ac"] == link_ac and item["link_gv"] == link_gv
        for item in blacklist
    )


def _normalize_alert_key_value(value, is_url=False):
    """Normalize values used only for Telegram old/new row matching."""
    text = str(value).strip()
    if text.lower() in ('', 'nan', 'none', 'n/a', '-'):
        return ''
    text = ' '.join(text.split())
    if is_url:
        try:
            text = requests.utils.unquote(text)
        except Exception:
            pass
        text = text.split('#', 1)[0].rstrip('/')
    return text.lower()


def _alert_product_key(row, cols):
    """Build a stable product-pair key from exact links, with exact names as fallback."""
    link_ac = _normalize_alert_key_value(row.get(cols['link_ac'], ''), is_url=True)
    link_other = _normalize_alert_key_value(row.get(cols['link_other'], ''), is_url=True)
    if link_ac and link_other:
        return f"links::{link_ac}||{link_other}"

    name_ac = _normalize_alert_key_value(row.get(cols['name_ac'], ''))
    name_other = _normalize_alert_key_value(row.get(cols['name_other'], ''))
    if name_ac and name_other:
        return f"names::{name_ac}||{name_other}"
    return ''


def _build_alert_row_map(df, cols, label):
    """Create a unique key -> row map; ambiguous duplicate keys are skipped."""
    row_map = {}
    duplicate_keys = set()
    skipped = 0

    for _, row in df.iterrows():
        key = _alert_product_key(row, cols)
        if not key:
            skipped += 1
            continue
        if key in duplicate_keys:
            continue
        if key in row_map:
            duplicate_keys.add(key)
            del row_map[key]
            continue
        row_map[key] = row

    if skipped:
        print(f"   {label}: skipped {skipped} row(s) without a stable product key")
    if duplicate_keys:
        print(f"   {label}: skipped {len(duplicate_keys)} duplicate product key(s) to avoid mismatched alerts")
    return row_map


def _parse_alert_price(value):
    """Strictly parse a positive price for Telegram comparisons.

    Empty, invalid, and non-positive values are treated as missing data, not 0.
    """
    text = str(value).strip()
    if text.lower() in ('', 'nan', 'none', 'n/a', '-'):
        return None
    cleaned = text.replace('₾', '').replace(',', '').strip()
    cleaned = ''.join(cleaned.split())
    if not re.fullmatch(r'-?\d+(?:\.\d+)?', cleaned):
        return None
    try:
        price = round(float(cleaned), 2)
    except (TypeError, ValueError):
        return None
    return price if price > 0 else None


def _format_alert_price(value):
    price = _parse_alert_price(value)
    return f"{price:.2f}" if price is not None else 'N/A'


def fetch_sheet_as_dataframe(worksheet):
    """Fetch current Google Sheet data into a pandas DataFrame. Returns None if empty."""
    try:
        all_values = worksheet.get_all_values()
        if len(all_values) < 2:
            return None
        headers = all_values[0]
        rows = all_values[1:]
        return pd.DataFrame(rows, columns=headers)
    except Exception as e:
        print(f"⚠️  Could not fetch sheet data for comparison: {e}")
        return None


def detect_and_alert_price_changes(df_old, df_new, token, chat_id):
    """Compare old and new rows by exact product-pair key and alert only real price changes."""
    print(f"\n📊 Comparison baseline: df_old={len(df_old)} rows, df_new={len(df_new)} rows")
    if len(df_new) == 0:
        print("⚠️  Comparison failed: df_new is empty")
        return False
    if len(df_old) == 0:
        print("ℹ️  Comparison skipped: sheet baseline is empty")
        return True

    # Column mapping for acoustic-geovoice project
    cols = {
        'name_ac': 'Product_Name_AC',
        'name_other': 'Product_Name_GV',
        'price_ac': 'Price_AC',
        'price_other': 'Price_GV',
        'link_ac': 'Link_AC',
        'link_other': 'Link_GV',
        'other_store': 'Geovoice',
    }
    required_cols = [
        cols['name_ac'], cols['name_other'], cols['price_ac'], cols['price_other'],
        cols['link_ac'], cols['link_other'],
    ]
    missing_old = [c for c in required_cols if c not in df_old.columns]
    missing_new = [c for c in required_cols if c not in df_new.columns]
    if missing_old or missing_new:
        print(f"⚠️  Missing columns for exact Telegram comparison. old={missing_old}, new={missing_new}")
        return False

    old_rows = _build_alert_row_map(df_old, cols, 'old sheet')
    new_rows = _build_alert_row_map(df_new, cols, 'new scrape')
    matched_keys = set(old_rows).intersection(new_rows)
    print(f"   Exact product matches for Telegram comparison: {len(matched_keys)}")

    if not matched_keys:
        print("✅ No overlapping products found for price-change alerts")
        return True

    pending_alerts = []
    price_cols = [cols['price_ac'], cols['price_other']]

    for key, new_row in new_rows.items():
        if key not in old_rows:
            continue
        old_row = old_rows[key]

        for price_col in price_cols:
            old_price = _parse_alert_price(old_row.get(price_col, ''))
            new_price = _parse_alert_price(new_row.get(price_col, ''))

            if old_price is None or new_price is None:
                continue
            if abs(old_price - new_price) < 0.01:
                continue

            store_name = STORE_NAMES.get(price_col, price_col)
            product_name_ac = str(new_row.get(cols['name_ac'], '')).strip() or 'N/A'
            product_name_other = str(new_row.get(cols['name_other'], '')).strip() or 'N/A'
            link_ac = str(new_row.get(cols['link_ac'], '')).strip() or 'N/A'
            link_other = str(new_row.get(cols['link_other'], '')).strip() or 'N/A'
            old_display = f"{old_price:.2f}" if old_price is not None else 'N/A'
            new_display = f"{new_price:.2f}" if new_price is not None else 'N/A'
            current_price_ac = _format_alert_price(new_row.get(cols['price_ac'], ''))
            current_price_other = _format_alert_price(new_row.get(cols['price_other'], ''))

            pending_alerts.append((
                "🚨 *ფასის ცვლილება დეტექტირებულია\\!* 🚨\n"
                f"📦 *Acoustic პროდუქტი:* {escape_md(product_name_ac)}\n"
                f"📦 *{escape_md(cols['other_store'])} პროდუქტი:* {escape_md(product_name_other)}\n"
                f"🏪 *შეცვლილი მაღაზია:* {escape_md(store_name)}\n"
                f"💰 *ძველი → ახალი:* {escape_md(old_display)} ₾ ➡️ {escape_md(new_display)} ₾\n"
                f"*მიმდინარე ფასები:* Acoustic {escape_md(current_price_ac)} ₾ \\| {escape_md(cols['other_store'])} {escape_md(current_price_other)} ₾\n"
                f"🔗 *Acoustic ბმული:* {escape_md(link_ac)}\n"
                f"🔗 *{escape_md(cols['other_store'])} ბმული:* {escape_md(link_other)}"
            ))

    if not pending_alerts:
        print("✅ No price changes detected")
    else:
        for message in pending_alerts:
            if not send_telegram_message(token, chat_id, message):
                return False
        print(f"📨 Sent {len(pending_alerts)} Telegram alert(s) for exact product price changes")

    new_only_count = len(set(new_rows) - set(old_rows))
    if new_only_count:
        print(f"ℹ️  {new_only_count} new product(s) skipped by Telegram alerts; only existing-product price changes are notified.")

    return True


def upload_to_geovoice_tab():
    """Upload comparison data to Geovoice tab with self-learning logic"""

    print("=== GEOVOICE TAB UPLOADER ===")

    # Configuration
    script_dir = os.path.dirname(__file__)
    credentials_file = os.path.join(script_dir, '..', 'credentials.json')
    spreadsheet_id = "1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
    tab_name = "Geovoice"
    comparison_file = os.path.join(script_dir, '..', 'reports', 'acoustic_geovoice_comparison.xlsx')

    required_columns = [
        'Matching_Style', 'Match_Key', 'Product_Name_AC', 'Product_Name_GV',
        'Price_AC', 'Price_GV', 'Price_Diff', 'Link_AC', 'Link_GV',
        'Last_Updated', 'Feedback'
    ]

    # Step 1: Load existing blacklist
    print("\n1. Loading blacklist...")
    blacklist = load_blacklist()
    print(f"   Loaded {len(blacklist)} blacklisted pairs")

    # Step 2: Authenticate with Google Sheets
    print("\n2. Authenticating with Google Sheets...")
    try:
        client = gspread.service_account(filename=credentials_file)
        print("   Authentication successful")
    except Exception as e:
        print(f"   ERROR: Authentication failed: {e}")
        return False

    # Step 3: Open spreadsheet and get Geovoice tab
    print("\n3. Opening spreadsheet...")
    try:
        spreadsheet = client.open_by_key(spreadsheet_id)
        worksheet = spreadsheet.worksheet(tab_name)
        print(f"   Found '{tab_name}' tab")
    except gspread.WorksheetNotFound:
        print(f"   ERROR: Tab '{tab_name}' not found!")
        print("   Please create the tab manually in Google Sheets first.")
        return False
    except Exception as e:
        print(f"   ERROR: Failed to open spreadsheet: {e}")
        return False

    # Step 4: READ existing data BEFORE clearing (for comparison and self-learning)
    print("\n4. Reading existing sheet data before clear...")
    existing_data = []
    try:
        existing_data = worksheet.get_all_records()
        print(f"   Read {len(existing_data)} existing rows")
        if existing_data:
            df_old = pd.DataFrame(existing_data)
            if 'Product_Name_AC' not in df_old.columns:
                df_old = pd.DataFrame(columns=required_columns)
        else:
            df_old = pd.DataFrame(columns=required_columns)
    except Exception as e:
        print(f"   WARNING: Could not read existing data: {e}")
        df_old = pd.DataFrame(columns=required_columns)

    # Step 5: Learn from Feedback column (self-learning blacklist)
    print("\n5. Updating blacklist from Feedback column...")
    new_blacklist_entries = []
    for row in existing_data:
        feedback = row.get('Feedback', '')
        if feedback and str(feedback).strip().lower() == 'wrong':
            link_ac = row.get('Link_AC', '')
            link_gv = row.get('Link_GV', '')
            if link_ac and link_gv and not is_pair_blacklisted(link_ac, link_gv, blacklist):
                new_blacklist_entries.append({
                    "link_ac": link_ac,
                    "link_gv": link_gv,
                    "reason": "Feedback marked as Wrong",
                    "timestamp": datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
                })
    if new_blacklist_entries:
        blacklist.extend(new_blacklist_entries)
        save_blacklist(blacklist)
        print(f"   Added {len(new_blacklist_entries)} new entries to blacklist")
    else:
        print("   No new blacklist entries found")

    # Step 6: Load comparison data (df_new)
    print("\n6. Loading comparison data...")
    try:
        df_new = pd.read_excel(comparison_file)
        print(f"   Loaded {len(df_new)} comparison rows")
    except Exception as e:
        print(f"   ERROR: Failed to load comparison file: {e}")
        return False

    # Step 7: Filter df_new against blacklist
    print("\n7. Filtering new data against blacklist...")
    original_count = len(df_new)
    if blacklist:
        df_new = df_new[~df_new.apply(
            lambda row: is_pair_blacklisted(
                row.get('Link_AC', ''),
                row.get('Link_GV', ''),
                blacklist
            ), axis=1
        )]
        filtered_count = original_count - len(df_new)
        print(f"   Filtered out {filtered_count} blacklisted pairs")
    else:
        print("   No blacklist filtering needed")

    # Step 8: Stabilize both dataframes
    print("\n8. Stabilizing data...")

    # Ensure required columns exist in df_new
    for col in required_columns:
        if col not in df_new.columns:
            df_new[col] = ''

    # Strip whitespace from Product_Name_AC
    if 'Product_Name_AC' in df_old.columns and not df_old.empty:
        df_old['Product_Name_AC'] = df_old['Product_Name_AC'].astype(str).str.strip()
    if 'Product_Name_AC' in df_new.columns:
        df_new['Product_Name_AC'] = df_new['Product_Name_AC'].astype(str).str.strip()

    # Convert Price_AC and Price_GV to numeric (float), forcing non-numeric to 0
    for price_col in ['Price_AC', 'Price_GV']:
        if price_col in df_old.columns and not df_old.empty:
            df_old[price_col] = pd.to_numeric(df_old[price_col], errors='coerce').fillna(0).astype(float)
        if price_col in df_new.columns:
            df_new[price_col] = pd.to_numeric(df_new[price_col], errors='coerce').fillna(0).astype(float)

    # Normalize Match_Key: strip, treat empty-like values, then zero-pad to 5
    _empty_vals = {'nan', 'none', '', '-'}
    def _normalize_key(x):
        x = str(x).strip()
        return '' if x.lower() in _empty_vals else x.zfill(5)

    if not df_old.empty and 'Match_Key' in df_old.columns:
        df_old['Match_Key'] = df_old['Match_Key'].apply(_normalize_key)
    if 'Match_Key' in df_new.columns:
        df_new['Match_Key'] = df_new['Match_Key'].apply(_normalize_key)

    # Deduplicate both dataframes on Match_Key
    if not df_old.empty and 'Match_Key' in df_old.columns:
        df_old = df_old.drop_duplicates(subset=['Match_Key'], keep='last')
    df_new = df_new.drop_duplicates(subset=['Match_Key'], keep='last')

    # Build old_prices lookup dict keyed by normalized Match_Key
    if not df_old.empty and 'Price_GV' in df_old.columns and 'Match_Key' in df_old.columns:
        old_prices = dict(zip(df_old['Match_Key'], df_old['Price_GV']))
    else:
        old_prices = {}

    print(f"   df_old: {len(df_old)} unique keys | df_new: {len(df_new)} unique keys")

    # Step 9: Compute Tbilisi timestamp (UTC+4)
    now = (datetime.utcnow() + timedelta(hours=4)).strftime('%Y-%m-%d %H:%M:%S')

    # Update every row in Last_Updated column with Tbilisi time
    df_new['Last_Updated'] = now

    # Debug output
    print(f"\nDEBUG: Comparing {len(df_new)} products by Match_Key.")
    print(f"DEBUG: Current timestamp is {now}")
    print(f"DEBUG: Dataframe sizes - Old: {len(df_old)}, New: {len(df_new)}")
    if not df_old.empty and not df_new.empty:
        print(f"DEBUG: Sample Match_Keys - Old: {df_old['Match_Key'].iloc[0]}, New: {df_new['Match_Key'].iloc[0]}")

    # Step 10: TELEGRAM PRICE CHANGE ALERTS (New logic from reference)
    print("\n10. Checking for price changes before updating Google Sheets...")
    if not df_old.empty:
        if not detect_and_alert_price_changes(df_old, df_new, TELEGRAM_BOT_TOKEN, CHAT_ID):
            print("❌ Comparison/alert checkpoint failed. Aborting before Google Sheet update.")
            return False
    else:
        print("ℹ️  Sheet baseline is empty — skipping price comparison for this run.")

    # Step 11: Prepare data for upload
    print("\n11. Preparing data for upload...")
    df_upload = df_new[required_columns].copy()
    df_upload = df_upload.fillna('')
    print(f"   Prepared {len(df_upload)} rows for upload")

    # Step 12: Clear sheet AFTER reading df_old and sending alerts
    print("\n12. Clearing Geovoice tab...")
    try:
        worksheet.clear()
        print("   Sheet cleared")
    except Exception as e:
        print(f"   WARNING: Could not clear sheet: {e}")

    # Step 13: Upload data starting at A1
    print("\n13. Uploading data to Geovoice tab...")
    try:
        headers = required_columns
        values = df_upload.values
        worksheet.update([headers] + values.tolist())
        print(f"   Successfully uploaded {len(df_upload)} rows")
    except Exception as e:
        print(f"   ERROR: Upload failed: {e}")
        return False

    # Step 14: Apply basic sheet formatting (no conditional formatting rules)
    print("\n14. Applying sheet formatting...")
    worksheet_id = worksheet._properties['sheetId']
    num_cols = len(required_columns)
    num_rows = len(df_upload) + 1

    # Header row: Dark blue background, bold white text, size 10, centered
    print("   Formatting header row...")
    try:
        body = {
            "requests": [{
                "repeatCell": {
                    "range": {
                        "sheetId": worksheet_id,
                        "startRowIndex": 0,
                        "endRowIndex": 1,
                        "startColumnIndex": 0,
                        "endColumnIndex": num_cols
                    },
                    "cell": {
                        "userEnteredFormat": {
                            "backgroundColor": {"red": 0.122, "green": 0.306, "blue": 0.471},
                            "textFormat": {
                                "bold": True,
                                "fontSize": 10,
                                "foregroundColor": {"red": 1.0, "green": 1.0, "blue": 1.0}
                            },
                            "horizontalAlignment": "CENTER"
                        }
                    },
                    "fields": "userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Header row formatted")
    except Exception as e:
        print(f"   ✗ Failed to format header row: {e}")

    # Data rows: White background with soft gray borders
    print("   Formatting data rows...")
    try:
        gray = {"red": 0.85, "green": 0.85, "blue": 0.85}
        border_style = {"style": "SOLID", "color": gray}
        body = {
            "requests": [{
                "repeatCell": {
                    "range": {
                        "sheetId": worksheet_id,
                        "startRowIndex": 1,
                        "endRowIndex": num_rows,
                        "startColumnIndex": 0,
                        "endColumnIndex": num_cols
                    },
                    "cell": {
                        "userEnteredFormat": {
                            "backgroundColor": {"red": 1.0, "green": 1.0, "blue": 1.0},
                            "borders": {
                                "top": border_style,
                                "bottom": border_style,
                                "left": border_style,
                                "right": border_style
                            },
                            "textFormat": {"fontSize": 10}
                        }
                    },
                    "fields": "userEnteredFormat(backgroundColor,borders,textFormat)"
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Data rows formatted")
    except Exception as e:
        print(f"   ✗ Failed to format data rows: {e}")

    # Freeze first row
    print("   Freezing header row...")
    try:
        body = {
            "requests": [{
                "updateSheetProperties": {
                    "properties": {
                        "sheetId": worksheet_id,
                        "gridProperties": {
                            "frozenRowCount": 1
                        }
                    },
                    "fields": "gridProperties.frozenRowCount"
                }
            }]
        }
        spreadsheet.batch_update(body)
        print("   ✓ Header row frozen")
    except Exception as e:
        print(f"   ✗ Failed to freeze header row: {e}")

    # Step 15: Add timestamp in Georgia timezone
    print("\n15. Adding timestamp...")
    try:
        timestamp = now
        worksheet.update_acell('L1', f'Last Update: {timestamp} (Georgia Time)')
        print(f"   Timestamp added: {timestamp}")
    except Exception as e:
        print(f"   WARNING: Could not add timestamp: {e}")

    print("\n=== UPLOAD COMPLETED SUCCESSFULLY ===")
    print(f"   Total rows uploaded: {len(df_upload)}")
    print(f"   Blacklist size: {len(blacklist)}")
    print(f"   Timestamp: {now}")

    return True


if __name__ == "__main__":
    success = upload_to_geovoice_tab()
    sys.exit(0 if success else 1)
