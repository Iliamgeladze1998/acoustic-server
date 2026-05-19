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
    except requests.exceptions.HTTPError as e:
        if e.response is not None and e.response.status_code == 429:
            print("   ⚠️  Rate limit hit, pausing...")
            time.sleep(10)
            try:
                response = requests.post(url, json=payload, timeout=10)
                response.raise_for_status()
                print("   ✅ Telegram message sent successfully (after retry)")
            except requests.exceptions.RequestException as retry_err:
                print(f"   ⚠️  Failed to send Telegram message after retry: {retry_err}")
        else:
            print(f"   ⚠️  Failed to send Telegram message: {e}")
    except requests.exceptions.RequestException as e:
        print(f"   ⚠️  Failed to send Telegram message: {e}")


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


def detect_and_alert_price_changes(df_old, df_new, token, chat_id):
    """Compare old and new DataFrames by product ID and send Telegram alerts for price changes."""
    print(f"\n📊 Comparison baseline: df_old={len(df_old)} rows, df_new={len(df_new)} rows")
    if len(df_old) == 0 or len(df_new) == 0:
        print("⚠️  Comparison skipped due to data mismatch: one of the DataFrames is empty")
        return
    row_diff_pct = abs(len(df_old) - len(df_new)) / max(len(df_new), 1)
    if row_diff_pct > 0.10:
        print(f"⚠️  Comparison skipped due to data mismatch: df_old={len(df_old)} rows vs df_new={len(df_new)} rows ({row_diff_pct:.1%} difference — threshold is 10%)")
        return

    id_col = 'Match_Key'
    if id_col not in df_old.columns or id_col not in df_new.columns:
        print(f"⚠️  '{id_col}' column not found in sheet data, skipping alerts")
        return

    name_col = None
    for col in df_new.columns:
        if 'product_name' in col.lower():
            name_col = col
            break

    link_cols = [col for col in df_new.columns if 'link' in col.lower()]
    price_cols = [c for c in PRICE_COLUMNS if c in df_old.columns and c in df_new.columns]

    if not price_cols:
        print("⚠️  No price columns found for comparison, skipping alerts")
        return

    # Deduplicate both DataFrames on Match_Key so each product is processed exactly once
    df_old = df_old.drop_duplicates(subset=[id_col], keep='last')
    df_new = df_new.drop_duplicates(subset=[id_col], keep='last')
    print(f"   Processing {len(df_new)} unique products after deduplication (df_old: {len(df_old)}, df_new: {len(df_new)})")

    df_old_indexed = df_old.set_index(id_col)
    pending_alerts = []  # Collect all alerts before sending

    for _, new_row in df_new.iterrows():
        product_id = str(new_row.get(id_col, '')).strip()
        if not product_id or product_id not in df_old_indexed.index:
            continue

        old_row = df_old_indexed.loc[product_id]
        if isinstance(old_row, pd.DataFrame):
            old_row = old_row.iloc[0]

        for price_col in price_cols:
            old_val = old_row.get(price_col, '')
            new_val = new_row.get(price_col, '')

            old_str = str(old_val).strip().lower()
            new_str = str(new_val).strip().lower()

            # Out-of-stock: new price is zero/empty — skip silently
            if new_str in ['0', '0.0', '', 'nan', 'n/a', 'none']:
                continue

            # Fast-path: identical strings
            if old_str == new_str:
                continue

            # Robust numeric comparison: round to 2dp, treat diff < 0.01 as identical
            old_price = round(parse_price(old_val), 2)
            new_price = round(parse_price(new_val), 2)

            if abs(old_price - new_price) < 0.01:
                print(f"DEBUG: ID={product_id} | col={price_col} | old={old_str!r}({old_price}) new={new_str!r}({new_price}) | Decision: Skip (same price after rounding)")
                continue

            print(f"DEBUG: ID={product_id} | col={price_col} | old={old_str!r}({old_price}) new={new_str!r}({new_price}) | Decision: ALERT")

            product_name = str(new_row.get(name_col, product_id)) if name_col else product_id
            store_name = STORE_NAMES.get(price_col, price_col)
            old_display = f"{old_price:.2f}" if old_price != 0.0 else 'N/A'
            new_display = f"{new_price:.2f}" if new_price != 0.0 else 'N/A'

            links_lines = ''
            for lc in link_cols:
                link_val = str(new_row.get(lc, '')).strip()
                if link_val and link_val not in ('nan', 'None', ''):
                    links_lines += f'\n  \\- {escape_md(lc)}: {escape_md(link_val)}'
            if not links_lines:
                links_lines = '\n  \\- N/A'

            pending_alerts.append((
                "🚨 *ფასის ცვლილება დეტექტირებულია\\!* 🚨\n"
                f"📦 *პროდუქტი:* {escape_md(product_name)}\n"
                f"🏦 *მაღაზია:* {escape_md(store_name)}\n"
                f"💰 *ცვლილება:* {escape_md(old_display)} ₾ ➡️ {escape_md(new_display)} ₾\n"
                f"🔗 *ბმულები:*{links_lines}"
            ))

    # Safety cap: > 5 pending alerts → send one consolidated message instead
    alert_count = len(pending_alerts)
    if alert_count == 0:
        print("✅ No price changes detected")
    elif alert_count > 5:
        print(f"⚠️  {alert_count} alerts queued — exceeds safety cap of 5, sending single consolidated notification")
        consolidated = (
            "🚨 *ფასის ცვლილება დეტექტირებულია\\!* 🚨\n"
            f"📦 სულ {escape_md(str(alert_count))} პროდუქტის ფასი შეიცვალა\\.\n"
            "📢 *გთხოვთ, ფასების სხვაობა გუგლ შითში გადაამოწმოთ\\.*"
        )
        send_telegram_message(token, chat_id, consolidated)
        print(f"📨 Sent 1 consolidated alert covering {alert_count} price changes")
    else:
        for msg in pending_alerts:
            send_telegram_message(token, chat_id, msg)
        print(f"📨 Sent {alert_count} Telegram alert(s) for price changes")

    # Detect new products: in df_new but absent from df_old
    old_ids = set(df_old_indexed.index.astype(str).str.strip())
    new_ids = set(df_new[id_col].astype(str).str.strip())
    new_products = new_ids - old_ids
    new_products.discard('')
    new_count = len(new_products)

    if new_count > 0:
        print(f"🆕 {new_count} new product(s) detected, sending consolidated alert...")
        message = (
            "✨ *ბაზაში დაემატა ახალი პროდუქცია\\!* ✨\n"
            f"📦 სულ დაემატა: {new_count} ახალი პროდუქტი\\.\n"
            "📢 *გთხოვთ, ფასების სხვაობა და დეტალები გუგლ შითში გადაამოწმოთ\\.*"
        )
        send_telegram_message(token, chat_id, message)
    else:
        print("✅ No new products detected")


def upload_to_google_sheets():
    """Upload price comparison data to Google Sheets"""
    
    print("="*60)
    print("GOOGLE SHEETS UPLOADER")
    print("="*60)
    
    # File paths
    credentials_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "credentials.json")
    comparison_file = os.path.join(os.path.dirname(__file__), "reports", "price_comparison_final.xlsx")
    print(f"Credentials file: {credentials_path}")
    print(f"Data file: {comparison_file}")
    
    # Check if files exist
    if not os.path.exists(credentials_path):
        print(f"Error: {credentials_path} not found!")
        return False
    
    if not os.path.exists(comparison_file):
        print(f"Error: {comparison_file} not found!")
        print("Please run the data merger first to generate comparison file.")
        return False
    
    df_old = None
    try:
        # Load the Excel file
        print("Loading price comparison data...")
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

            # Fetch baseline for Telegram comparison via dedicated helper (before clearing)
            print("📊 Fetching baseline data for price change comparison...")
            df_old = fetch_sheet_as_dataframe(worksheet)
            if df_old is None:
                print("ℹ️  Sheet is empty — skipping price comparison for this run.")
            else:
                print(f"📊 Captured {len(df_old)} baseline rows for price change comparison.")

        except gspread.WorksheetNotFound:
            print("Creating new 'Musikis-saxli' tab...")
            worksheet = spreadsheet.add_worksheet(title="Musikis-saxli", rows="1000", cols="20")
            existing_data = []
            print("ℹ️  New sheet — skipping price comparison for this run.")

        # Check current worksheet size and expand if needed
        current_rows = len(existing_data)
        required_rows = len(df) + 1  # +1 for headers
        print(f"Current worksheet has {current_rows} rows, need {required_rows} rows")
        
        if current_rows < required_rows:
            print(f"Expanding worksheet to {required_rows} rows...")
            worksheet.add_rows(required_rows - current_rows)
        
        # Clear existing content
        print("Clearing existing content...")
        worksheet.clear()
        
        # Clear ALL existing data validation rules from columns A to Z
        print("Clearing all existing data validation rules...")
        set_data_validation_for_cell_range(worksheet, 'A2:Z2000', None)
        
        print("Sheet cleared successfully!")
        
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
        
        # Telegram price change alerts
        if df_old is not None:
            print("\n📊 Checking for price changes...")
            df_new = pd.DataFrame(data[1:], columns=client_columns)
            detect_and_alert_price_changes(df_old, df_new, TELEGRAM_TOKEN, CHAT_ID)

        return True
        
    except Exception as e:
        print(f"Error uploading to Google Sheets: {str(e)}")
        return False

def main():
    """Main function"""
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    success = upload_to_google_sheets()
    
    if success:
        print("\n" + "="*60)
        print("UPLOAD COMPLETED SUCCESSFULLY!")
        print("="*60)
    else:
        print("\n" + "="*60)
        print("UPLOAD FAILED!")
        print("="*60)

if __name__ == "__main__":
    main()
