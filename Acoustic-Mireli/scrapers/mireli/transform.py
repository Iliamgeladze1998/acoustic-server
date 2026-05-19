import pandas as pd
import re
import os

def clean_georgian_text(text):
    """Remove Georgian characters and clean up the text."""
    if pd.isna(text):
        return text
    
    # Remove Georgian Unicode range
    text = re.sub(r'[\u10A0-\u10FF]+', '', text)
    
    # Remove leading/trailing dashes (both en-dash – and hyphen -)
    text = re.sub(r'^[\s–-]+|[\s–-]+$', '', text)
    
    # Clean up extra whitespaces
    text = re.sub(r'\s+', ' ', text).strip()
    
    return text

def main():
    # Use BASE_DIR for cross-platform compatibility
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    input_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_final_stock.xlsx')
    output_file = os.path.join(BASE_DIR, 'scrapers', 'mireli', 'mireli_cleaned_models.xlsx')
    
    try:
        # Read the Excel file
        df = pd.read_excel(input_file, engine='openpyxl')
        print(f"Loaded {len(df)} rows from {input_file}")
        
        # Clean the NAME column
        print("Cleaning NAME column...")
        df['NAME'] = df['NAME'].apply(clean_georgian_text)
        
        # Save the cleaned DataFrame
        df.to_excel(output_file, index=False, engine='openpyxl')
        print(f"Successfully saved cleaned data to {output_file}")
        
        # Show some examples
        print("\nExample cleaned names:")
        for idx, name in enumerate(df['NAME'].head(5), 1):
            print(f"{idx}. {name}")
            
    except FileNotFoundError:
        print(f"Error: {input_file} not found. Please run mireli_full_scraper.py first.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
