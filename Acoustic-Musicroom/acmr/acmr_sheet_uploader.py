#!/usr/bin/env python3
"""
ACMR Sheet Uploader
Uploads merged report data to Google Sheets using google-auth
Features: Blacklist filtering, Feedback dropdown, Yellow background, Georgia timestamp
"""

import os
import json
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
    except requests.exceptions.RequestException as e:
        print(f"   \u26a0\ufe0f  Failed to send Telegram message: {e}")


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


def detect_and_alert_price_changes(df_old, df_new, token, chat_id):
    """Compare old and new DataFrames by product ID and send Telegram alerts for price changes."""
    id_col = 'product_name_ac'
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
        print("\u26a0\ufe0f  No price columns found for comparison, skipping alerts")
        return

    df_old_indexed = df_old.set_index(id_col)
    changes_found = 0

    for _, new_row in df_new.iterrows():
        product_id = str(new_row.get(id_col, '')).strip()
        if not product_id or product_id not in df_old_indexed.index:
            continue

        old_row = df_old_indexed.loc[product_id]
        if isinstance(old_row, pd.DataFrame):
            old_row = old_row.iloc[0]

        for price_col in price_cols:
            old_val = str(old_row.get(price_col, '')).strip()
            new_val = str(new_row.get(price_col, '')).strip()

            old_val = '' if old_val in ('', 'nan', 'None', '-', 'N/A') else old_val
            new_val = '' if new_val in ('', 'nan', 'None', '-', 'N/A') else new_val

            if old_val == new_val:
                continue

            product_name = str(new_row.get(name_col, product_id)) if name_col else product_id
            store_name = STORE_NAMES.get(price_col, price_col)
            old_display = old_val if old_val else 'N/A'
            new_display = new_val if new_val else 'N/A'

            links_lines = ''
            for lc in link_cols:
                link_val = str(new_row.get(lc, '')).strip()
                if link_val and link_val not in ('nan', 'None', ''):
                    links_lines += f'\n  \\- {escape_md(lc)}: {escape_md(link_val)}'
            if not links_lines:
                links_lines = '\n  \\- N/A'

            message = (
                "🚨 *ფასის ცვლილება დეტექტირებულია\\!* 🚨\n"
                f"📦 *პროდუქტი:* {escape_md(product_name)}\n"
                f"🏪 *მაღაზია:* {escape_md(store_name)}\n"
                f"💰 *ცვლილება:* {escape_md(old_display)} ₾ ➡️ {escape_md(new_display)} ₾\n"
                f"🔗 *ბმულები:*{links_lines}"
            )

            send_telegram_message(token, chat_id, message)
            changes_found += 1

    if changes_found == 0:
        print("✅ No price changes detected")
    else:
        print(f"📨 Sent {changes_found} Telegram alert(s) for price changes")

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
    if not os.path.exists(excel_path):
        print(f"❌ Excel file not found: {excel_path}")
        return False
    
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
    
    # STEP 7: Clear and upload
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

        # Clear the worksheet
        worksheet.clear()
        
        # Convert DataFrame to list of lists
        data = [df.columns.tolist()] + df.values.tolist()
        
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

    # STEP 8: Telegram price change alerts
    if df_old is not None:
        print("\n📊 Checking for price changes...")
        detect_and_alert_price_changes(df_old, df, TELEGRAM_TOKEN, CHAT_ID)

    return True

if __name__ == "__main__":
    success = main()
    if not success:
        print("\n❌ Upload failed!")
