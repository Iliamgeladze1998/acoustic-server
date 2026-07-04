# Acoustic-Mireli (ACMI)

Price comparison pipeline between **Acoustic.ge** and **Mireli.ge**.

## Pipeline

1. `scrapers/acoustic/run_acoustic.py` — scrape Acoustic.ge
2. `scrapers/mireli/run_mireli.py` — scrape Mireli
3. `acmi/acmi_data_merger.py` — merge and compare prices
4. `acmi/acmi_sheet_uploader.py` — upload to Google Sheets + Telegram alerts

## Run

```bash
cd /root/Acoustic-Mireli
source venv/bin/activate
export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Mireli/pw-browsers
python acmi/acmi_main.py
```

## Notes

- Included in the automated `run_scrapers.sh` cycle.
- Mireli links may contain Georgian characters; the uploader encodes them for Google Sheets compatibility.
