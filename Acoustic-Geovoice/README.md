# Acoustic-Geovoice (ACGV)

Price comparison pipeline between **Acoustic.ge** and **Geovoice.ge**.

## Pipeline

1. `scrapers/acoustic/run_acoustic.py` — scrape Acoustic.ge
2. `scrapers/geovoice/run_geovoice.py` — scrape Geovoice.ge
3. `acgv/acgv_data_merger.py` — merge and compare prices
4. `acgv/acgv_sheet_uploader.py` — upload to Google Sheets + Telegram alerts

## Run

```bash
cd /root/Acoustic-Geovoice
source venv/bin/activate
export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Geovoice/pw-browsers
python acgv/acgv_main.py
```

## Notes

- Part of the automated `start_all_scrapers.sh` parallel pipeline (screen session: `scraper-geovoice`).
- Uses a 24-hour freshness guard before uploading.
