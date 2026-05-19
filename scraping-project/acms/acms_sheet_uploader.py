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
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from gspread_formatting import set_data_validation_for_cell_range, DataValidationRule, BooleanCondition, CellFormat, Color, TextFormat, format_cell_range, conditionalFormatRule, BooleanRule, get_conditional_format_rules, GridRange, Border, Borders

# Force UTF-8 output to handle Georgian text
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

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
    
    try:
        # Load the Excel file
        print("Loading price comparison data...")
        df = pd.read_excel(comparison_file)
        df = df.fillna('')  # Replace NaN values with empty strings for JSON serialization
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
            
        except gspread.WorksheetNotFound:
            print("Creating new 'Musikis-saxli' tab...")
            worksheet = spreadsheet.add_worksheet(title="Musikis-saxli", rows="1000", cols="20")
            existing_data = []
        
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
                # Handle None values and ensure proper encoding
                if pd.isna(value) or not value:
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
                
                # Apply validation to all rows starting from row 2 (skip header)
                for i in range(1, min(len(all_values), len(data))):
                    if i < len(all_values):
                        row_values = all_values[i]
                        # Ensure row has enough columns
                        while len(row_values) <= max(o_col_index, feedback_col_index if feedback_col_index is not None else 0):
                            row_values.append("")
                        
                        # Add update timestamp to O column
                        row_values[o_col_index] = timestamp
                        
                        # Keep existing feedback value (don't overwrite with text)
                        # The dropdown will show the current value
                        
                        # Update specific row with proper range
                        col_letter_o = chr(ord("A") + o_col_index)
                        end_col = max(o_col_index, feedback_col_index if feedback_col_index is not None else 0) + 1
                        row_range = f'A{i+1}:{chr(ord("A") + end_col - 1)}{i+1}'
                        
                        worksheet.update(values=[row_values], range_name=row_range)
                
                print(f"Updated {min(len(all_values)-1, len(data))} rows with timestamp in O column")
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
