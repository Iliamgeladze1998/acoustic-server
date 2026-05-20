# Multi-Project E-Commerce Price Comparison & Scraping System

A comprehensive automated scraping pipeline that compares product prices across multiple e-commerce websites and uploads the results to Google Sheets for monitoring and analysis.

## 🏗️ Architecture Overview

This system consists of three independent comparison projects that follow a consistent architecture pattern:

1. **ACMR (Acoustic-Musicroom)** - Compares Acoustic vs Musicroom prices
2. **ACMI (Acoustic-Mireli)** - Compares Acoustic vs Mireli prices  
3. **ACMS (Acoustic-Musikis-Saxli)** - Compares Acoustic vs Musikis-Saxli (Music House) prices

Each project follows the same data flow:
```
Scraper → Fresh Excel → Merger → Fresh Merged Excel → Uploader → Google Sheets
```

## 📁 Project Structure

```
/root/
├── Acoustic-Musicroom/          # ACMR Project
│   ├── acmr/
│   │   ├── acmr_main.py         # Main orchestrator
│   │   ├── acmr_data_merger.py  # Merges acoustic + musicroom data
│   │   └── acmr_sheet_uploader.py # Uploads to Google Sheets
│   ├── scrapers/
│   │   ├── acoustic/            # Acoustic website scraper
│   │   └── musicroom/           # Musicroom website scraper
│   ├── reports/                 # Generated Excel reports
│   └── requirements.txt
│
├── Acoustic-Mireli/             # ACMI Project
│   ├── acmi/
│   │   ├── acmi_main.py         # Main orchestrator
│   │   ├── acmi_data_merger.py  # Merges acoustic + mireli data
│   │   └── acmi_sheet_uploader.py # Uploads to Google Sheets
│   ├── scrapers/
│   │   ├── acoustic/            # Acoustic website scraper
│   │   └── mireli/              # Mireli website scraper
│   ├── reports/                 # Generated Excel reports
│   └── requirements.txt
│
├── scraping-project/            # ACMS Project
│   ├── acms/
│   │   ├── acms_main.py         # Main orchestrator
│   │   ├── acms_data_merger.py  # Merges acoustic + musikis data
│   │   └── acms_sheet_uploader.py # Uploads to Google Sheets
│   ├── scrapers/
│   │   ├── acoustic/            # Acoustic website scraper
│   │   └── musikis-saxli/       # Musikis-Saxli website scraper
│   ├── reports/                 # Generated Excel reports
│   └── requirements.txt
│
└── run_scrapers.sh              # Master orchestration script
```

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Virtual environment (venv)
- Google Sheets API credentials
- Telegram bot token (for alerts)
- Playwright browsers

### Running All Projects

Use the master orchestration script:

```bash
cd /root
bash run_scrapers.sh
```

This runs all three projects in sequence with 10-minute intervals:
1. Acoustic-Musicroom (ACMR)
2. Acoustic-Mireli (ACMI)  
3. Scraping-project (ACMS)

### Running Individual Projects

**ACMR (Acoustic-Musicroom):**
```bash
cd /root/Acoustic-Musicroom
source venv/bin/activate
export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Musicroom/pw-browsers
python acmr/acmr_main.py
```

**ACMI (Acoustic-Mireli):**
```bash
cd /root/Acoustic-Mireli
source venv/bin/activate
export PLAYWRIGHT_BROWSERS_PATH=/root/Acoustic-Mireli/pw-browsers
python acmi/acmi_main.py
```

**ACMS (Acoustic-Musikis-Saxli):**
```bash
cd /root/scraping-project
source venv/bin/activate
python acms/acms_main.py
```

## 🔧 Component Details

### 1. Scrapers
Each project contains two scrapers:
- **Acoustic scraper**: Scrapes the baseline Acoustic website
- **Competitor scraper**: Scrapes the competitor website (Musicroom/Mireli/Musikis)

**Key Features:**
- Playwright-based web scraping
- Product link collection and extraction
- Price and availability tracking
- Clean start (no stale data merging)
- Automatic browser path configuration

### 2. Data Merger
Merges data from both scrapers into a comprehensive comparison:

**Input:**
- Fresh acoustic data Excel file
- Fresh competitor data Excel file

**Output:**
- Merged Excel file with price comparisons
- Price difference calculations
- Availability status comparison
- Match confidence scores

**Key Features:**
- Deletes previous merged report before starting
- Fuzzy product name matching (Levenshtein distance)
- Brand and category matching
- Price difference analysis
- Fresh-only data processing

### 3. Sheet Uploader
Uploads merged data to Google Sheets with monitoring:

**Key Features:**
- **24-hour freshness guard**: Aborts if merged Excel is older than 24 hours
- **Dual-source validation**: 
  - `df_old` from live Google Sheet
  - `df_new` from fresh merged Excel
- **Alert-before-update**: Sends Telegram alerts BEFORE sheet modification
- **Price change detection**: Identifies significant price changes
- **Safe overwrite**: Only updates sheet after alerts are sent

### 4. Main Orchestrator
Coordinates the pipeline execution:

**Pipeline Stages:**
1. Run acoustic scraper
2. Run competitor scraper
3. Validate scraper outputs
4. Run data merger
5. Validate merger output
6. Run sheet uploader
7. Validate upload success

**Error Handling:**
- Stops pipeline on any stage failure
- Proper exit codes (0 for success, 1 for failure)
- Detailed error logging
- No fail-open behavior

## 🛡️ Data Freshness Guarantees

The system implements multiple layers of protection against stale data:

### 1. Scraper Level
- **Clean start**: All scrapers start with empty output files
- **No checkpoint merging**: Previous run data is never merged
- **Stale file deletion**: Output files deleted at startup
- **Empty result detection**: Aborts if no products are scraped

### 2. Merger Level
- **Previous report deletion**: Merged reports deleted before processing
- **Fresh input validation**: Only processes current run's scraper outputs
- **No cache**: No intermediate file caching

### 3. Uploader Level
- **24-hour freshness guard**: Aborts if merged Excel is older than 24 hours
- **Live sheet baseline**: Always reads current sheet state
- **Alert-before-update**: Telegram alerts sent before any modification
- **Atomic updates**: Sheet cleared only after alerts succeed

### 4. Orchestrator Level
- **Stage validation**: Each stage must succeed before proceeding
- **Exit code propagation**: Failures stop the entire pipeline
- **No silent failures**: All errors are logged and reported

## 📊 Monitoring & Alerts

### Telegram Integration
The system sends Telegram alerts for:
- Price changes above threshold
- Product availability changes
- New product matches
- Scraping failures
- Upload failures

### Google Sheets Integration
Each project uploads to a dedicated Google Sheet with:
- Real-time price comparisons
- Price difference highlighting
- Availability status
- Historical data tracking
- Automatic formatting

## 🔐 Configuration

### Credentials
Each project requires:
- `credentials.json`: Google Sheets API credentials
- Telegram bot token (in environment variables or config)
- Website-specific configurations

### Environment Variables
- `PLAYWRIGHT_BROWSERS_PATH`: Path to Playwright browsers
- `TELEGRAM_BOT_TOKEN`: Telegram bot authentication
- `TELEGRAM_CHAT_ID`: Target chat for alerts

### Google Sheets Setup
1. Create Google Cloud Project
2. Enable Sheets API
3. Create service account credentials
4. Share sheet with service account email
5. Configure sheet ID in uploader scripts

## 🐛 Troubleshooting

### Playwright Browser Issues
```bash
# Install browsers
playwright install chromium

# Set browser path
export PLAYWRIGHT_BROWSERS_PATH=/path/to/project/pw-browsers
```

### Permission Issues
```bash
# Make scripts executable
chmod +x run_scrapers.sh

# Fix virtual environment permissions
chmod -R 755 venv/
```

### Google Sheets API Errors
- Verify credentials.json format
- Check service account permissions
- Ensure sheet is shared with service account
- Validate sheet ID configuration

### Scraper Failures
- Check website accessibility
- Verify Playwright browser installation
- Review scraper logs for specific errors
- Check rate limiting and blocking

## 📝 Recent Improvements

### Pipeline Architecture Audit (May 2026)
Comprehensive audit and fixes to ensure strict "fresh-only" data flow:

- **Uploader Checkpoint Order**: Enforced 24h guard → fresh Excel + live Sheet → Telegram alerts → sheet update
- **Stale Report Prevention**: Mergers now delete previous reports before processing
- **Fail-Closed Orchestration**: ACMS now stops immediately on failures with proper exit codes
- **Clean Scraper Starts**: All scrapers start fresh without merging previous runs
- **Syntax Validation**: All modified Python files passed syntax checks

### Playwright Browser Path Fix
- Fixed browser path issues for Musicroom and Mireli projects
- Added proper environment variable configuration
- Implemented fallback browser detection

### Musikis Scraper Enhancement
- Eliminated stale data merging in link collection
- Implemented clean startup with file deletion
- Added empty result detection and abort

## 🔄 Pipeline Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    run_scrapers.sh                           │
│                  (Master Orchestrator)                       │
└────────────────────┬────────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│     ACMR     │ │     ACMI     │ │     ACMS     │
│ (Musicroom)  │ │   (Mireli)   │ │  (Musikis)   │
└──────┬───────┘ └──────┬───────┘ └──────┬───────┘
       │                │                │
       ▼                ▼                ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ acmr_main.py │ │ acmi_main.py │ │ acms_main.py │
└──────┬───────┘ └──────┬───────┘ └──────┬───────┘
       │                │                │
       ▼                ▼                ▼
┌─────────────────────────────────────────────────────┐
│              1. SCRAPERS (Clean Start)              │
│  • acoustic scraper → fresh acoustic.xlsx           │
│  • competitor scraper → fresh competitor.xlsx      │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│              2. DATA MERGER (Fresh Only)             │
│  • Delete previous merged report                    │
│  • Merge acoustic + competitor data                │
│  • Fuzzy matching & price comparison               │
│  • Output: fresh_merged_report.xlsx                 │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│              3. SHEET UPLOADER (Guarded)             │
│  • Check 24-hour freshness of merged Excel          │
│  • Read df_new from fresh merged Excel              │
│  • Read df_old from live Google Sheet               │
│  • Detect price changes & send Telegram alerts       │
│  • Update Google Sheet (only after alerts)          │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
              Pipeline Complete
```

## 📄 License

Proprietary - Internal use only

## 👥 Support

For issues or questions:
- Check logs in individual project directories
- Review error messages in orchestrator output
- Verify configuration files and credentials
- Ensure all dependencies are installed

---

**Last Updated:** May 20, 2026  
**Version:** 2.0 (Post-Audit Architecture)