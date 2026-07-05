# Acoustic-Musicroom (ACMR)

Price comparison pipeline between **Acoustic.ge** and **Musicroom.ge**.

## Pipeline

1. `scrapers/acoustic/run_acoustic.py` — scrape Acoustic.ge
2. `scrapers/musicroom/run_musicroom.py` — scrape Musicroom
3. `acmr/acmr_data_merger.py` — merge and compare prices
4. `acmr/acmr_sheet_uploader.py` — upload to Google Sheets + Telegram alerts

## Run

```bash
cd /root/Acoustic-Musicroom
source venv/bin/activate
export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musicroom/pw-browsers
python acmr/acmr_main.py
```

## Notes

- Same architecture as ACGV/ACMI/ACMS.
- Part of the automated `run_scrapers.sh` cycle (Part 4, after Music House). Can also be run manually as above.
