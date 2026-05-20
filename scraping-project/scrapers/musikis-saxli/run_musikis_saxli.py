#!/usr/bin/env python3
"""
Music Store Scraper Pipeline Orchestrator
Runs the complete scraping pipeline sequentially:
1. get_links.py - Extract category links
2. get_all_product_links.py - Extract product links from categories
3. musikis_scraper.py - Scrape product details
"""

import subprocess
import sys
import os
import io
from datetime import datetime

# Fix Windows console encoding for Unicode (Georgian characters)
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

def run_script(script_name, description):
    """Run a Python script and handle errors with real-time output"""
    print(f"\n{'='*60}", flush=True)
    print(f"STAGE: {description}", flush=True)
    print(f"Running: {script_name}", flush=True)
    print(f"{'='*60}", flush=True)
    
    try:
        # Use the same Python interpreter as current script
        # Get the directory of the run script and join with script name
        script_dir = os.path.dirname(os.path.abspath(__file__))
        script_path = os.path.join(script_dir, script_name)
        
        # Set environment variables for unbuffered output
        env = os.environ.copy()
        env["PYTHONUNBUFFERED"] = "1"
        
        # Use Popen with binary mode, then wrap with TextIOWrapper
        # errors='replace' ensures Georgian chars become '?' instead of crashing
        process = subprocess.Popen(
            [sys.executable, '-u', script_path],
            cwd=script_dir,
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            bufsize=1
        )
        
        # Wrap stdout with TextIOWrapper for proper encoding handling
        text_stream = io.TextIOWrapper(
            process.stdout,
            encoding='utf-8',
            errors='replace',
            line_buffering=True
        )
        
        # Read output line by line
        while True:
            try:
                line = text_stream.readline()
                if not line:
                    break
                try:
                    print(line, end='', flush=True)
                except Exception:
                    pass  # Skip print errors
            except Exception:
                continue  # Skip read errors
            
        # Wait for process to complete
        process.wait(timeout=3600)  # 1 hour timeout
        
        if process.returncode == 0:
            print(f"✅ SUCCESS: {script_name} completed", flush=True)
            return True
        else:
            print(f"❌ ERROR: {script_name} failed with exit code {process.returncode}", flush=True)
            return False
            
    except subprocess.TimeoutExpired:
        print(f"⏰ TIMEOUT: {script_name} timed out after 1 hour", flush=True)
        process.kill()
        return False
    except Exception as e:
        print(f"❌ EXCEPTION: {script_name} failed - {e}", flush=True)
        return False

def main():
    """Main pipeline orchestrator - always runs all 4 stages"""
    print(f"\n🚀 MUSIC STORE SCRAPER PIPELINE - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", flush=True)
    print("Stage 1: Extract category links", flush=True)
    print("Stage 2: Extract product links from categories", flush=True) 
    print("Stage 3: Scrape product details", flush=True)
    print("Stage 4: Clean and transform data", flush=True)
    print("", flush=True)
    
    scripts = [
        ("get_links.py", "Extract category links from Music Store"),
        ("get_all_product_links.py", "Extract product links from categories"),
        ("musikis_scraper.py", "Scrape product details and save to Excel"),
        ("transform.py", "Clean and transform scraped data")
    ]
    
    # Run pipeline sequentially
    success_count = 0
    total_stages = len(scripts)
    
    for i, (script_name, description) in enumerate(scripts, 1):
        print(f"\n📍 PIPELINE STAGE {i}/{total_stages}", flush=True)
        
        if run_script(script_name, description):
            success_count += 1
        else:
            print(f"\n⚠️  STAGE FAILED: {script_name} - continuing to next stage...", flush=True)
    
    # Final summary
    print(f"\n{'='*80}", flush=True)
    print(f"🏁 PIPELINE COMPLETE - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", flush=True)
    print(f"✅ Stages completed: {success_count}/{total_stages}", flush=True)
    
    if success_count == total_stages:
        print("All stages successful!", flush=True)
        print("Check music_store_final_stock.xlsx for scraped data", flush=True)
        print("Check final_stock_cleaned.xlsx for transformed data", flush=True)
    else:
        print("⚠️  Some stages failed - check logs above", flush=True)
    
    print(f"{'='*80}", flush=True)
    return success_count == total_stages

if __name__ == "__main__":
    main()
    sys.exit(0)  # Always exit 0 - crash-proof
