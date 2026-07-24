# Acoustic Server — Automated Price Comparison System

An automated scraping and price comparison platform that monitors **7 music instrument stores** in Georgia. The system scrapes product data (prices, stock availability, SKUs) from each store, compares them against the baseline (Acoustic), and uploads results to Google Sheets with real-time Telegram alerts for price changes and promotions.

## Overview

The system tracks **Acoustic** (baseline store) against **6 competitors**:

| # | Project | Competitor Store | Directory | Orchestrator |
|---|---------|-----------------|-----------|--------------|
| 1 | ACLG | Largo | `Acoustic-Largo` | `aclg/aclg_main.py` |
| 2 | ACJM | JinoMusic | `Acoustic-JinoMusic` | `acjm/acjm_main.py` |
| 3 | ACMS | Musikis-Saxli (Music House) | `Acoustic-Musikissaxli` | `acms/acms_main.py` |
| 4 | ACMR | Musicroom | `Acoustic-Musicroom` | `acmr/acmr_main.py` |
| 5 | ACGV | Geovoice | `Acoustic-Geovoice` | `acgv/acgv_main.py` |
| 6 | ACMI | Mireli | `Acoustic-Mireli` | `acmi/acmi_main.py` |

Each project is an independent pipeline that runs in its own `screen` session, looping every 8 hours:

```
Scraper (Acoustic + Competitor) → Fresh Excel → Data Merger → Merged Excel → Google Sheets Uploader → Telegram Alerts
```

## Project Structure

```
/root/
├── Acoustic-Largo/                # ACLG — Acoustic vs Largo
│   ├── aclg/
│   │   ├── aclg_main.py           # Pipeline orchestrator
│   │   ├── aclg_data_merger.py    # Fuzzy match & price comparison
│   │   └── aclg_sheet_uploader.py # Google Sheets upload + Telegram alerts
│   ├── scrapers/
│   │   ├── acoustic/              # Acoustic store scraper
│   │   └── largo/                 # Largo store scraper
│   ├── reports/                   # Generated Excel reports
│   ├── credentials.json           # Google Sheets API credentials
│   └── requirements.txt
│
├── Acoustic-JinoMusic/            # ACJM — Acoustic vs JinoMusic
│   ├── acjm/
│   │   ├── acjm_main.py
│   │   ├── acjm_data_merger.py
│   │   └── acjm_sheet_uploader.py
│   ├── scrapers/
│   │   ├── acoustic/
│   │   └── jinomusic/
│   ├── reports/
│   ├── credentials.json
│   └── requirements.txt
│
├── Acoustic-Musikissaxli/         # ACMS — Acoustic vs Musikis-Saxli
│   ├── acms/
│   │   ├── acms_main.py
│   │   ├── acms_data_merger.py
│   │   ├── acms_sheet_uploader.py
│   │   └── cleaners.py            # Data cleaning utilities
│   ├── scrapers/
│   │   ├── acoustic/
│   │   └── musikis-saxli/
│   ├── reports/
│   ├── credentials.json
│   └── requirements.txt
│
├── Acoustic-Musicroom/            # ACMR — Acoustic vs Musicroom
│   ├── acmr/
│   │   ├── acmr_main.py
│   │   ├── acmr_data_merger.py
│   │   └── acmr_sheet_uploader.py
│   ├── scrapers/
│   │   ├── acoustic/
│   │   └── musicroom/
│   ├── reports/
│   ├── credentials.json
│   └── requirements.txt
│
├── Acoustic-Geovoice/             # ACGV — Acoustic vs Geovoice
│   ├── acgv/
│   │   ├── acgv_main.py
│   │   ├── acgv_data_merger.py
│   │   └── acgv_sheet_uploader.py
│   ├── scrapers/
│   │   ├── acoustic/
│   │   └── geovoice/
│   ├── reports/
│   ├── credentials.json
│   └── requirements.txt
│
├── Acoustic-Mireli/               # ACMI — Acoustic vs Mireli
│   ├── acmi/
│   │   ├── acmi_main.py
│   │   ├── acmi_data_merger.py
│   │   └── acmi_sheet_uploader.py
│   ├── scrapers/
│   │   ├── acoustic/
│   │   └── mireli/
│   ├── reports/
│   ├── credentials.json
│   └── requirements.txt
│
├── start_all_scrapers.sh          # Start all 6 scrapers in parallel (screen sessions)
├── stop_all_scrapers.sh           # Stop all scrapers and clean up processes
├── run_single_scraper.sh          # Single-scraper loop (used by start_all_scrapers.sh)
└── scraper_logs/                  # Per-scraper log files
```

## Quick Start

### Prerequisites

- Python 3.8+
- `venv` virtual environment per project
- Google Sheets API service account credentials (`credentials.json`)
- Telegram bot token and chat ID
- Playwright (Chromium) and/or Camoufox browsers (per project)

### Start All Scrapers

All 6 scrapers run in parallel, each in its own `screen` session with an 8-hour loop:

```bash
bash /root/start_all_scrapers.sh
```

This creates 6 screen sessions: `scraper-largo`, `scraper-jinomusic`, `scraper-musichouse`, `scraper-musicroom`, `scraper-geovoice`, `scraper-mireli`.

### Stop All Scrapers

```bash
bash /root/stop_all_scrapers.sh
```

### Run a Single Scraper

```bash
bash /root/run_single_scraper.sh largo
```

Available names: `largo`, `jinomusic`, `musichouse`, `musicroom`, `geovoice`, `mireli`

### Managing Screen Sessions

```bash
# List active sessions
screen -ls

# Attach to a specific scraper
screen -r scraper-largo

# Detach (return to shell without stopping)
Ctrl+A then D
```

### Viewing Logs

```bash
# All logs are in /root/scraper_logs/
tail -f /root/scraper_logs/largo.log
tail -f /root/scraper_logs/geovoice.log
```

## Architecture

### Per-Project Pipeline

Each project follows the same 4-stage pipeline, orchestrated by its `*_main.py`:

1. **Scrapers** — Collect product data from Acoustic and the competitor store
2. **Data Merger** — Fuzzy-match products by name/brand/SKU and compute price differences
3. **Sheet Uploader** — Upload merged comparison to Google Sheets
4. **Telegram Alerts** — Notify on significant price changes, stock changes, and promotions

### Parallel Execution Model

All 6 scrapers run simultaneously in independent `screen` sessions. Each scraper:

- Runs its full pipeline (scrape → merge → upload)
- Sleeps 8 hours
- Repeats automatically

Startup is **staggered** to avoid browser launch conflicts:

| Scraper | Startup Delay | Browser Engine |
|---------|--------------|----------------|
| Largo | 0s | Requests / BeautifulSoup |
| Music House | 10s | Playwright (Chromium) |
| Geovoice | 20s | Playwright (Chromium) + Cloudscraper |
| JinoMusic | 30s | Camoufox (Firefox) + Tor |
| Mireli | 40s | Playwright (Chromium) |
| Musicroom | 60s | Camoufox (Firefox) + Playwright |

### Data Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                     start_all_scrapers.sh                        │
│           Creates 6 independent screen sessions                  │
└──────────────────────────┬───────────────────────────────────────┘
                           │
        ┌────────┬─────────┼─────────┬──────────┬────────┐
        ▼        ▼         ▼         ▼          ▼        ▼
   ┌────────┐┌────────┐┌────────┐┌──────────┐┌────────┐┌────────┐
   │ ACLG   ││ ACJM   ││ ACMS   ││ ACMR     ││ ACGV   ││ ACMI   │
   │ Largo  ││ JinoMu ││ Music  ││ Musicrm  ││ Geovoi ││ Mireli │
   └───┬────┘└───┬────┘└───┬────┘└────┬─────┘└───┬────┘└───┬────┘
       │         │         │          │          │         │
       ▼         ▼         ▼          ▼          ▼         ▼
  ┌─────────────────────────────────────────────────────────────┐
  │                    1. SCRAPERS                              │
  │  • Acoustic scraper → acoustic_final_stock.xlsx             │
  │  • Competitor scraper → competitor_final_stock.xlsx         │
  │  • Clean start: stale files deleted before each run         │
  └────────────────────────┬────────────────────────────────────┘
                           │
                           ▼
  ┌─────────────────────────────────────────────────────────────┐
  │                 2. DATA MERGER                              │
  │  • Fuzzy product matching (Levenshtein / RapidFuzz)         │
  │  • Brand & category alignment                              │
  │  • Price difference calculation                            │
  │  • Stock availability comparison                           │
  │  • Output: reports/<acoustic_vs_competitor>.xlsx            │
  └────────────────────────┬────────────────────────────────────┘
                           │
                           ▼
  ┌─────────────────────────────────────────────────────────────┐
  │              3. SHEET UPLOADER (Guarded)                    │
  │  • 24-hour freshness guard on merged Excel                  │
  │  • Read current Google Sheet state (df_old)                 │
  │  • Compare with fresh merged Excel (df_new)                 │
  │  • Detect price changes, stock changes, new products        │
  │  • Send Telegram alerts BEFORE updating sheet               │
  │  • Update Google Sheet (only after alerts sent)             │
  └─────────────────────────────────────────────────────────────┘
                           │
                           ▼
              Sleep 8h → Repeat
```

## Component Details

### 1. Scrapers

Each project has two scrapers:

- **Acoustic scraper** — Scrapes `acoustic.ge` (via JSON API: `https://acoustic.ge/data/products.json`)
- **Competitor scraper** — Scrapes the competitor website using the appropriate browser engine

**Scraping technologies by project:**

| Project | Acoustic Source | Competitor Engine |
|---------|----------------|-------------------|
| ACLG (Largo) | JSON API | Requests + BeautifulSoup |
| ACJM (JinoMusic) | JSON API | Camoufox (Firefox) + Tor |
| ACMS (Music House) | JSON API | Playwright (Chromium) |
| ACMR (Musicroom) | JSON API | Camoufox (Firefox) + Playwright |
| ACGV (Geovoice) | JSON API | Playwright (Chromium) + Cloudscraper |
| ACMI (Mireli) | JSON API | Playwright (Chromium) |

**Data fields collected:**

- Product name
- SKU (unique product code)
- Price (in GEL)
- Stock availability (quantity, 0 if out of stock)
- Product URL

### 2. Data Merger

Merges Acoustic and competitor data into a price comparison report:

- **Fuzzy matching** — Products matched by name similarity (Levenshtein distance / RapidFuzz)
- **Brand & category alignment** — Secondary matching criteria
- **Price difference** — Absolute and percentage difference per matched product
- **Stock comparison** — Side-by-side availability status
- **Clean output** — Previous merged report deleted before each run

### 3. Sheet Uploader

Uploads merged data to Google Sheets with safety guards:

- **24-hour freshness guard** — Aborts if merged Excel is older than 24 hours
- **Dual-source comparison** — Reads live Google Sheet (`df_old`) vs. fresh Excel (`df_new`)
- **Alert-before-update** — Sends Telegram alerts for price changes BEFORE modifying the sheet
- **Price change detection** — Identifies significant price drops, increases, and promotions
- **Atomic update** — Sheet cleared and rewritten only after alerts are successfully sent
- **Automatic formatting** — Color-coded price differences and status indicators

### 4. Telegram Alerts

Real-time notifications sent to a configured Telegram chat:

- Price drops (competitor sales/promotions detected)
- Price increases
- Stock status changes (in stock → out of stock, and vice versa)
- New product matches found
- Scraping or upload failures

## Data Freshness Guarantees

| Layer | Protection |
|-------|-----------|
| Scraper | Clean start — stale output files deleted before each run |
| Scraper | Empty result detection — aborts if no products found |
| Merger | Previous report deleted before processing |
| Merger | Only processes fresh scraper outputs (no cache) |
| Uploader | 24-hour freshness guard on merged Excel |
| Uploader | Live sheet read before any modification |
| Orchestrator | Stage validation — pipeline stops on any failure |
| Orchestrator | Exit code propagation — no silent failures |

## Configuration

### Google Sheets API

Each project contains a `credentials.json` file with a Google Cloud service account. Setup:

1. Create a Google Cloud Project
2. Enable the Google Sheets API
3. Create a service account and download the JSON key
4. Share the target Google Sheet with the service account email
5. Place `credentials.json` in the project root

### Telegram

Configure the bot token and chat ID in each project's sheet uploader script:

- `TELEGRAM_BOT_TOKEN` — Bot authentication token
- `TELEGRAM_CHAT_ID` — Target chat/channel for alerts

### Browser Engines

| Engine | Installation |
|--------|-------------|
| Playwright (Chromium) | `playwright install chromium` |
| Camoufox (Firefox) | `python -m camoufox fetch` |

Browser paths are configured per project via `PLAYWRIGHT_BROWSERS_PATH` in `run_single_scraper.sh`.

## Troubleshooting

### Browser Issues

```bash
# Playwright
export PLAYWRIGHT_BROWSERS_PATH=/root/<project>/pw-browsers
playwright install chromium

# Camoufox
python -m camoufox fetch
```

### Scraper Failures

```bash
# Check logs
tail -100 /root/scraper_logs/<scraper_name>.log

# Check if screen session is running
screen -ls

# Restart a single scraper
screen -dmS scraper-largo bash /root/run_single_scraper.sh largo
```

### Google Sheets API Errors

- Verify `credentials.json` is present and valid
- Ensure the Google Sheet is shared with the service account email
- Check that the sheet ID in the uploader script is correct

### Memory Issues

The system includes automatic memory monitoring during sleep cycles. If available memory drops below 500MB, leftover browser processes are killed automatically.

## License

Proprietary — Internal use only

---

**Last Updated:** July 2026
**Version:** 3.0
