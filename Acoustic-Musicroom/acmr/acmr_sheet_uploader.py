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
import gspread
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
from gspread_formatting import CellFormat, Color, TextFormat, format_cell_range, conditionalFormatRule, BooleanRule, BooleanCondition, get_conditional_format_rules, GridRange, Border, Borders

# Configuration
SPREADSHEET_ID = "1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
TAB_NAME = "Musicroom"
FEEDBACK_OPTIONS = ['Correct', 'Needs Review', 'Wrong']

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
    try:
        if worksheet is None:
            worksheet = spreadsheet.add_worksheet(title=TAB_NAME, rows="1000", cols="20")
            print(f"✅ Created new tab '{TAB_NAME}'")
        
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
    return True

if __name__ == "__main__":
    success = main()
    if not success:
        print("\n❌ Upload failed!")
