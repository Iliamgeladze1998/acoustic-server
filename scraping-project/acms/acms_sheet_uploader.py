#!/usr/bin/env python3
"""
Google Sheets Uploader for Music Store Price Comparison
Uploads data from reports/price_comparison_final.xlsx to Google Sheets
"""

import sys
import io
import os
import pandas as pd
from datetime import datetime, timedelta
import json
import time
import requests
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from gspread_formatting import set_data_validation_for_cell_range, DataValidationRule, BooleanCondition, CellFormat, Color, TextFormat, format_cell_range, conditionalFormatRule, BooleanRule, get_conditional_format_rules, GridRange, Border, Borders

# Force UTF-8 output to handle Georgian text
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Telegram Configuration
TELEGRAM_TOKEN = "8835894573:AAGkC2YHR8DnSvmII-bA3fvtO1GaW5CcHFA"
CHAT_ID = "-1003712689651"
PRICE_COLUMNS = ['Price_AC', 'Price_MS']
STORE_NAMES = {
    'Price_AC': 'Acoustic',
    'Price_MS': 'Musikis-saxli',
}

def extract_blacklisted_pairs_from_sheet():
    """Extract blacklisted pairs from Google Sheets without clearing"""
    print("Extracting blacklisted pairs from Google Sheets...")
    
    try:
        # File paths
        credentials_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "credentials.json")
        
        # Check if credentials exist
        if not os.path.exists(credentials_path):
            print(f"Error: {credentials_path} not found!")
            return False
        
        # Authenticate with Google Sheets
        scope = ['https://www.googleapis.com/auth/spreadsheets', 'https://www.googleapis.com/auth/drive']
        creds = ServiceAccountCredentials.from_json_keyfile_name(credentials_path, scope)
        client = gspread.authorize(creds)
        
        # Open the spreadsheet
        spreadsheet_url = "https://docs.google.com/spreadsheets/d/1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
        print("Opening spreadsheet...")
        spreadsheet = client.open_by_url(spreadsheet_url)
        
        # Select the 'Musikis-saxli' tab
        try:
            worksheet = spreadsheet.worksheet("Musikis-saxli")
            print("Found 'Musikis-saxli' tab")
        except gspread.WorksheetNotFound:
            print("'Musikis-saxli' tab not found")
            return False
        
        # Read existing data
        existing_data = worksheet.get_all_values()
        if len(existing_data) > 1:  # Has header + data
            extract_blacklisted_pairs(existing_data)
            return True
        else:
            print("No data found in sheet")
            return True
            
    except Exception as e:
        print(f"Error extracting blacklist: {str(e)}")
        return False

def extract_blacklisted_pairs(sheet_data):
    """Extract blacklisted pairs from existing sheet data"""
    print("Extracting blacklisted pairs...")
    
    # Find column indices for client-facing columns
    headers = sheet_data[0]
    link_ac_idx = None
    link_ms_idx = None
    feedback_idx = None
    
    for i, header in enumerate(headers):
        if 'Link_AC' in header:
            link_ac_idx = i
        elif 'Link_MS' in header:
            link_ms_idx = i
        elif 'Feedback' in header:
            feedback_idx = i
        elif 'P' in header:
            feedback_idx = i
    
    if None in [link_ac_idx, link_ms_idx, feedback_idx]:
        print("Warning: Could not find required columns for blacklist extraction")
        return
    
    # Load existing blacklist
    blacklist_file = os.path.join(os.path.dirname(__file__), "data", "blacklist.json")
    os.makedirs(os.path.dirname(blacklist_file), exist_ok=True)
    
    existing_blacklist = []
    if os.path.exists(blacklist_file):
        try:
            with open(blacklist_file, 'r', encoding='utf-8') as f:
                existing_blacklist = json.load(f)
        except:
            existing_blacklist = []
    
    # Extract new blacklisted pairs
    new_blacklist = []
    for row in sheet_data[1:]:  # Skip header
        if len(row) > max(link_ac_idx, link_ms_idx, feedback_idx):
            feedback = row[feedback_idx].strip().lower() if feedback_idx is not None and row[feedback_idx] else ""
            link_ac = row[link_ac_idx].strip() if link_ac_idx is not None and row[link_ac_idx] else ""
            link_ms = row[link_ms_idx].strip() if link_ms_idx is not None and row[link_ms_idx] else ""
            
            if feedback in ['wrong', 'false'] and link_ac and link_ms:
                pair = {"link_ac": link_ac, "link_ms": link_ms}
                # Check if already in blacklist
                if not any(item["link_ac"] == link_ac and item["link_ms"] == link_ms for item in existing_blacklist):
                    new_blacklist.append(pair)
    
    # Update blacklist file
    if new_blacklist:
        updated_blacklist = existing_blacklist + new_blacklist
        with open(blacklist_file, 'w', encoding='utf-8') as f:
            json.dump(updated_blacklist, f, indent=2, ensure_ascii=False)
        print(f"Added {len(new_blacklist)} new blacklisted pairs to {blacklist_file}")
    else:
        print("No new blacklisted pairs found")

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
    time.sleep(1.5)
    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()
        print("   ✅ Telegram message sent successfully")
        return True
    except requests.exceptions.HTTPError as e:
        if e.response is not None and e.response.status_code == 429:
            print("   ⚠️  Rate limit hit, pausing...")
            time.sleep(10)
            try:
                response = requests.post(url, json=payload, timeout=10)
                response.raise_for_status()
                print("   ✅ Telegram message sent successfully (after retry)")
                return True
            except requests.exceptions.RequestException as retry_err:
                print(f"   ⚠️  Failed to send Telegram message after retry: {retry_err}")
                return False
        else:
            print(f"   ⚠️  Failed to send Telegram message: {e}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"   ⚠️  Failed to send Telegram message: {e}")
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
        print(f"⚠️  Could not fetch sheet data for comparison: {e}")
        return None


def parse_price(val):
    """Normalize any price value to float. Returns 0.0 for empty, N/A, nan, or invalid."""
    try:
        return float(str(val).strip().replace(',', '').replace(' ', ''))
    except (ValueError, TypeError):
        return 0.0


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
    """Parse a price for Telegram comparisons without treating formatting changes as price changes."""
    text = str(value).strip()
    if text.lower() in ('', 'nan', 'none', 'n/a', '-'):
        return None
    cleaned = text.replace(',', '').replace(' ', '').replace('₾', '')
    cleaned = ''.join(ch for ch in cleaned if ch.isdigit() or ch in '.-')
    if cleaned in ('', '-', '.', '-.'):
        return None
    try:
        return round(float(cleaned), 2)
    except (TypeError, ValueError):
        return None


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
        'name_ac': 'Product_Name_AC',
        'name_other': 'Product_Name_MS',
        'price_ac': 'Price_AC',
        'price_other': 'Price_MS',
        'link_ac': 'Link_AC',
        'link_other': 'Link_MS',
        'other_store': 'Musikis-saxli',
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

            if old_price is None and new_price is None:
                continue
            if old_price is not None and new_price is not None and abs(old_price - new_price) < 0.01:
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
                f"*შეცვლილი მაღაზია:* {escape_md(store_name)}\n"
                f"💰 *ძველი → ახალი:* {escape_md(old_display)} ₾ ➡️ {escape_md(new_display)} ₾\n"
                f"*მიმდინარე ფასები:* Acoustic {escape_md(current_price_ac)} ₾ \\| {escape_md(cols['other_store'])} {escape_md(current_price_other)} ₾\n"
                f"*Acoustic ბმული:* {escape_md(link_ac)}\n"
                f"*{escape_md(cols['other_store'])} ბმული:* {escape_md(link_other)}"
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


def upload_to_google_sheets():
    """Upload price comparison data to Google Sheets.

    Freshness contract:
      - df_new comes only from reports/price_comparison_final.xlsx.
      - The merged Excel must exist and be less than 24 hours old.
      - df_old comes only from the current Google Sheet state.
    """

    print("="*60)
    print("GOOGLE SHEETS UPLOADER")
    print("="*60)
    
    # File paths
    credentials_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "credentials.json")
    comparison_file = os.path.join(os.path.dirname(__file__), "reports", "price_comparison_final.xlsx")
    print(f"Credentials file: {credentials_path}")
    print(f"Data file: {comparison_file}")

    # Credentials are still a soft failure (config problem, not a stale-data problem).
    if not os.path.exists(credentials_path):
        print(f"Error: {credentials_path} not found!")
        return False

    _ensure_recent_merged_file(comparison_file)

    df_old = None
    try:
        # Load df_new STRICTLY from the freshly produced merged Excel — never from
        # an in-memory cache or a previous-run artifact.
        print("Loading price comparison data (fresh from merge_store_data() output)...")
        df = pd.read_excel(comparison_file)
        
        # Explicitly fill empty prices with 0
        for price_col in PRICE_COLUMNS:
            if price_col in df.columns:
                df[price_col] = pd.to_numeric(df[price_col].replace(['', ' ', 'nan', 'N/A', 'None'], pd.NA), errors='coerce').fillna(0)
                
        df = df.fillna('')  # Replace any remaining NaN values with empty strings for JSON serialization
        print(f"Loaded {len(df)} rows from price comparison file")
        
        # Authenticate with Google Sheets
        print("Authenticating with Google Sheets...")
        scope = [
            'https://www.googleapis.com/auth/spreadsheets',
            'https://www.googleapis.com/auth/drive'
        ]
        
        creds = ServiceAccountCredentials.from_json_keyfile_name(credentials_path, scope)
        client = gspread.authorize(creds)
        
        # Open the spreadsheet
        spreadsheet_url = "https://docs.google.com/spreadsheets/d/1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
        print("Opening spreadsheet...")
        spreadsheet = client.open_by_url(spreadsheet_url)
        
        # Select the 'Musikis-saxli' tab
        try:
            worksheet = spreadsheet.worksheet("Musikis-saxli")
            print("Found 'Musikis-saxli' tab")
            
            # CRITICAL: Read existing data before clearing for blacklist extraction
            print("Reading existing data for blacklist extraction...")
            existing_data = worksheet.get_all_values()
            if len(existing_data) > 1:  # Has header + data
                extract_blacklisted_pairs(existing_data)

            # df_old is the ONE AND ONLY valid baseline: the current Google Sheet
            # state, captured right before we clear/overwrite it. We never read
            # df_old from a local file, cache, or previous run — if the live sheet
            # has no data, we explicitly skip comparison rather than fall back.
            print("📊 Fetching baseline data for price change comparison (live Google Sheet only)...")
            df_old = fetch_sheet_as_dataframe(worksheet)
            if df_old is None:
                print("ℹ️  Sheet is empty — skipping price comparison for this run (no baseline available).")
            else:
                print(f"📊 Captured {len(df_old)} baseline rows from live sheet for price change comparison.")

        except gspread.WorksheetNotFound:
            print("Creating new 'Musikis-saxli' tab...")
            worksheet = spreadsheet.add_worksheet(title="Musikis-saxli", rows="1000", cols="20")
            existing_data = []
            df_old = None  # No prior sheet state ⇒ no baseline ⇒ no alerts this run.
            print("ℹ️  New sheet — skipping price comparison for this run.")

        # Check current worksheet size and expand if needed
        current_rows = len(existing_data)
        required_rows = len(df) + 1  # +1 for headers
        print(f"Current worksheet has {current_rows} rows, need {required_rows} rows")
        
        # Convert DataFrame to list of lists for upload
        print("Preparing data for upload...")
        # Only upload client-facing columns (clean and professional)
        client_columns = [
            'Matching_Style', 'Match_Key', 'Product_Name_AC', 'Product_Name_MS', 
            'Price_AC', 'Price_MS', 'Price_Diff', 'Link_AC', 'Link_MS', 
            'Last_Updated', 'Feedback'
        ]
        
        # Create headers list with only client-facing columns
        headers = client_columns
        data = [headers]
        
        # Add rows with only client-facing columns
        timestamp = (datetime.utcnow() + timedelta(hours=4)).strftime('%Y-%m-%d %H:%M:%S')
        for index, row in df.iterrows():
            row_data = []
            
            # Map client-facing columns in correct order
            column_mapping = {
                'Matching_Style': row.get('Matching_Style', ''),
                'Match_Key': row.get('Match_Key', ''),
                'Product_Name_AC': row.get('Product_Name_AC', ''),
                'Product_Name_MS': row.get('Product_Name_MS', ''),
                'Price_AC': row.get('Price_AC', ''),
                'Price_MS': row.get('Price_MS', ''),
                'Price_Diff': row.get('Price_Diff', ''),
                'Link_AC': row.get('Link_AC', ''),
                'Link_MS': row.get('Link_MS', ''),
                'Last_Updated': timestamp,
                'Feedback': ''  # Empty for dropdown selection
            }
            
            # Add columns in client-facing order
            for col in client_columns:
                value = column_mapping.get(col, '')
                # Specifically protect numeric 0 from being treated as falsy and converted to ""
                if value == 0 or value == 0.0:
                    row_data.append("0")
                elif pd.isna(value) or not value:
                    row_data.append("")
                else:
                    # Convert to string and ensure UTF-8 encoding
                    str_value = str(value)
                    row_data.append(str_value)
            
            data.append(row_data)

        # Telegram price change alerts MUST run before the sheet is overwritten.
        if df_old is not None:
            print("\n📊 Checking for price changes before updating Google Sheets...")
            df_new = pd.DataFrame(data[1:], columns=client_columns)
            if not detect_and_alert_price_changes(df_old, df_new, TELEGRAM_TOKEN, CHAT_ID):
                print("❌ Comparison/alert checkpoint failed. Aborting before Google Sheet update.")
                return False

        if current_rows < required_rows:
            print(f"Expanding worksheet to {required_rows} rows...")
            worksheet.add_rows(required_rows - current_rows)

        # Clear existing content only after alerts have been sent.
        print("Clearing existing content...")
        worksheet.clear()

        # Clear ALL existing data validation rules from columns A to Z
        print("Clearing all existing data validation rules...")
        set_data_validation_for_cell_range(worksheet, 'A2:Z2000', None)

        print("Sheet cleared successfully!")
        
        # Upload data in batches to avoid size limits
        print("Uploading data to Google Sheets...")
        batch_size = 1000
        total_rows = len(data)
        
        for i in range(0, total_rows, batch_size):
            batch_end = min(i + batch_size, total_rows)
            batch_data = data[i:batch_end]
            
            print(f"Uploading rows {i+1}-{batch_end} of {total_rows}...")
            
            if i == 0:
                # First batch includes headers - use named arguments to avoid deprecation
                worksheet.update(values=batch_data, range_name='A1')
            else:
                # Subsequent batches start after headers - use named arguments to avoid deprecation
                start_cell = f'A{i+2}'  # +2 for header row and 1-based indexing
                worksheet.update(values=batch_data, range_name=start_cell)
        
        print(f"Successfully uploaded {total_rows-1} data rows plus headers to 'Musikis-saxli' tab!")
        print(f"Spreadsheet URL: {spreadsheet_url}")
        
        # Add timestamp and last update info to the sheet
        timestamp = (datetime.utcnow() + timedelta(hours=4)).strftime('%Y-%m-%d %H:%M:%S')
        print(f"Last updated: {timestamp}")
        
        # Add timestamp and update info to last rows of the sheet
        try:
            # Add timestamp to the end of data
            timestamp_data = [["Last Updated:", timestamp]]
            worksheet.append_rows(timestamp_data)
            print("Added timestamp to sheet")
            
            # Add update info to O (Last_Updated) and P (Feedback) columns with dropdowns
            print(f"Adding update info and visual feedback to columns...")
            all_values = worksheet.get_all_values()
            
            # Find the O (Last_Updated) and P (Feedback) columns
            o_col_index = None
            p_col_index = None
            if all_values and len(all_values) > 1:
                headers = all_values[0]
                if 'Last_Updated' in headers:
                    o_col_index = headers.index('Last_Updated')
                elif 'O' in headers:
                    o_col_index = headers.index('O')
                elif 'Last' in headers:
                    o_col_index = headers.index('Last')
                
                if 'Feedback' in headers:
                    p_col_index = headers.index('Feedback')
                elif 'P' in headers:
                    p_col_index = headers.index('P')
            
            # Apply data validation dropdowns to column P (Feedback)
            if o_col_index is not None and p_col_index is not None:
                print("   Adding data validation dropdowns...")
                
                # Define rule: Dropdown with 3 options
                validation_rule = DataValidationRule(
                    BooleanCondition('ONE_OF_LIST', ['Correct', 'Wrong', 'Needs Review']),
                    showCustomUi=True
                )
                
                # Apply Feedback dropdown ONLY to column K (index 10)
                print("   Applying Feedback dropdown to column K...")
                feedback_validation_range = f'K2:K{len(data)}'
                set_data_validation_for_cell_range(worksheet, feedback_validation_range, validation_rule)
                print(f"   Applied dropdown validation to column K (rows 2-{len(data)})")
                
                # Apply conditional formatting for professional visual analysis
                print("   Applying conditional formatting...")
                
                # Define color formats
                green_format = CellFormat(
                    backgroundColor=Color(0.9, 1.0, 0.9),  # Light green
                    textFormat=TextFormat(foregroundColor=Color(0, 0, 0))  # Black text
                )
                
                yellow_format = CellFormat(
                    backgroundColor=Color(1.0, 1.0, 0.8),  # Light yellow
                    textFormat=TextFormat(foregroundColor=Color(0, 0, 0))  # Black text
                )
                
                # Find Price_AC and Price_MS column indices
                price_ac_idx = None
                price_ms_idx = None
                for i, header in enumerate(headers):
                    if 'Price_AC' in header:
                        price_ac_idx = i
                    elif 'Price_MS' in header:
                        price_ms_idx = i
                
                if price_ac_idx is not None and price_ms_idx is not None:
                    # Apply Batch Conditional Formatting using Google Sheets Formulas
                    total_rows = len(data) - 1  # Exclude header
                    
                    print(f"   Applying Batch Conditional Formatting to {total_rows} rows...")
                    
                    # Define the range for conditional formatting (A2:K2000)
                    end_col = chr(ord("A") + len(headers) - 1)
                    format_range = f'A2:{end_col}2000'
                    
                    # 1. Define range clearly
                    target_range = GridRange.from_a1_range('A2:K2000', worksheet)

                    # Green formula: Simple check - both E and F have values > 0
                    # Using multiplication: if both > 0, product > 0
                    green_formula = '=($E2*$F2)>0'

                    # Construct green rule
                    green_rule = conditionalFormatRule(
                        ranges=[target_range],
                        booleanRule=BooleanRule(
                            condition=BooleanCondition('CUSTOM_FORMULA', values=[{'userEnteredValue': green_formula}]),
                            format=CellFormat(backgroundColor=Color(0.717, 0.882, 0.804))
                        )
                    )

                    # Save rules (only green, no yellow) - non-blocking
                    try:
                        rules = get_conditional_format_rules(worksheet)
                        rules.clear()
                        rules.append(green_rule)
                        rules.save()
                        apply_standard_sheet_formatting(worksheet, headers, len(data))
                        print("   Successfully applied conditional formatting!")
                        print(f"   Range: A2:K2000")
                        print(f"   Green rule: Both prices present (Columns E & F)")
                    except Exception as e:
                        print(f"   Warning: Conditional formatting failed: {e}")
                        print("   Data uploaded successfully, but coloring was not applied.")
                else:
                    print("   Could not find Price_AC/Price_MS columns for formatting")
                    return False
                
                print(f"   Last_Updated column index: {o_col_index}, Feedback column index: {p_col_index}")
                print(f"   Skipping per-row timestamp update to avoid Sheets write quota errors.")
            else:
                print("Could not find O/Update/Last column for update tracking")
                
        except Exception as e:
            print(f"Could not add update info: {str(e)}")
        
        return True
        
    except Exception as e:
        print(f"Error uploading to Google Sheets: {str(e)}")
        return False

def main():
    """Main function"""
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    # upload_to_google_sheets() will call _abort_critical()/sys.exit(1) if any
    # required fresh artifact is missing or stale, so we won't reach the
    # branches below in that case.
    success = upload_to_google_sheets()

    if success:
        print("\n" + "="*60)
        print("UPLOAD COMPLETED SUCCESSFULLY!")
        print("="*60)
    else:
        print("\n" + "="*60)
        print("UPLOAD FAILED!")
        print("="*60)
        sys.exit(1)

if __name__ == "__main__":
    main()
