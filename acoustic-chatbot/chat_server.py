"""
Acoustic.ge AI Chatbot Backend — Real AI with Gemini
Serves on port 5560.
- Scrapes site pages (about, services, contact, rehearsal) live
- Loads products from acoustic.ge/data/products.json
- Uses Gemini API for intelligent responses
- Falls back to keyword search if API unavailable
"""
import json
import os
import re
import time
import requests as req
from flask import Flask, request as flask_request, jsonify, send_from_directory
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# === CONFIG ===
# Put your new Gemini API key here (get it from https://aistudio.google.com/apikey)
GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "AIzaSyBIK5j7j0wiOhmHMCadmeTWlMwhZgp0qH4")
GEMINI_MODEL = "gemini-2.0-flash"
GEMINI_URL = f"https://generativelanguage.googleapis.com/v1beta/models/{GEMINI_MODEL}:generateContent?key={GEMINI_API_KEY}"

PRODUCTS_URL = "https://acoustic.ge/data/products.json"
SITE_PAGES = {
    "about": "https://acoustic.ge/about/",
    "services": "https://acoustic.ge/services/",
    "contact": "https://acoustic.ge/contact",
    "rehearsal": "https://sheet.acoustic.ge/",
}

# === CACHES ===
_products_cache = None
_products_cache_time = 0
_pages_cache = {}
_pages_cache_time = 0


def load_products():
    global _products_cache, _products_cache_time
    now = time.time()
    if _products_cache and (now - _products_cache_time) < 300:
        return _products_cache
    try:
        resp = req.get(PRODUCTS_URL, timeout=10)
        _products_cache = resp.json()
        _products_cache_time = now
        return _products_cache
    except Exception as e:
        print(f"Error loading products: {e}")
        return _products_cache if _products_cache else []


def scrape_page(url):
    """Fetch and clean a page to text"""
    try:
        resp = req.get(url, timeout=15, verify=False, headers={
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
        })
        text = resp.text
        # Remove scripts/styles
        text = re.sub(r'<script[^>]*>.*?</script>', '', text, flags=re.DOTALL)
        text = re.sub(r'<style[^>]*>.*?</style>', '', text, flags=re.DOTALL)
        text = re.sub(r'<nav[^>]*>.*?</nav>', '', text, flags=re.DOTALL)
        text = re.sub(r'<header[^>]*>.*?</header>', '', text, flags=re.DOTALL)
        text = re.sub(r'<footer[^>]*>.*?</footer>', '', text, flags=re.DOTALL)
        # Convert breaks
        text = re.sub(r'<br\s*/?>', '\n', text)
        text = re.sub(r'</(p|div|h[1-6]|li|tr)>', '\n', text)
        # Strip tags
        text = re.sub(r'<[^>]+>', ' ', text)
        # Clean whitespace
        lines = [l.strip() for l in text.split('\n') if l.strip() and len(l.strip()) > 2]
        return '\n'.join(lines)[:4000]
    except Exception as e:
        print(f"Error scraping {url}: {e}")
        return ""


def load_site_pages():
    """Scrape all site pages, cache for 10 minutes"""
    global _pages_cache, _pages_cache_time
    now = time.time()
    if _pages_cache and (now - _pages_cache_time) < 600:
        return _pages_cache
    
    import urllib3
    urllib3.disable_warnings()
    
    _pages_cache = {}
    for name, url in SITE_PAGES.items():
        _pages_cache[name] = scrape_page(url)
    _pages_cache_time = now
    return _pages_cache


def build_system_prompt(products, pages):
    """Build a comprehensive system prompt with all site data"""
    
    # Product summary (first 150 products to keep token count reasonable)
    product_lines = []
    for p in products[:150]:
        name = p.get("product", "")
        price = p.get("price", 0)
        amount = p.get("amount", 0)
        url = p.get("url", "")
        stock = "მარაგში" if amount > 0 else "ვერ მოიწერება"
        product_lines.append(f"- {name} | ფასი: {price}₾ | {stock} | ლინკი: {url}")
    
    products_text = '\n'.join(product_lines)
    
    # Site pages content
    about_text = pages.get("about", "")
    services_text = pages.get("services", "")
    contact_text = pages.get("contact", "")
    rehearsal_text = pages.get("rehearsal", "")[:2000]  # Limit rehearsal (it's huge)
    
    prompt = f"""შენ ხარ Acoustic.ge-ის (აკუსტიკა) ვირტუალური ასისტენტი. შენი მოვალეობაა დაეხმარო მომხმარებლებს მუსიკალური ინსტრუმენტების მაღაზიის შესახებ კითხვებზე ჭკვიანურად პასუხის გაცემაში.

=== საიტის გვერდების კონტენტი ===

--- ჩვენს შესახებ ---
{about_text}

--- სერვისები ---
{services_text}

--- კონტაქტი ---
{contact_text}

--- სარეპეტიციო განრიგი ---
{rehearsal_text}

=== პროდუქცია (პირველი 150 პროდუქტი) ===
{products_text}

=== წესები ===
1. პასუხობ ქართულად, მეგობრულად და ბუნებრივად
2. როცა მომხმარებელი პროდუქტს ეძებს, მოძებნე სიაში და მიუთითე ფასი, მარაგის სტატუსი და ლინკი
3. თუ პროდუქტი ვერ მოიძებნა სიაში, შემოთავაზე მსგავსი პროდუქტები ან უთხარი რომ არ არის მარაგში
4. სარეპეტიციოს შესახებ კითხვისას გამოიყენე განრიგის ინფორმაცია — მომხმარებელს შეუძლია დაჯავშნოს ტელეფონზე: 505 050 299
5. სერვისის შესახებ კითხვისას აღწერე რა სერვისები გაქვთ
6. კონტაქტის, მისამართის, საათების შესახებ გამოიყენე კონტაქტის გვერდის ინფორმაცია
7. პასუხები იყოს მოკლე, კონკრეტული და სასარგებლო
8. არ მოიგონო ინფორმაცია — მხოლოდ ის თქვი, რაც მოცემულ მონაცემებშია
9. თუ კითხვა არ ეხება მაღაზიას, თხოვე დააზუსტოს
10. ემოციების გამოსახვაში გამოიყენე ემოჯი (🎵🎸🛠️📍📞)
"""
    return prompt


def call_gemini(system_prompt, user_message, history):
    """Call Gemini API"""
    contents = [
        {"role": "user", "parts": [{"text": system_prompt}]},
        {"role": "model", "parts": [{"text": "გამარჯობა! მე აკუსტიკის ასისტენტი ვარ. რით შემიძლია დაგეხმარო? 🎸"}]}
    ]
    
    for h in history[-6:]:
        role = "user" if h.get("role") == "user" else "model"
        contents.append({"role": role, "parts": [{"text": h.get("content", "")}]})
    
    contents.append({"role": "user", "parts": [{"text": user_message}]})
    
    payload = {
        "contents": contents,
        "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 600,
            "topP": 0.9
        }
    }
    
    resp = req.post(GEMINI_URL, json=payload, timeout=30)
    result = resp.json()
    
    if "candidates" in result and len(result["candidates"]) > 0:
        return result["candidates"][0]["content"]["parts"][0]["text"].strip()
    else:
        error_msg = json.dumps(result, ensure_ascii=False)[:300]
        print(f"Gemini error: {error_msg}")
        return None


def search_products(query, products, limit=5):
    """Fallback product search"""
    query = query.lower().strip()
    results = []
    for p in products:
        name = p.get("product", "").lower()
        score = 0
        if query in name:
            score = 100
        else:
            for qw in query.split():
                if len(qw) > 2:
                    for nw in name.split():
                        if qw in nw or nw in qw:
                            score += 10
        if score > 0:
            results.append((score, p))
    results.sort(key=lambda x: -x[0])
    return [r[1] for r in results[:limit]]


def fallback_reply(message, products, pages):
    """Keyword-based fallback when API is unavailable"""
    msg = message.lower()
    
    if any(w in msg for w in ["გამარჯობ", "სალამ", "hello", "hi"]):
        return "გამარჯობა! 🎸 მე აკუსტიკის ასისტენტი ვარ. რით შემიძლია დაგეხმარო?"
    
    if any(w in msg for w in ["საათ", "სამუშაო", "როდის", "ღია"]):
        return "🕐 ჩვენ ვმუშაობთ: ყოველდღე 11:00-19:00\n📍 მისამართი: თბილისი, აკაკი წერეთლის 142\n📞 +995551160562"
    
    if any(w in msg for w in ["მისამართ", "სად", "მდებარე", "რუკა"]):
        return "📍 თბილისი, აკაკი წერეთლის 142\n🕐 ყოველდღე 11:00-19:00\n📞 +995551160562"
    
    if any(w in msg for w in ["კონტაქტ", "ტელეფონ", "ნომერი", "ელფოსტა", "email"]):
        return "📞 +995551160562\n📧 sales@acoustic.ge\n💬 WhatsApp: +995591229314"
    
    if any(w in msg for w in ["მიტანა", "მიწოდება", "დელივერ"]):
        return "🚚 თბილისში — იმავე დღეს, მთელ საქართველოში — 1-3 დღეში"
    
    if any(w in msg for w in ["სერვის", "შეკეთებ", "რემონტ", "გამართვ"]):
        return "🛠️ სერვისები: დასარტყამი, გიტარა/ვიოლინო, აპარატურა\n📞 დასაჯავშნად: +995551160562"
    
    if any(w in msg for w in ["რეპეტიც", "სტუდია", "სარეპეტიციო"]):
        return "🎼 სარეპეტიციო სტუდია\n📞 დასაჯავშნად: 505 050 299\n🔗 https://sheet.acoustic.ge/"
    
    # Product search
    product_keywords = ["გიტარ", "ბას", "პიანინო", "სინთეზატორ", "კლავიშ", "დასარტყამ", "მიკროფონ", "სიმი", "კაბელი", "ყურსასმენი", "ვიოლინო", "საქსაფონ", "დინამიკი", "dj", "მიქსერი"]
    if any(kw in msg for kw in product_keywords):
        results = search_products(message, products, 5)
        if results:
            parts = ["🔍 ვიპოვე:\n"]
            for p in results:
                stock = "✅" if p.get("amount",0) > 0 else "❌"
                parts.append(f"• {p['product']} | {p['price']}₾ | {stock}\n  {p.get('url','')}")
            return "\n".join(parts)
    
    return "შემიძლია დაგეხმარო:\n• 🎸 პროდუქტების მოძებნა\n• 🕐 საათები\n• 📍 მისამართი\n• 🚚 მიტანა\n• 🛠️ სერვისი\n• 📞 კონტაქტი\n• 🎼 სარეპეტიციო"


@app.route("/api/chat", methods=["POST"])
def chat():
    try:
        data = flask_request.json
        user_message = data.get("message", "")
        history = data.get("history", [])
        
        if not user_message:
            return jsonify({"error": "შეტყობინება ცარიელია"}), 400
        
        products = load_products()
        pages = load_site_pages()
        system_prompt = build_system_prompt(products, pages)
        
        # Try Gemini API first
        reply = call_gemini(system_prompt, user_message, history)
        
        if reply:
            return jsonify({"reply": reply, "source": "ai"})
        else:
            # Fallback to keyword-based
            reply = fallback_reply(user_message, products, pages)
            return jsonify({"reply": reply, "source": "fallback"})
    
    except Exception as e:
        print(f"Chat error: {e}")
        return jsonify({"reply": "შეცდომა მოხდა. გთხოვთ კიდევ სცადოთ."}), 500


@app.route("/api/refresh", methods=["POST"])
def refresh():
    """Force refresh site pages cache"""
    global _pages_cache, _pages_cache_time
    _pages_cache = {}
    _pages_cache_time = 0
    pages = load_site_pages()
    return jsonify({"status": "ok", "pages": list(pages.keys())})


@app.route("/api/products", methods=["GET"])
def products_endpoint():
    q = flask_request.args.get("q", "").lower()
    prods = load_products()
    if q:
        return jsonify([p for p in prods if q in p.get("product", "").lower()][:20])
    return jsonify(prods[:20])


@app.route("/widget.js", methods=["GET"])
def widget():
    return send_from_directory(os.path.dirname(__file__), "widget.js", mimetype="application/javascript")


@app.route("/health", methods=["GET"])
def health():
    products = load_products()
    pages = load_site_pages()
    return jsonify({
        "status": "ok", 
        "products": len(products),
        "pages": {k: len(v) for k, v in pages.items()},
        "gemini_key": GEMINI_API_KEY[:10] + "..." if GEMINI_API_KEY else "none"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5560, debug=False)
