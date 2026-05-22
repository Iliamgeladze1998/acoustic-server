#!/usr/bin/env python3
"""
ACMR Sheet Uploader
Uploads merged report data to Google Sheets using google-auth
Features: Blacklist filtering, Feedback dropdown, Yellow background, Georgia timestamp
"""

import os
import sys
import json
import re
from datetime import datetime
from zoneinfo import ZoneInfo
import pandas as pd
import requests
import gspread
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
from gspread_formatting import CellFormat, Color, TextFormat, format_cell_range, conditionalFormatRule, BooleanRule, BooleanCondition, get_conditional_format_rules, GridRange, Border, Borders

# Configuration
SPREADSHEET_ID = "1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
TAB_NAME = "Musicroom"
FEEDBACK_OPTIONS = ['Correct', 'Needs Review', 'Wrong']

# Telegram Configuration
TELEGRAM_TOKEN = "8835894573:AAGkC2YHR8DnSvmII-bA3fvtO1GaW5CcHFA"
CHAT_ID = "-1003712689651"
PRICE_COLUMNS = ['price_ac', 'price_mr']
STORE_NAMES = {
    'price_ac': 'Acoustic',
    'price_mr': 'Musicroom',
}
MERGED_FILE_MAX_AGE_SECONDS = 24 * 60 * 60


def _abort_critical(message):
    """Log a CRITICAL pipeline error and abort the process immediately."""
    banner = "=" * 60
    print(banner, flush=True)
    print(f"CRITICAL: {message}", flush=True)
    print("ABORTING pipeline - uploader will NOT proceed with stale or missing merged data.", flush=True)
    print(banner, flush=True)
    sys.exit(1)


def _ensure_recent_merged_file(merged_file):
    """Require the merged Excel file to exist and be less than 24 hours old."""
    if not os.path.exists(merged_file):
        _abort_critical(
            f"Merged Excel file not found: {merged_file}. "
            "Run the merger before starting the uploader."
        )

    file_mtime = os.path.getmtime(merged_file)
    age_seconds = datetime.now().timestamp() - file_mtime
    if age_seconds > MERGED_FILE_MAX_AGE_SECONDS:
        modified_at = datetime.fromtimestamp(file_mtime).strftime("%Y-%m-%d %H:%M:%S")
        age_hours = age_seconds / 3600
        _abort_critical(
            f"Merged Excel file is older than 24 hours: {merged_file} "
            f"(modified {modified_at}, age {age_hours:.2f} hours)."
        )

    modified_at = datetime.fromtimestamp(file_mtime).strftime("%Y-%m-%d %H:%M:%S")
    age_hours = max(age_seconds, 0) / 3600
    print(
        f"✅ Freshness check passed: merged Excel modified at {modified_at} "
        f"({age_hours:.2f} hours old)."
    )

def load_blacklist(blacklist_path):
    """Load blacklist.json and return set of UNIQUE_IDs"""
    if not os.path.exists(blacklist_path):
        return set()
    try:
        with open(blacklist_path, 'r', encoding='utf-8') as f:
            content = f.read().strip()
            if not content:
                return set()
            data = json.loads(content)
            if isinstance(data, list):
                return set(str(item.get('UNIQUE_ID', item)) for item in data if item)
            elif isinstance(data, dict):
                return set(str(k) for k in data.keys())
    except Exception as e:
        print(f"⚠️  Could not load blacklist: {e}")
    return set()

def save_blacklist(blacklist_path, blacklist_ids, new_entries):
    """Save updated blacklist to file"""
    try:
        data = [{'UNIQUE_ID': uid, 'reason': 'Wrong feedback'} for uid in sorted(blacklist_ids)]
        with open(blacklist_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"✅ Added {len(new_entries)} new entries to blacklist")
    except Exception as e:
        print(f"⚠️  Could not save blacklist: {e}")

def check_wrong_feedback_and_update_blacklist(worksheet, blacklist_path, existing_blacklist):
    """Download current sheet and check for 'Wrong' feedback, update blacklist.json"""
    new_blacklist_entries = set()
    try:
        all_values = worksheet.get_all_values()
        if len(all_values) < 2:
            print("✅ Sheet is empty, no feedback to check")
            return existing_blacklist, new_blacklist_entries
        
        headers = all_values[0]
        print(f"   Sheet headers: {headers}")
        print(f"   Total rows in sheet: {len(all_values)-1}")
        
        # Find Feedback and ID column indices
        feedback_idx = None
        id_idx = None
        for i, h in enumerate(headers):
            if h.lower() == 'feedback':
                feedback_idx = i
                print(f"   ✓ Found 'Feedback' column at index {i} (Column {chr(ord('A') + i)})")
            # Use product_name_ac as the unique identifier
            if h.lower() in ['product_name_ac', 'product name ac']:
                id_idx = i
                print(f"   ✓ Found ID column 'product_name_ac' at index {i} (Column {chr(ord('A') + i)})")
        
        if feedback_idx is None:
            print("⚠️  Feedback column not found in sheet!")
            return existing_blacklist, new_blacklist_entries
        
        if id_idx is None:
            print("⚠️  No suitable ID column found (expected product_name_ac)!")
            return existing_blacklist, new_blacklist_entries
        
        print(f"   Checking {len(all_values)-1} rows for 'Wrong' feedback...")
        
        for idx, row in enumerate(all_values[1:], start=2):
            if len(row) > feedback_idx:
                feedback = row[feedback_idx].strip().lower()
                
                if feedback == 'wrong' and len(row) > id_idx:
                    product_id = str(row[id_idx]).strip()
                    if product_id and product_id not in existing_blacklist:
                        print(f"   ✓ Found 'Wrong' entry: {product_id[:50]}...")
                        new_blacklist_entries.add(product_id)
                        existing_blacklist.add(product_id)
        
        if new_blacklist_entries:
            print(f"\n📝 Found {len(new_blacklist_entries)} new 'Wrong' feedback entries")
            data = [{'UNIQUE_ID': uid, 'reason': 'Wrong feedback'} for uid in sorted(existing_blacklist)]
            with open(blacklist_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"✅ Saved {len(new_blacklist_entries)} new entries to {blacklist_path}")
        else:
            print("✅ No new 'Wrong' feedback entries found")
            
    except Exception as e:
        print(f"⚠️  Could not check feedback: {e}")
        import traceback
        traceback.print_exc()
    
    return existing_blacklist, new_blacklist_entries

def filter_blacklist(df, blacklist_ids):
    """Filter out rows where product_name_ac is in blacklist"""
    if not blacklist_ids or 'product_name_ac' not in df.columns:
        return df
    
    original_count = len(df)
    df_filtered = df[~df['product_name_ac'].astype(str).isin(blacklist_ids)]
    filtered_count = len(df_filtered)
    removed = original_count - filtered_count
    
    if removed > 0:
        print(f"🚫 Filtered out {removed} blacklisted product(s)")
    
    return df_filtered

def add_timestamp_and_feedback(df):
    """Add Last Updated timestamp and empty Feedback column"""
    # Georgia time is UTC+4
    georgia_time = datetime.now(ZoneInfo("Asia/Tbilisi"))
    timestamp = georgia_time.strftime("%Y-%m-%d %H:%M:%S GET")
    
    # Add Last Updated column
    df['Last Updated'] = timestamp
    
    # Add Feedback column if not exists
    if 'Feedback' not in df.columns:
        df['Feedback'] = ''
    
    return df

def column_letter(index):
    result = ''
    while index > 0:
        index, remainder = divmod(index - 1, 26)
        result = chr(65 + remainder) + result
    return result

def apply_standard_sheet_formatting(worksheet, headers, row_count):
    print("   Applying standardized sheet formatting...")
    if not headers or row_count < 1:
        return
    end_col = column_letter(len(headers))
    full_range = f'A1:{end_col}{row_count}'
    data_range = f'A2:{end_col}{max(row_count, 2)}'
    header_range = f'A1:{end_col}1'
    soft_border = Border('SOLID', Color(0.85, 0.85, 0.85))

    format_cell_range(worksheet, full_range, CellFormat(
        backgroundColor=Color(1, 1, 1),
        textFormat=TextFormat(foregroundColor=Color(0, 0, 0), fontSize=10),
        horizontalAlignment='LEFT',
        borders=Borders(top=soft_border, bottom=soft_border, left=soft_border, right=soft_border)
    ))
    format_cell_range(worksheet, header_range, CellFormat(
        backgroundColor=Color(0.122, 0.306, 0.471),
        textFormat=TextFormat(foregroundColor=Color(1, 1, 1), bold=True, fontSize=10),
        horizontalAlignment='CENTER',
        borders=Borders(top=soft_border, bottom=soft_border, left=soft_border, right=soft_border)
    ))

    for idx, header in enumerate(headers, start=1):
        col = column_letter(idx)
        if header in ['Price_AC', 'Price_MS', 'Price_MIR', 'Price_MR', 'Price_Diff']:
            format_cell_range(worksheet, f'{col}2:{col}{row_count}', CellFormat(horizontalAlignment='RIGHT'))
        elif 'Product_Name' in header or 'Link_' in header:
            format_cell_range(worksheet, f'{col}2:{col}{row_count}', CellFormat(horizontalAlignment='LEFT'))

    target_range = GridRange.from_a1_range(data_range, worksheet)
    id_rule = conditionalFormatRule(
        ranges=[target_range],
        booleanRule=BooleanRule(
            condition=BooleanCondition('CUSTOM_FORMULA', values=[{'userEnteredValue': '=$A2="ID"'}]),
            format=CellFormat(backgroundColor=Color(1.0, 0.949, 0.8))
        )
    )
    model_rule = conditionalFormatRule(
        ranges=[target_range],
        booleanRule=BooleanRule(
            condition=BooleanCondition('CUSTOM_FORMULA', values=[{'userEnteredValue': '=OR($A2="Model",$A2="Fuzzy")'}]),
            format=CellFormat(backgroundColor=Color(0.851, 0.918, 0.827))
        )
    )
    rules = get_conditional_format_rules(worksheet)
    rules.clear()
    rules.append(id_rule)
    rules.append(model_rule)
    rules.save()
    worksheet.freeze(rows=1)
    print("   Standardized formatting applied.")

def apply_formatting(worksheet, df, row_count, creds):
    """Apply formatting: yellow background, bold headers, frozen row, dropdowns"""
    try:
        # Set entire sheet to light yellow background
        if row_count > 0:
            yellow_range = f"A1:K{row_count + 1}"
            worksheet.format(yellow_range, {
                'backgroundColor': {'red': 1.0, 'green': 1.0, 'blue': 0.9}
            })
        
        # Bold headers (first row) with slightly darker yellow
        worksheet.format('A1:K1', {
            'textFormat': {'bold': True},
            'backgroundColor': {'red': 1.0, 'green': 1.0, 'blue': 0.7}
        })
        
        # Freeze first row
        worksheet.freeze(rows=1)
        
        # Find Feedback column index
        feedback_col_idx = None
        for idx, col in enumerate(df.columns):
            if col.lower() == 'feedback':
                feedback_col_idx = idx
                break
        
        # Add dropdown validation to Feedback column J2:J1000 using Sheets API
        if feedback_col_idx is not None and creds:
            try:
                # Build Sheets API service
                sheets_service = build('sheets', 'v4', credentials=creds, cache_discovery=False)
                
                # Prepare data validation request for range J2:J1000
                validation_request = {
                    'setDataValidation': {
                        'range': {
                            'sheetId': worksheet.id,
                            'startRowIndex': 1,  # Row 2 (0-indexed)
                            'endRowIndex': 1000,
                            'startColumnIndex': feedback_col_idx,
                            'endColumnIndex': feedback_col_idx + 1
                        },
                        'rule': {
                            'condition': {
                                'type': 'ONE_OF_LIST',
                                'values': [
                                    {'userEnteredValue': 'Correct'},
                                    {'userEnteredValue': 'Needs Review'},
                                    {'userEnteredValue': 'Wrong'}
                                ]
                            },
                            'inputMessage': 'Select feedback: Correct, Needs Review, or Wrong',
                            'strict': False,
                            'showCustomUi': True
                        }
                    }
                }
                
                # Execute batch update
                sheets_service.spreadsheets().batchUpdate(
                    spreadsheetId=SPREADSHEET_ID,
                    body={'requests': [validation_request]}
                ).execute()
                
                col_letter = chr(ord('A') + feedback_col_idx)
                print(f"✅ Added dropdown to {col_letter}2:{col_letter}1000 with options: {FEEDBACK_OPTIONS}")
            except Exception as e:
                print(f"⚠️  Could not add dropdown: {e}")
        
        apply_standard_sheet_formatting(worksheet, df.columns.tolist(), row_count + 1)
        print("✅ Applied standardized formatting")
        
    except Exception as e:
        print(f"⚠️  Error applying formatting: {e}")

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
        print("   \u2705 Telegram message sent successfully")
        return True
    except requests.exceptions.RequestException as e:
        print(f"   \u26a0\ufe0f  Failed to send Telegram message: {e}")
        return False


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
        print(f"\u26a0\ufe0f  Could not fetch sheet data for comparison: {e}")
        return None


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


def detect_and_alert_price_changes(df_old, df_new, token, chat_id):
    """Compare old and new rows by exact product-pair key and alert only real price changes."""
    print(f"\n📊 Comparison baseline: df_old={len(df_old)} rows, df_new={len(df_new)} rows")
    if len(df_new) == 0:
        print("⚠️  Comparison failed: df_new is empty")
        return False
    if len(df_old) == 0:
        print("ℹ️  Comparison skipped: sheet baseline is empty")
        return True

    cols = {
        'name_ac': 'product_name_ac',
        'name_other': 'product_name_mr',
        'price_ac': 'price_ac',
        'price_other': 'price_mr',
        'link_ac': 'link_ac',
        'link_other': 'link_mr',
        'other_store': 'Musicroom',
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


def main():
    print("="*60)
    print("ACMR SHEET UPLOADER")
    print("="*60)
    
    # File paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    credentials_path = os.path.join(project_root, "credentials.json")
    excel_path = os.path.join(project_root, "reports", "acmr_merged_report.xlsx")
    blacklist_path = os.path.join(script_dir, "data", "blacklist.json")
    
    # Ensure data directory exists
    os.makedirs(os.path.dirname(blacklist_path), exist_ok=True)
    
    # STEP 1: Authenticate with Google Sheets FIRST
    scopes = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]
    creds = None
    client = None
    
    try:
        creds = Credentials.from_service_account_file(credentials_path, scopes=scopes)
        client = gspread.authorize(creds)
        print("✅ Successfully authenticated with Google Sheets")
    except Exception as e:
        print(f"❌ Authentication failed: {e}")
        return False

    # STEP 2: Open spreadsheet and download current data
    try:
        spreadsheet = client.open_by_key(SPREADSHEET_ID)
        print(f"✅ Opened spreadsheet: {spreadsheet.title}")
        
        # Try to get existing worksheet
        try:
            worksheet = spreadsheet.worksheet(TAB_NAME)
            print(f"✅ Found existing tab '{TAB_NAME}'")
            
            # STEP 3: Download and check for 'Wrong' feedback BEFORE anything else
            print("📥 Downloading current sheet to check for 'Wrong' feedback...")
            blacklist_ids = load_blacklist(blacklist_path)
            blacklist_ids, new_wrongs = check_wrong_feedback_and_update_blacklist(worksheet, blacklist_path, blacklist_ids)
            
        except gspread.WorksheetNotFound:
            print(f"Tab '{TAB_NAME}' not found, will create new")
            worksheet = None
            blacklist_ids = load_blacklist(blacklist_path)
    except Exception as e:
        print(f"❌ Error opening spreadsheet: {e}")
        return False
    
    print(f"📋 Blacklist now has {len(blacklist_ids)} product(s)")
    
    # STEP 4: Load Excel data
    _ensure_recent_merged_file(excel_path)
    
    try:
        df = pd.read_excel(excel_path)
        print(f"✅ Loaded {len(df)} rows from Excel file")
    except Exception as e:
        print(f"❌ Error loading Excel file: {e}")
        return False
    
    # STEP 5: Filter out blacklisted products
    df = filter_blacklist(df, blacklist_ids)
    
    # STEP 6: Add timestamp and feedback column
    df = add_timestamp_and_feedback(df)
    
    # STEP 7: Compare and alert before clearing/uploading
    df_old = None
    try:
        if worksheet is None:
            worksheet = spreadsheet.add_worksheet(title=TAB_NAME, rows="1000", cols="20")
            print(f"✅ Created new tab '{TAB_NAME}'")
        else:
            # Fetch baseline before clearing for price change comparison
            print("📊 Fetching baseline data for price change comparison...")
            df_old = fetch_sheet_as_dataframe(worksheet)
            if df_old is None:
                print("ℹ️  Sheet is empty — skipping price comparison for this run.")

        # Convert DataFrame to list of lists
        data = [df.columns.tolist()] + df.values.tolist()

        # Telegram alerts must be sent before the sheet baseline is overwritten.
        if df_old is not None:
            print("\n📊 Checking for price changes before updating Google Sheets...")
            if not detect_and_alert_price_changes(df_old, df, TELEGRAM_TOKEN, CHAT_ID):
                print("❌ Comparison/alert checkpoint failed. Aborting before Google Sheet update.")
                return False

        # Clear the worksheet only after alerts have been sent.
        worksheet.clear()

        # Upload data
        worksheet.update(data, value_input_option='RAW')
        print(f"✅ Uploaded {len(data)} rows to tab '{TAB_NAME}'")
        
        # Apply formatting
        apply_formatting(worksheet, df, len(df), creds)
        
    except Exception as e:
        print(f"❌ Error during upload: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    print("\n🎉 Upload completed successfully!")

    return True

if __name__ == "__main__":
    success = main()
    if not success:
        print("\n❌ Upload failed!")
        sys.exit(1)
