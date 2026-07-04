# Acoustic-Musikis-Saxli (ACMS)

Price comparison pipeline between **Acoustic.ge** and **Musikis-Saxli** (Music House).

## Pipeline

1. `scrapers/acoustic/run_acoustic.py` — scrape Acoustic.ge
2. `scrapers/musikis-saxli/run_musikis_saxli.py` — scrape Musikis-Saxli
3. `acms/acms_data_merger.py` — merge and compare prices
4. `acms/acms_sheet_uploader.py` — upload to Google Sheets + Telegram alerts

## Run

```bash
cd /root/scraping-project
source venv/bin/activate
python acms/acms_main.py
```

## Notes

- Included in the automated `run_scrapers.sh` cycle.
- The orchestrator starts a small Flask health-check server for Render compatibility.
- Blacklist is read from the live sheet before uploading.
