import subprocess
import sys
import os

def run_script(script_path, stage_name, base_dir):
    """Run a Python script and handle errors."""
    print(f"[DEBUG] --- Starting Stage: {stage_name} ---", flush=True)
    print(f"[DEBUG] Script path: {script_path}", flush=True)
    print(f"[DEBUG] Base directory: {base_dir}", flush=True)
    print(f"[DEBUG] Python executable: {sys.executable}", flush=True)
    
    try:
        print(f"[DEBUG] Executing subprocess...", flush=True)
        result = subprocess.run(
            [sys.executable, script_path],
            check=True,
            cwd=base_dir
        )
        
        print(f"[DEBUG] Subprocess completed with exit code: {result.returncode}", flush=True)
        print(f"[DEBUG] --- Completed Stage: {stage_name} ---", flush=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"[DEBUG] ERROR: Stage '{stage_name}' failed with exit code {e.returncode}", flush=True)
        print(f"[DEBUG] STDERR: {e.stderr if e.stderr else 'None'}", flush=True)
        return False
    except Exception as e:
        print(f"[DEBUG] ERROR: Unexpected error in stage '{stage_name}': {e}", flush=True)
        import traceback
        traceback.print_exc()
        return False

def main():
    print("[DEBUG] --- Starting Mireli Data Pipeline Orchestrator ---", flush=True)
    print("=" * 80)
    print("MIRELI DATA PIPELINE ORCHESTRATOR")
    print("=" * 80)
    print()
    
    # Use BASE_DIR for cross-platform compatibility
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    print(f"[DEBUG] Project root: {BASE_DIR}", flush=True)
    print()
    
    # Define the pipeline stages
    stages = [
        ('scrapers/mireli/get_all_page_links.py', 'Collecting Page Links'),
        ('scrapers/mireli/get_all_product_links.py', 'Collecting Product Links'),
        ('scrapers/mireli/mireli_full_scraper.py', 'Scraping Product Data'),
        ('scrapers/mireli/transform.py', 'Cleaning and Transforming Data')
    ]
    
    print(f"[DEBUG] Total stages to execute: {len(stages)}", flush=True)
    
    # Run each stage in order
    for idx, (script_path, stage_name) in enumerate(stages, 1):
        print(f"[DEBUG] --- Starting Stage {idx}/{len(stages)}: {stage_name} ---", flush=True)
        if not run_script(script_path, stage_name, BASE_DIR):
            print()
            print("=" * 80)
            print("PIPELINE FAILED")
            print("=" * 80)
            print(f"Failed at stage: {stage_name}")
            print(f"[DEBUG] Pipeline failed at stage {idx}/{len(stages)}", flush=True)
            sys.exit(1)
        print(f"[DEBUG] Stage {idx}/{len(stages)} completed successfully", flush=True)
        print()
    
    # All stages completed successfully
    print("=" * 80)
    print("PIPELINE COMPLETED SUCCESSFULLY")
    print("=" * 80)
    print()
    print("Final output file: scrapers/mireli/mireli_cleaned_models.xlsx")
    print(f"[DEBUG] All {len(stages)} stages completed successfully", flush=True)
    print()

if __name__ == "__main__":
    main()
