"""Configuration for the Acoustic.ge order export."""

import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
REPORTS_DIR = os.path.join(BASE_DIR, "reports")
DATA_DIR = os.path.join(BASE_DIR, "data")

# ── Admin panel ────────────────────────────────────────────────────────────
ADMIN_URL = "https://acoustic.ge/aco_st_admin.php"
ADMIN_LOGIN = os.environ.get("ACOUSTIC_ADMIN_LOGIN", "")
ADMIN_PASSWORD = os.environ.get("ACOUSTIC_ADMIN_PASSWORD", "")

USER_AGENT = ("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
              "(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36")

# ── Politeness: keep the request rate low so the host never rate-limits us ──
DELAY_LIST_PAGE = (5.0, 8.0)   # between order-list pages
DELAY_DETAIL = (3.0, 5.0)      # between individual order pages
COOLDOWN_EVERY = 25            # take a longer break every N order pages
COOLDOWN_SECONDS = (30.0, 45.0)
REQUEST_TIMEOUT = 40
MAX_RETRIES = 3

# ── Google Sheets ──────────────────────────────────────────────────────────
CREDENTIALS_FILE = os.path.join(BASE_DIR, "credentials.json")
SPREADSHEET_ID = "1tDKgxcxPF8Jq151nMb6Wu_ziyOxkFATKSOquFKZrg94"
TAB_NAME = "Acoustic_orders"

# ── Output ─────────────────────────────────────────────────────────────────
EXCEL_PATH = os.path.join(REPORTS_DIR, "acoustic_orders.xlsx")

COLUMNS = [
    "ინვოისი",
    "თარიღი",
    "სახელი გვარი",
    "პირადი ნომერი",
    "ტელეფონი",
    "თანხა (GEL)",
    "ბანკი",
    "სტატუსი",
]

os.makedirs(REPORTS_DIR, exist_ok=True)
os.makedirs(DATA_DIR, exist_ok=True)
