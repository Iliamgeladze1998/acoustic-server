import subprocess
import sys
import os
import pandas as pd
from pathlib import Path

def run_script(script_name):
    """Run a Python script in the same directory"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(script_dir, script_name)
    
    try:
        result = subprocess.run([sys.executable, script_path], 
                                cwd=script_dir)
        
        if result.returncode == 0:
            print(f"SUCCESS: {script_name} completed", flush=True)
            return True
        else:
            print(f"ERROR: {script_name} failed with exit code {result.returncode}", flush=True)
            return False
            
    except Exception as e:
        print(f"ERROR: Could not run {script_name}: {e}", flush=True)
        return False

def check_file_exists(file_path, step_name, check_empty=False):
    """Check if a required input file exists before running a step"""
    if not os.path.exists(file_path):
        print(f"ERROR: Required file not found for {step_name}: {file_path}", flush=True)
        return False
    
    if check_empty:
        if os.path.getsize(file_path) == 0:
            print(f"ERROR: Required file is empty for {step_name}: {file_path}", flush=True)
            return False
    
    return True

def run_musicroom_master():
    """Master controller for Musicroom scraping process"""
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    print("="*60, flush=True)
    print("MUSICOOM SCRAPING MASTER CONTROLLER", flush=True)
    print("="*60, flush=True)
    
    # Step 1: Fetch initial categories
    print("\nStep 1: Fetching initial categories...", flush=True)
    print("-" * 40, flush=True)
    
    if not run_script("get_links.py"):
        print("Failed to fetch categories. Aborting process.", flush=True)
        return False
    
    # Verify output from step 1
    category_file = os.path.join(script_dir, "get_main_category_links.txt")
    if not check_file_exists(category_file, "Step 1"):
        return False
    
    # Step 2: Handle pagination
    print("\nStep 2: Handling pagination...", flush=True)
    print("-" * 40, flush=True)
    
    if not run_script("get_all_page_links.py"):
        print("Pagination failed. Aborting process.", flush=True)
        return False
    
    # Verify output from step 2
    pages_file = os.path.join(script_dir, "all_category_pages.txt")
    if not check_file_exists(pages_file, "Step 2"):
        return False
    
    # Step 3: Collect all product URLs
    print("\nStep 3: Collecting all product URLs...", flush=True)
    print("-" * 40, flush=True)
    
    if not run_script("get_all_product_links.py"):
        print("Product URL collection failed. Aborting process.", flush=True)
        return False
    
    # Verify output from step 3 (check not empty)
    product_links_file = os.path.join(script_dir, "all_product_links.txt")
    if not check_file_exists(product_links_file, "Step 3", check_empty=True):
        return False
    
    # Step 4: Scrape all product data
    print("\nStep 4: Scraping all product data...", flush=True)
    print("-" * 40, flush=True)
    
    if not run_script("musicroom_scraper.py"):
        print("Product data scraping failed. Aborting process.", flush=True)
        return False
    
    # Verify output from step 4
    results_file = os.path.join(script_dir, "musicroom_results.xlsx")
    if not check_file_exists(results_file, "Step 4"):
        return False
    
    # Step 5: Transform data for merging
    print("\nStep 5: Transforming data for merging...", flush=True)
    print("-" * 40, flush=True)
    
    if not run_script("transform.py"):
        print("Data transformation failed. Aborting process.", flush=True)
        return False
    
    # Final summary
    print("\n" + "="*60, flush=True)
    print("ENTIRE PROCESS COMPLETED SUCCESSFULLY!", flush=True)
    print("="*60, flush=True)
    
    # Get final file path and product count
    script_dir = os.path.dirname(os.path.abspath(__file__))
    final_file = os.path.join(script_dir, "musicroom_cleaned.xlsx")
    
    try:
        df = pd.read_excel(final_file)
        product_count = len(df)
        print(f"\n📊 FINAL SUMMARY:", flush=True)
        print(f"   Total Products Processed: {product_count}", flush=True)
        print(f"   Final File Location: {final_file}", flush=True)
        print(f"   Columns: {list(df.columns)}", flush=True)
    except Exception as e:
        print(f"\n⚠ Could not read final file for summary: {e}", flush=True)
        print(f"   Final File Location: {final_file}", flush=True)
    
    return True

if __name__ == "__main__":
    success = run_musicroom_master()
    if not success:
        print("\nProcess failed. Check the error messages above.", flush=True)
        sys.exit(1)
    else:
        print("\nProcess completed successfully!", flush=True)