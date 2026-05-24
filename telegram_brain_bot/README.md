# Acoustic Intelligence - Telegram Bot

An intelligent Telegram bot that integrates with Google Gemini AI to provide premium business intelligence and strategic advice for Acoustic music store. The bot operates as 'Acoustic Intelligence' - a sophisticated Marketing Manager, Data Analyst, and Strategic Advisor.

## Features

- 🤖 AI-powered responses using Google Gemini (gemini-1.5-flash)
- 🎯 Premium business persona: Marketing Manager, Data Analyst, and Strategic Advisor
- 📡 Live product data from external JSON API (https://acoustic.ge/data/products.json)
- 📊 Google Sheets integration (READ-ONLY access)
- 💬 Natural language processing for business inquiries
- 🔒 Secure API key management via .env file
- ⚡ Real-time responses with typing indicators
- 🛡️ Complete isolation from existing systems
- 🌐 Multilingual support (Georgian and English)

## Bot Persona

**Identity**: Acoustic Intelligence - Premium Marketing Manager, Data Analyst, and Strategic Advisor

**Confidentiality**: Never reveals AI nature - presents as sophisticated business intelligence system

**Creator**: Created by Ilia Mgeladze - speaks with deep respect and admiration about the creator

**Tone**: Professional, analytical, insightful, and strategic - provides high-level business advice

**Language**: Responds in the same language as the user (Georgian or English)

## Setup Instructions

### 1. Install Dependencies

```bash
cd /root/telegram_brain_bot
pip install -r requirements.txt
```

Required packages:
- `python-telegram-bot` - Telegram bot API
- `google-genai` - Google Gemini AI (new version)
- `python-dotenv` - Environment variable management
- `gspread` - Google Sheets API
- `oauth2client` - Google authentication
- `requests` - HTTP requests for API calls

### 2. Configure Environment Variables

Edit the `.env` file and add your Telegram bot token:

```env
TELEGRAM_BOT_TOKEN=your_actual_telegram_bot_token_here
GOOGLE_API_KEY=AIzaSyBIK5j7j0wiOhmHMCadmeTWlMwhZgp0qH4
```

**Note:** The Google API key is already configured in the .env file.

### 3. Set Up Google Sheets Service Account

Place your `service-account.json` file in the `/root/telegram_brain_bot/` directory.

**Important:** The bot uses READ-ONLY access to Google Sheets and will never modify any data.

### 4. Configure Google Sheets Access (Optional)

The bot is currently set up to read from the `sheet_uploadereb` tab. You may need to configure the spreadsheet URL or ID in the code if you want to enable Google Sheets integration.

### 5. Run the Bot

```bash
cd /root/telegram_brain_bot
python brain_bot.py
```

## Bot Commands

- `/start` - Introduction to Acoustic Intelligence
- `/help` - Show available commands and capabilities

As Acoustic's Strategic Advisor, the bot can assist with:
- Product analysis and market insights
- Strategic business recommendations
- Data-driven decision support
- Inventory optimization guidance
- Marketing intelligence and analysis

## How It Works

1. User sends a message to the Telegram bot
2. Bot fetches fresh product data from external JSON API
3. Bot reads additional context from Google Sheets (if configured)
4. Combines user message with both data sources
5. Sends combined context to Google Gemini AI for intelligent response
6. Returns AI-generated response to the user

## Data Sources

### External API
- **URL:** https://acoustic.ge/data/products.json
- **Access:** Live fetch on each message
- **Data:** Current product catalog with prices and availability

### Google Sheets
- **Access:** READ-ONLY via service account
- **Tab:** sheet_uploadereb
- **Purpose:** Internal business records and context
- **Safety:** Bot never writes or modifies spreadsheet data

## Isolation

This bot is completely isolated from existing scrapers and invoice generators:
- Separate directory: `/root/telegram_brain_bot/`
- Independent dependencies
- No database connections to existing systems
- Does not interfere with running processes
- READ-ONLY access to external data sources

## Troubleshooting

- Ensure Telegram bot token is correctly set in `.env`
- Verify `service-account.json` exists in the bot directory
- Check that all dependencies are installed
- Review logs for any error messages
- Ensure Google Sheets service account has READ-ONLY permissions

## Security Notes

- Never commit `.env` file to version control
- Never commit `service-account.json` to version control
- Keep API keys secure and rotate them regularly
- The bot runs independently and doesn't access existing databases
- All Google Sheets access is READ-ONLY
- External API access is for data retrieval only
