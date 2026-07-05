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

    # --- ნაწილი 1: MUSICROOM & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 1: Musicroom & Acoustic (VENV) ---"
    echo "1. ვიწყებ Musicroom პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Musicroom"
    cd ~/Acoustic-Musicroom || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Musicroom..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib beautifulsoup4
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
    MUSICROOM_EXIT_CODE=$?

    echo "[DEBUG] Musicroom script exit code: $MUSICROOM_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $MUSICROOM_EXIT_CODE -ne 0 ]; then
        echo "CRITICAL: MUSICROOM_UPDATE_FAILED - Exit code: $MUSICROOM_EXIT_CODE"
        echo "Stopping entire pipeline. Will NOT proceed to Geovoice."
        echo "[DEBUG] Script exiting with code 1"
        exit 1
    fi

    echo "[DEBUG] Musicroom completed successfully"
    echo "Musicroom პროექტი დასრულდა."
    echo "----------------------------------------------------------"

    echo "=========================================================="
    echo "--- Musicroom დასრულდა. ვისვენებ 8 საათი... ($(date)) ---"
    echo "[DEBUG] Sleeping for 28800 seconds (8 hours)"
    sleep 28800
    echo "[DEBUG] 8-hour sleep done, starting Geovoice ($(date))"
    echo "=========================================================="

    # --- ნაწილი 2: GEOVOICE & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 2: Geovoice & Acoustic (VENV) ---"
    echo "2. ვიწყებ Geovoice პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Geovoice"
    cd ~/Acoustic-Geovoice || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Geovoice..."
    pip install --upgrade pip
    pip install -r requirements.txt || pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein playwright gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib cloudscraper beautifulsoup4 rapidfuzz
    playwright install chromium

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Geovoice..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Geovoice/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Geovoice/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"
    echo "ვუშვებ Geovoice სკრიპტს..."
    echo "[DEBUG] Executing: python acgv/acgv_main.py"
    python acgv/acgv_main.py
    GEOVOICE_EXIT_CODE=$?

    echo "[DEBUG] Geovoice script exit code: $GEOVOICE_EXIT_CODE"
    echo "გარემოს დეაქტივაცია..."
    echo "[DEBUG] Deactivating virtual environment"
    deactivate

    echo "[DEBUG] Virtual environment deactivated"

    if [ $GEOVOICE_EXIT_CODE -ne 0 ]; then
        echo "CRITICAL: GEOVOICE_UPDATE_FAILED - Exit code: $GEOVOICE_EXIT_CODE"
        echo "Stopping entire pipeline. Will NOT proceed to Mireli."
        echo "[DEBUG] Script exiting with code 1"
        exit 1
    fi

    echo "[DEBUG] Geovoice completed successfully"
    echo "Geovoice პროექტი დასრულდა."
    echo "----------------------------------------------------------"

    echo "=========================================================="
    echo "--- Geovoice დასრულდა. ვისვენებ 8 საათი... ($(date)) ---"
    echo "[DEBUG] Sleeping for 28800 seconds (8 hours)"
    sleep 28800
    echo "[DEBUG] 8-hour sleep done, starting Mireli ($(date))"
    echo "=========================================================="

    # --- ნაწილი 3: ACOUSTIC MIRELI (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 3: Acoustic Mireli (VENV) ---"
    echo "3. ვიწყებ Mireli-ს პროექტს (VENV)..."
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

    echo "=========================================================="
    echo "--- Mireli დასრულდა. ვისვენებ 8 საათი... ($(date)) ---"
    echo "[DEBUG] Sleeping for 28800 seconds (8 hours)"
    sleep 28800
    echo "[DEBUG] 8-hour sleep done, starting Music House ($(date))"
    echo "=========================================================="

    # --- ნაწილი 4: MUSIC HOUSE & ACOUSTIC (PYTHON VENV) ---
    echo "[DEBUG] --- Starting Part 4: Music House & Acoustic (VENV) ---"
    echo "4. ვიწყებ Music House პროექტს (VENV)..."
    echo "[DEBUG] Changing directory to ~/Acoustic-Musikissaxli"
    cd ~/Acoustic-Musikissaxli || exit

    echo "[DEBUG] Current directory: $(pwd)"
    echo "ვირტუალური გარემოს აქტივაცია..."
    echo "[DEBUG] Activating virtual environment: venv/bin/activate"
    source venv/bin/activate

    echo "Auto-insuring dependencies for Music House..."
    pip install --upgrade pip
    pip install pandas openpyxl requests fuzzywuzzy python-Levenshtein gspread gspread-formatting google-api-python-client google-auth-httplib2 google-auth-oauthlib flask playwright
    pip install playwright
    playwright install chromium

    echo "[DEBUG] Virtual environment activated"
    echo "[DEBUG] Python version: $(python --version)"
    echo "[DEBUG] Python path: $(which python)"

    echo "Setting Playwright browsers path for Music House..."
    echo "[DEBUG] Setting PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musikissaxli/pw-browsers"
    export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musikissaxli/pw-browsers

    echo "[DEBUG] PLAYWRIGHT_BROWSERS_PATH set to: $PLAYWRIGHT_BROWSERS_PATH"

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
    echo "--- Music House დასრულდა. ვისვენებ 8 საათი... ($(date)) ---"
    echo "[DEBUG] Sleeping for 28800 seconds (8 hours)"
    sleep 28800
    echo "[DEBUG] 8-hour sleep done, starting next cycle ($(date))"
    cd ~
    echo "[DEBUG] Changed directory to: $(pwd)"
done
