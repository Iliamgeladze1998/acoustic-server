#!/bin/bash

echo "[DEBUG] Starting run_scrapers.sh script"
echo "[DEBUG] Current directory: $(pwd)"
echo "[DEBUG] Current user: $(whoami)"
echo "[DEBUG] Current time: $(date)"

# უსასრულო ციკლი
while true; do
    echo "=========================================================="
    echo "--- ახალი სრული ციკლის დასაწყისი: $(date) ---"
    echo "=========================================================="

    # --- ნაწილი 1: ACOUSTIC MUSICOOM (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 1: Acoustic Musicroom (VENV) ---"
    echo "1. ვიწყებ Musicroom-ს პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Musicroom"
    cd ~/Acoustic-Musicroom || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Musicroom..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib
    pip install gspread-formatting
    playwright install chromium

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Musicroom..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musicroom/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musicroom/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"
    echo "ვუშვებ Musicroom სკრიპტს..."
    echo "[DEBUG] Executing: python acmr/acmr_main.py"
    python acmr/acmr_main.py
    MUSICOOM_EXIT_CODE=$?

    echo "[DEBUG] Musicroom script exit code: $MUSICOOM_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $MUSICOOM_EXIT_CODE -ne 0 ]; then
        echo "CRITICAL: MUSICOOM_UPDATE_FAILED - Exit code: $MUSICOOM_EXIT_CODE"
        echo "Stopping entire pipeline. Will NOT proceed to next cycle."
        echo "[DEBUG] Script exiting with code 1"
        exit 1
    fi

    echo "[DEBUG] Musicroom completed successfully"
    echo "Musicroom პროექტი დასრულდა."
    echo "----------------------------------------------------------"

    # --- ნაწილი 2: ACOUSTIC MIRELI (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 2: Acoustic Mireli (VENV) ---"
    echo "2. ვიწყებ Mireli-ს პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Mireli"
    cd ~/Acoustic-Mireli || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    # აქტივაცია უზრუნველყოფს, რომ ყველა ქვე-სკრიპტმა დაინახოს Playwright
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Mireli..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib
    pip install gspread-formatting
    playwright install chromium

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Mireli..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Mireli/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Mireli/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"
    echo "ვუშვებ Mireli სკრიპტს..."
    echo "[DEBUG] Executing: python acmi/acmi_main.py"
    python acmi/acmi_main.py
    MIRELI_EXIT_CODE=$?

    echo "[DEBUG] Mireli script exit code: $MIRELI_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $MIRELI_EXIT_CODE -ne 0 ]; then
        echo "CRITICAL: MIRELI_UPDATE_FAILED - Exit code: $MIRELI_EXIT_CODE"
        echo "Stopping entire pipeline. Will NOT proceed to Music House."
        echo "[DEBUG] Script exiting with code 1"
        exit 1
    fi

    echo "[DEBUG] Mireli completed successfully"
    echo "Mireli პროექტი დასრულდა."
    echo "----------------------------------------------------------"

    # --- ნაწილი 3: MUSIC HOUSE & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 3: Music House & Acoustic (VENV) ---"
    echo "3. ვიწყებ Music House პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/scraping-project"
    cd ~/scraping-project || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Music House..."
    pip install --upgrade pip
    pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib flask

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "ვუშვებ Music House სკრიპტს..."
    echo "[DEBUG] Executing: python acms/acms_main.py"
    python acms/acms_main.py
    MUSIC_HOUSE_EXIT_CODE=$?

    echo "[DEBUG] Music House script exit code: $MUSIC_HOUSE_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $MUSIC_HOUSE_EXIT_CODE -ne 0 ]; then
        echo "CRITICAL: MUSIC_HOUSE_UPDATE_FAILED - Exit code: $MUSIC_HOUSE_EXIT_CODE"
        echo "Stopping entire pipeline. Will NOT proceed to next cycle."
        echo "[DEBUG] Script exiting with code 1"
        exit 1
    fi

    echo "[DEBUG] Music House completed successfully"
    echo "Music House პროექტი დასრულდა."
    echo "----------------------------------------------------------"

    echo "=========================================================="
    echo "--- ციკლი მორჩა. ვისვენებ 10 წუთი... ---"
    echo "[DEBUG] Sleeping for 600 seconds (10 minutes)"

    sleep 600
    echo "[DEBUG] Sleep completed, starting next cycle"
    cd ~
    echo "[DEBUG] Changed directory to: $(pwd)"
done
