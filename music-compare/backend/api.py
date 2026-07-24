#!/usr/bin/env python3
"""
Music Compare API - FastAPI backend
Serves product data from SQLite database.
"""

import os
import sqlite3
import hashlib
import secrets
import time
from datetime import datetime
from fastapi import FastAPI, HTTPException, Query, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse
from pydantic import BaseModel
from typing import Optional

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "music_compare.db")
FRONTEND_BUILD = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "frontend", "dist")

ADMIN_EMAIL = os.environ.get("MC_ADMIN_EMAIL", "mgeladzeilia39@gmail.com")
ADMIN_PASSWORD = os.environ.get("MC_ADMIN_PASS", "Setembrini1.")

app = FastAPI(title="Music Compare API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def ensure_tables():
    """Create user-related tables if they don't exist (independent of sync)."""
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            first_name TEXT DEFAULT '',
            last_name TEXT DEFAULT '',
            created_at TEXT,
            last_login TEXT
        )
    """)
    c.execute("""
        CREATE TABLE IF NOT EXISTS favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            match_key TEXT NOT NULL,
            created_at TEXT,
            UNIQUE(user_id, match_key),
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    """)
    c.execute("""
        CREATE TABLE IF NOT EXISTS visitors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip TEXT,
            user_agent TEXT,
            path TEXT,
            user_id INTEGER,
            created_at TEXT
        )
    """)
    c.execute("""
        CREATE TABLE IF NOT EXISTS feedback (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            group_id INTEGER,
            match_key TEXT NOT NULL,
            store_name TEXT DEFAULT '',
            listing_product_name TEXT DEFAULT '',
            status TEXT DEFAULT 'wrong',
            note TEXT DEFAULT '',
            created_at TEXT,
            reviewed INTEGER DEFAULT 0
        )
    """)
    c.execute("CREATE INDEX IF NOT EXISTS idx_visitors_created ON visitors(created_at)")
    conn.commit()
    conn.close()


@app.on_event("startup")
def startup_event():
    ensure_tables()


@app.get("/api/health")
def health():
    return {"status": "ok", "time": datetime.now().isoformat()}


@app.get("/api/stores")
def get_stores():
    """Get list of all stores with product counts."""
    conn = get_db()
    c = conn.cursor()
    c.execute("""
        SELECT store_name, COUNT(*) as count, 
               MIN(price) as min_price, MAX(price) as max_price
        FROM listings 
        WHERE price IS NOT NULL AND price > 0
        GROUP BY store_name 
        ORDER BY count DESC
    """)
    stores = [dict(row) for row in c.fetchall()]
    conn.close()
    return {"stores": stores}


@app.get("/api/search")
def search_products(
    q: str = Query("", description="Search query"),
    store: str = Query("", description="Filter by store name"),
    sort: str = Query("price_asc", description="Sort: price_asc, price_desc, name_asc, diff_desc, stores_desc"),
    limit: int = Query(50, le=200),
    offset: int = Query(0, ge=0),
):
    """Search products grouped by product group, with prices from all stores."""
    conn = get_db()
    c = conn.cursor()

    # Build query on product_groups
    where_parts = []
    params = []

    if q:
        where_parts.append("(g.display_name LIKE ? OR g.match_key LIKE ?)")
        params.extend([f"%{q}%", f"%{q}%"])

    if store:
        where_parts.append("""
            g.id IN (SELECT group_id FROM listings WHERE store_name = ?)
        """)
        params.append(store)

    where_clause = " AND ".join(where_parts) if where_parts else "1=1"

    c.execute(f"""
        SELECT g.id, g.match_key, g.display_name, g.image_url, 
               g.store_count, g.min_price, g.max_price, g.last_updated
        FROM product_groups g
        WHERE {where_clause}
    """, params)

    groups = [dict(row) for row in c.fetchall()]

    # For each group, fetch its listings
    result_list = []
    for g in groups:
        c.execute("""
            SELECT store_name, price, link, product_name, image_url
            FROM listings
            WHERE group_id = ? AND price IS NOT NULL AND price > 0
            ORDER BY price ASC
        """, (g["id"],))
        listings = [dict(row) for row in c.fetchall()]

        if not listings:
            continue

        prices = [l["price"] for l in listings if l["price"] and l["price"] > 0]
        cheapest = min(listings, key=lambda x: x["price"] if x["price"] else float('inf'))

        result_list.append({
            "id": g["id"],
            "match_key": g["match_key"],
            "display_name": g["display_name"],
            "image_url": g["image_url"] or "",
            "last_updated": g["last_updated"] or "",
            "store_count": len(set(l["store_name"] for l in listings)),
            "min_price": min(prices) if prices else None,
            "max_price": max(prices) if prices else None,
            "price_diff": (max(prices) - min(prices)) if prices and len(prices) > 1 else 0,
            "cheapest_store": cheapest["store_name"],
            "cheapest_price": cheapest["price"],
            "cheapest_link": cheapest["link"],
            "listings": listings,
        })

    # Sort
    if sort == "price_asc":
        result_list.sort(key=lambda x: x["min_price"] or float('inf'))
    elif sort == "price_desc":
        result_list.sort(key=lambda x: x["max_price"] or 0, reverse=True)
    elif sort == "name_asc":
        result_list.sort(key=lambda x: x["display_name"].lower())
    elif sort == "diff_desc":
        result_list.sort(key=lambda x: x["price_diff"], reverse=True)
    elif sort == "stores_desc":
        result_list.sort(key=lambda x: x["store_count"], reverse=True)

    total = len(result_list)
    paginated = result_list[offset:offset + limit]

    conn.close()

    return {
        "total": total,
        "products": paginated,
        "query": q,
        "store_filter": store,
    }


@app.get("/api/suggestions")
def get_suggestions(
    q: str = Query("", description="Search query prefix"),
    limit: int = Query(10, le=20),
):
    """Autocomplete suggestions for search input."""
    if not q or len(q) < 2:
        return {"suggestions": []}

    conn = get_db()
    c = conn.cursor()

    c.execute("""
        SELECT display_name, match_key, image_url, min_price, store_count
        FROM product_groups
        WHERE display_name LIKE ?
        ORDER BY 
            CASE WHEN display_name LIKE ? THEN 0 ELSE 1 END,
            store_count DESC,
            min_price ASC
        LIMIT ?
    """, (f"%{q}%", f"{q}%", limit))

    suggestions = []
    for row in c.fetchall():
        suggestions.append({
            "display_name": row["display_name"],
            "match_key": row["match_key"],
            "image_url": row["image_url"] or "",
            "min_price": row["min_price"],
            "store_count": row["store_count"],
        })

    conn.close()
    return {"suggestions": suggestions}


@app.get("/api/product/{match_key}")
def get_product_detail(match_key: str):
    """Get detailed product info by match_key or group id."""
    conn = get_db()
    c = conn.cursor()

    # Try by match_key first
    c.execute("""
        SELECT id, match_key, display_name, image_url, store_count, 
               min_price, max_price, last_updated
        FROM product_groups WHERE match_key = ?
    """, (match_key,))
    group = c.fetchone()

    if not group:
        # Try by id
        try:
            c.execute("SELECT * FROM product_groups WHERE id = ?", (int(match_key),))
            group = c.fetchone()
        except (ValueError, TypeError):
            pass

    if not group:
        conn.close()
        raise HTTPException(status_code=404, detail="Product not found")

    group = dict(group)

    c.execute("""
        SELECT store_name, price, link, product_name, image_url
        FROM listings
        WHERE group_id = ? AND price IS NOT NULL AND price > 0
        ORDER BY price ASC
    """, (group["id"],))
    listings = [dict(row) for row in c.fetchall()]

    prices = [l["price"] for l in listings if l["price"] and l["price"] > 0]

    result = {
        "id": group["id"],
        "match_key": group["match_key"],
        "display_name": group["display_name"],
        "image_url": group["image_url"] or "",
        "last_updated": group["last_updated"] or "",
        "listings": listings,
        "min_price": min(prices) if prices else None,
        "max_price": max(prices) if prices else None,
        "price_diff": (max(prices) - min(prices)) if prices and len(prices) > 1 else 0,
        "store_count": len(set(l["store_name"] for l in listings)),
    }

    conn.close()
    return result


@app.get("/api/stats")
def get_stats():
    """Get overall statistics."""
    conn = get_db()
    c = conn.cursor()

    c.execute("SELECT COUNT(*) as total FROM listings WHERE price > 0")
    total_listings = c.fetchone()[0]

    c.execute("SELECT COUNT(DISTINCT store_name) as stores FROM listings WHERE price > 0")
    total_stores = c.fetchone()[0]

    c.execute("SELECT COUNT(*) as total FROM product_groups")
    total_products = c.fetchone()[0]

    c.execute("""
        SELECT COUNT(*) as total FROM product_groups WHERE store_count > 1
    """)
    multi_store_products = c.fetchone()[0]

    c.execute("""
        SELECT store_name, COUNT(*) as count 
        FROM listings WHERE price > 0
        GROUP BY store_name ORDER BY count DESC
    """)
    store_counts = [dict(row) for row in c.fetchall()]

    c.execute("SELECT MAX(sync_time) as last_sync FROM sync_log")
    row = c.fetchone()
    last_sync = row["last_sync"] if row else None

    conn.close()

    return {
        "total_listings": total_listings,
        "total_stores": total_stores,
        "total_products": total_products,
        "multi_store_products": multi_store_products,
        "store_counts": store_counts,
        "last_sync": last_sync,
    }


class FeedbackRequest(BaseModel):
    match_key: str
    store_name: Optional[str] = None
    listing_product_name: Optional[str] = None
    note: Optional[str] = None


@app.post("/api/feedback")
async def submit_feedback(req: FeedbackRequest):
    """Submit wrong match feedback from users."""
    if not req.match_key:
        raise HTTPException(status_code=400, detail="match_key is required")

    conn = get_db()
    c = conn.cursor()

    # Get group display name for context
    c.execute("SELECT display_name FROM product_groups WHERE match_key = ?", (req.match_key,))
    group_row = c.fetchone()
    display_name = group_row["display_name"] if group_row else ""

    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    c.execute("""
        INSERT INTO feedback (match_key, store_name, listing_product_name, status, note, created_at, reviewed)
        VALUES (?, ?, ?, 'wrong', ?, ?, 0)
    """, (req.match_key, req.store_name or "", req.listing_product_name or "",
          req.note or "", now))
    conn.commit()
    feedback_id = c.lastrowid
    conn.close()

    return {"status": "reported", "id": feedback_id, "display_name": display_name}


@app.get("/api/feedback")
def get_feedback(reviewed: int = Query(0, description="0=unreviewed, 1=reviewed, -1=all")):
    """Get feedback list (for admin review)."""
    conn = get_db()
    c = conn.cursor()

    if reviewed == -1:
        c.execute("""
            SELECT f.*, g.display_name, g.image_url
            FROM feedback f
            LEFT JOIN product_groups g ON f.match_key = g.match_key
            ORDER BY f.created_at DESC
        """)
    else:
        c.execute("""
            SELECT f.*, g.display_name, g.image_url
            FROM feedback f
            LEFT JOIN product_groups g ON f.match_key = g.match_key
            WHERE f.reviewed = ?
            ORDER BY f.created_at DESC
        """, (reviewed,))

    rows = [dict(row) for row in c.fetchall()]
    conn.close()
    return {"feedback": rows, "count": len(rows)}


@app.post("/api/feedback/{feedback_id}/review")
def mark_feedback_reviewed(feedback_id: int):
    """Mark feedback as reviewed."""
    conn = get_db()
    c = conn.cursor()
    c.execute("UPDATE feedback SET reviewed = 1 WHERE id = ?", (feedback_id,))
    conn.commit()
    conn.close()
    return {"status": "reviewed", "id": feedback_id}


class AdminLoginRequest(BaseModel):
    email: str
    password: str


@app.post("/api/admin/login")
def admin_login(req: AdminLoginRequest):
    """Admin login endpoint."""
    if req.email == ADMIN_EMAIL and req.password == ADMIN_PASSWORD:
        return {"status": "ok"}
    raise HTTPException(status_code=401, detail="არასწორი ელ-ფოსტა ან პაროლი")


# ─── Visitor tracking ───

@app.middleware("http")
async def track_visitor(request: Request, call_next):
    response = await call_next(request)
    path = request.url.path
    if path.startswith("/api/") or path.startswith("/assets/"):
        return response
    try:
        conn = get_db()
        c = conn.cursor()
        ip = request.client.host if request.client else ""
        ua = request.headers.get("user-agent", "")[:200]
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        c.execute("INSERT INTO visitors (ip, user_agent, path, created_at) VALUES (?, ?, ?, ?)",
                  (ip, ua, path, now))
        conn.commit()
        conn.close()
    except Exception:
        pass
    return response


# ─── User auth ───

class RegisterRequest(BaseModel):
    email: str
    password: str
    first_name: Optional[str] = ""
    last_name: Optional[str] = ""


class UserLoginRequest(BaseModel):
    email: str
    password: str


def generate_token():
    return secrets.token_hex(24)


# Simple in-memory token store (token -> user_id)
_tokens = {}


@app.post("/api/auth/register")
def register(req: RegisterRequest):
    conn = get_db()
    c = conn.cursor()
    c.execute("SELECT id FROM users WHERE email = ?", (req.email,))
    if c.fetchone():
        conn.close()
        raise HTTPException(status_code=400, detail="ეს ელ-ფოსტა უკვე რეგისტრირებულია")
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    c.execute("""
        INSERT INTO users (email, password, first_name, last_name, created_at)
        VALUES (?, ?, ?, ?, ?)
    """, (req.email, req.password, req.first_name or "", req.last_name or "", now))
    conn.commit()
    user_id = c.lastrowid
    conn.close()
    token = generate_token()
    _tokens[token] = user_id
    return {"status": "ok", "token": token, "user": {"id": user_id, "email": req.email,
            "first_name": req.first_name or "", "last_name": req.last_name or ""}}


@app.post("/api/auth/login")
def user_login(req: UserLoginRequest):
    conn = get_db()
    c = conn.cursor()
    c.execute("SELECT * FROM users WHERE email = ? AND password = ?", (req.email, req.password))
    row = c.fetchone()
    if not row:
        conn.close()
        raise HTTPException(status_code=401, detail="არასწორი ელ-ფოსტა ან პაროლი")
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    c.execute("UPDATE users SET last_login = ? WHERE id = ?", (now, row["id"]))
    conn.commit()
    conn.close()
    token = generate_token()
    _tokens[token] = row["id"]
    return {"status": "ok", "token": token, "user": {"id": row["id"], "email": row["email"],
            "first_name": row["first_name"], "last_name": row["last_name"]}}


@app.get("/api/auth/me")
def get_me(token: str = Query(...)):
    user_id = _tokens.get(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="არასწორი ტოკენი")
    conn = get_db()
    c = conn.cursor()
    c.execute("SELECT id, email, first_name, last_name FROM users WHERE id = ?", (user_id,))
    row = c.fetchone()
    conn.close()
    if not row:
        raise HTTPException(status_code=401, detail="მომხმარებელი ვერ მოიძებნა")
    return {"user": dict(row)}


# ─── Favorites ───

class FavoriteRequest(BaseModel):
    token: str
    match_key: str


@app.post("/api/favorites/add")
def add_favorite(req: FavoriteRequest):
    user_id = _tokens.get(req.token)
    if not user_id:
        raise HTTPException(status_code=401, detail="არასწორი ტოკენი")
    conn = get_db()
    c = conn.cursor()
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    c.execute("INSERT OR IGNORE INTO favorites (user_id, match_key, created_at) VALUES (?, ?, ?)",
              (user_id, req.match_key, now))
    conn.commit()
    conn.close()
    return {"status": "ok"}


@app.post("/api/favorites/remove")
def remove_favorite(req: FavoriteRequest):
    user_id = _tokens.get(req.token)
    if not user_id:
        raise HTTPException(status_code=401, detail="არასწორი ტოკენი")
    conn = get_db()
    c = conn.cursor()
    c.execute("DELETE FROM favorites WHERE user_id = ? AND match_key = ?", (user_id, req.match_key))
    conn.commit()
    conn.close()
    return {"status": "ok"}


@app.get("/api/favorites/list")
def list_favorites(token: str = Query(...)):
    user_id = _tokens.get(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="არასწორი ტოკენი")
    conn = get_db()
    c = conn.cursor()
    c.execute("""
        SELECT g.* FROM favorites f
        JOIN product_groups g ON f.match_key = g.match_key
        WHERE f.user_id = ?
        ORDER BY f.created_at DESC
    """, (user_id,))
    groups = [dict(row) for row in c.fetchall()]

    result = []
    for g in groups:
        c.execute("""
            SELECT store_name, price, link, product_name, image_url
            FROM listings
            WHERE group_id = ? AND price IS NOT NULL AND price > 0
            ORDER BY price ASC
        """, (g["id"],))
        listings = [dict(row) for row in c.fetchall()]
        if not listings:
            continue
        prices = [l["price"] for l in listings if l["price"] and l["price"] > 0]
        cheapest = min(listings, key=lambda x: x["price"] if x["price"] else float('inf'))
        result.append({
            "id": g["id"],
            "match_key": g["match_key"],
            "display_name": g["display_name"],
            "image_url": g["image_url"] or "",
            "last_updated": g["last_updated"] or "",
            "store_count": len(set(l["store_name"] for l in listings)),
            "min_price": min(prices) if prices else None,
            "max_price": max(prices) if prices else None,
            "price_diff": (max(prices) - min(prices)) if prices and len(prices) > 1 else 0,
            "cheapest_store": cheapest["store_name"],
            "cheapest_price": cheapest["price"],
            "cheapest_link": cheapest["link"],
            "listings": listings,
        })

    conn.close()
    return {"favorites": result}


# ─── Analytics ───

@app.get("/api/admin/analytics")
def analytics():
    """Get visitor analytics for admin."""
    conn = get_db()
    c = conn.cursor()
    now = datetime.now()

    # Total visits
    c.execute("SELECT COUNT(*) FROM visitors")
    total_visits = c.fetchone()[0]

    # Unique IPs
    c.execute("SELECT COUNT(DISTINCT ip) FROM visitors")
    unique_ips = c.fetchone()[0]

    # Visits today
    today = now.strftime("%Y-%m-%d")
    c.execute("SELECT COUNT(*) FROM visitors WHERE created_at LIKE ?", (f"{today}%",))
    today_visits = c.fetchone()[0]

    # Unique IPs today
    c.execute("SELECT COUNT(DISTINCT ip) FROM visitors WHERE created_at LIKE ?", (f"{today}%",))
    today_unique = c.fetchone()[0]

    # Last 7 days daily counts
    c.execute("""
        SELECT DATE(created_at) as day, COUNT(*) as visits, COUNT(DISTINCT ip) as unique_ips
        FROM visitors
        WHERE created_at >= date('now', '-7 days')
        GROUP BY DATE(created_at)
        ORDER BY day DESC
    """)
    daily = [dict(row) for row in c.fetchall()]

    # Recent visitors
    c.execute("SELECT ip, user_agent, path, created_at FROM visitors ORDER BY created_at DESC LIMIT 50")
    recent = [dict(row) for row in c.fetchall()]

    # Registered users count
    c.execute("SELECT COUNT(*) FROM users")
    total_users = c.fetchone()[0]

    conn.close()
    return {
        "total_visits": total_visits,
        "unique_ips": unique_ips,
        "today_visits": today_visits,
        "today_unique": today_unique,
        "daily": daily,
        "recent": recent,
        "total_users": total_users,
    }


# ─── Admin: users ───

@app.get("/api/admin/users")
def admin_users():
    """Get all registered users (for admin)."""
    conn = get_db()
    c = conn.cursor()
    c.execute("SELECT * FROM users ORDER BY created_at DESC")
    rows = [dict(row) for row in c.fetchall()]
    conn.close()
    return {"users": rows, "count": len(rows)}


# Serve frontend (if built)
if os.path.isdir(FRONTEND_BUILD):
    app.mount("/assets", StaticFiles(directory=os.path.join(FRONTEND_BUILD, "assets")), name="assets")

    @app.get("/{full_path:path}")
    async def serve_frontend(full_path: str):
        file_path = os.path.join(FRONTEND_BUILD, full_path)
        if os.path.isfile(file_path):
            return FileResponse(file_path)
        return FileResponse(os.path.join(FRONTEND_BUILD, "index.html"))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3001)
