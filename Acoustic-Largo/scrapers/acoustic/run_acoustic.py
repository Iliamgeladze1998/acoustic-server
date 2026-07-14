import subprocess
import sys
import os

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

def run_acoustic_master():
    """Master controller for acoustic scraping process"""
    
    print("="*60, flush=True)
    print("ACOUSTIC SCRAPING MASTER CONTROLLER", flush=True)
    print("="*60, flush=True)
    
    print("\nStep 1: Starting full scrape...", flush=True)
    print("-" * 40, flush=True)
    
    # Step 1: Run full scraper
    if not run_script("acoustic_full_scraper.py"):
        print("Full scrape failed.", flush=True)
        return False
    
    print("\nStep 2: Running data transformation...", flush=True)
    print("-" * 40, flush=True)
    
    # Step 2: Run transformation
    if not run_script("transform.py"):
        print("Data transformation failed.", flush=True)
        return False
    
    print("\n" + "="*60, flush=True)
    print("ENTIRE PROCESS COMPLETED SUCCESSFULLY!", flush=True)
    print("="*60, flush=True)
    return True

if __name__ == "__main__":
    success = run_acoustic_master()
    if not success:
        print("\nProcess failed. Check the error messages above.", flush=True)
        sys.exit(1)
    else:
        print("\nProcess completed successfully!", flush=True)