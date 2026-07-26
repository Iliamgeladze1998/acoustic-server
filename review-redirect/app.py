import json
import uuid
import hashlib
from datetime import datetime
from pathlib import Path
from flask import Flask, send_file, send_from_directory, request, jsonify, Response

app = Flask(__name__)

DATA_DIR = Path(__file__).parent / "data"
DATA_DIR.mkdir(exist_ok=True)
ANALYTICS_FILE = DATA_DIR / "analytics.json"

ADMIN_PASSWORD = "acoustic_analytics_2026"

def load_analytics():
    if ANALYTICS_FILE.exists():
        with open(ANALYTICS_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {
        "visits": [],
        "clicks": [],
        "unique_users": {}
    }

def save_analytics(data):
    with open(ANALYTICS_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def get_user_fingerprint(req):
    """Generate unique user ID from IP + user-agent + screen info."""
    ip = req.headers.get('X-Forwarded-For', req.remote_addr or '').split(',')[0].strip()
    ua = req.headers.get('User-Agent', '')
    fp_data = req.args.get('fp', '') or req.form.get('fp', '') or ''
    raw = f"{ip}|{ua}|{fp_data}"
    return hashlib.sha256(raw.encode()).hexdigest()[:16]

@app.route('/')
def index():
    return send_file('/root/review-redirect/index.html')

@app.route('/favicon.ico')
@app.route('/logo_for_acoustic_browser_tab.png')
def favicon():
    return send_from_directory('/root/review-redirect', 'logo_for_acoustic_browser_tab.png')

@app.route('/acoustic_logo.png')
def acoustic_logo():
    return send_from_directory('/root/review-redirect', 'acoustic_logo.png')

# --- Analytics API ---

@app.route('/api/track/visit', methods=['POST'])
def track_visit():
    """Record a unique visitor."""
    data = request.get_json(silent=True) or {}
    user_id = data.get('user_id', '')
    if not user_id:
        user_id = get_user_fingerprint(request)
    
    analytics = load_analytics()
    
    is_new = user_id not in analytics["unique_users"]
    
    if is_new:
        analytics["unique_users"][user_id] = {
            "first_visit": datetime.now().isoformat(),
            "last_visit": datetime.now().isoformat(),
            "visit_count": 1,
            "clicked": None,
            "ip": request.headers.get('X-Forwarded-For', request.remote_addr or '').split(',')[0].strip(),
            "user_agent": request.headers.get('User-Agent', '')[:200],
        }
    else:
        analytics["unique_users"][user_id]["last_visit"] = datetime.now().isoformat()
        analytics["unique_users"][user_id]["visit_count"] += 1
    
    analytics["visits"].append({
        "user_id": user_id,
        "time": datetime.now().isoformat(),
        "ip": request.headers.get('X-Forwarded-For', request.remote_addr or '').split(',')[0].strip(),
        "is_new": is_new,
    })
    
    # Keep only last 1000 visits
    if len(analytics["visits"]) > 1000:
        analytics["visits"] = analytics["visits"][-1000:]
    
    save_analytics(analytics)
    
    return jsonify({"ok": True, "user_id": user_id, "is_new": is_new})

@app.route('/api/track/click', methods=['POST'])
def track_click():
    """Record a button click (positive or negative)."""
    data = request.get_json(silent=True) or {}
    user_id = data.get('user_id', '')
    action = data.get('action', '')  # 'positive' or 'negative'
    
    if action not in ('positive', 'negative'):
        return jsonify({"error": "invalid action"}), 400
    
    analytics = load_analytics()
    
    # Only count click if this user hasn't clicked before
    if user_id in analytics["unique_users"]:
        existing = analytics["unique_users"][user_id].get("clicked")
        if existing is not None:
            # User already clicked — don't count again
            return jsonify({"ok": True, "duplicate": True})
        analytics["unique_users"][user_id]["clicked"] = action
    else:
        # Unknown user — register them with their click
        analytics["unique_users"][user_id] = {
            "first_visit": datetime.now().isoformat(),
            "last_visit": datetime.now().isoformat(),
            "visit_count": 1,
            "clicked": action,
            "ip": request.headers.get('X-Forwarded-For', request.remote_addr or '').split(',')[0].strip(),
            "user_agent": request.headers.get('User-Agent', '')[:200],
        }
    
    analytics["clicks"].append({
        "user_id": user_id,
        "action": action,
        "time": datetime.now().isoformat(),
    })
    
    # Keep only last 1000 clicks
    if len(analytics["clicks"]) > 1000:
        analytics["clicks"] = analytics["clicks"][-1000:]
    
    save_analytics(analytics)
    
    return jsonify({"ok": True, "duplicate": False})

@app.route('/api/stats')
def get_stats():
    """Get current analytics stats."""
    analytics = load_analytics()
    
    unique_users = analytics["unique_users"]
    total_unique = len(unique_users)
    
    # Count unique users who clicked positive/negative (not total clicks)
    positive_count = sum(1 for u in unique_users.values() if u.get("clicked") == "positive")
    negative_count = sum(1 for u in unique_users.values() if u.get("clicked") == "negative")
    
    # Users who clicked something
    users_clicked = sum(1 for u in unique_users.values() if u.get("clicked") is not None)
    users_no_click = total_unique - users_clicked
    
    # Recent activity (last 24h)
    now = datetime.now()
    recent_24h = 0
    for v in analytics["visits"]:
        try:
            vt = datetime.fromisoformat(v["time"])
            if (now - vt).total_seconds() < 86400:
                recent_24h += 1
        except:
            pass
    
    # Last 10 visits
    recent_visits = analytics["visits"][-10:][::-1]
    
    return jsonify({
        "total_unique": total_unique,
        "total_visits": len(analytics["visits"]),
        "positive": positive_count,
        "negative": negative_count,
        "users_clicked": users_clicked,
        "users_no_click": users_no_click,
        "recent_24h": recent_24h,
        "recent_visits": recent_visits,
        "clicks": analytics["clicks"][-20:][::-1],
    })

@app.route('/analytics')
def analytics_page():
    return send_file('/root/review-redirect/analytics.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5556)
