#!/usr/bin/env python3
"""
Telegram Brain Bot with AI Integration
Integrates Telegram bot with Google Gemini AI for intelligent responses
Uses external JSON API and Google Sheets as knowledge base for business context
"""

import os
import json
import logging
import requests
import re
from dotenv import load_dotenv
from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ContextTypes
from groq import Groq
from fuzzywuzzy import fuzz

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Configuration
TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')
GROQ_API_KEY = os.getenv('GROQ_API_KEY')
PRODUCTS_JSON_URL = "https://acoustic.ge/data/products.json"

# Base system instruction used for ALL queries - contains permanent store knowledge
BASE_SYSTEM_INSTRUCTION = '''
You are a helpful shop assistant for Acoustic.ge.

CORE RULE: All product data below was fetched LIVE from acoustic.ge moments ago. NEVER rely on memory or guess product info. If product data is provided in the SEARCH RESULT section, quote it verbatim. If no product data is provided (CONVERSATION MODE), respond naturally as a friendly shop assistant - use the OFFICIAL STORE INFORMATION for address/phone questions, or just chat normally. Do NOT force product search into general conversations.

OFFICIAL STORE INFORMATION:
- Name: Acoustic.ge (აკუსტიკა)
- Address: 142 Akaki Tsereteli Ave, Tbilisi, Georgia
- Phone: +995 551 160 562
- Email: sales@acoustic.ge
- Working Hours: 11:00 - 19:00
- Website: https://acoustic.ge

RULES:
1. Product Data Priority: If PRODUCT DATA FOUND IN JSON appears below, ALWAYS use it. Quote exact prices, SKUs, and stock levels directly from the JSON. Never make up prices.
2. Store Info Fallback: If no product data was found and the customer asks about the store (address, hours, phone), use the OFFICIAL STORE INFORMATION above.
3. Greeting: Greet politely as a friendly shop assistant. Do NOT mention being a 'marketing strategist' or 'intelligence agent'.
4. Uncertainty: If you cannot help, say: 'სამწუხაროდ, ამ საკითხზე ზუსტი ინფორმაცია არ მაქვს. გთხოვთ, დაუკავშირდეთ ჩვენს გაყიდვების გუნდს sales@acoustic.ge-ზე ან დაგვირეკეთ ნომერზე +995 551 160 562 და დაგეხმარებიან.'
5. Tone: Friendly, customer-focused, and helpful. Like a polite shop assistant.
6. Language: Respond in the same language the user writes in (Georgian or English).
'''

# Keywords that EXPLICITLY request product search - only search when these are present
PRODUCT_SEARCH_KEYWORDS = [
    # English
    'price', 'cost', 'how much', 'search', 'find', 'look for',
    'product', 'item', 'instrument', 'guitar', 'piano', 'drum',
    # Georgian
    'ფასი', 'ღირს', 'პროდუქტი', 'მოძებნე', 'ეძება', 'გიტარა',
    'პიანინო', 'დრამი', 'ინსტრუმენტი'
]

# Keywords that indicate a general store query (not a product search)
GENERAL_QUERY_KEYWORDS = [
    # English
    'address', 'location', 'where', 'phone', 'contact', 'hours', 'open',
    'closed', 'email', 'website', 'store', 'shop',
    # Georgian
    'მისამართი', 'სად', 'ტელეფონი', 'კონტაქტი', 'საათები', 'ღია',
    'დაკეტილი', 'ფოსტა', 'მაღაზია', 'ვებსაიტი', 'სამუშაო'
]

def is_product_search_request(user_message):
    """Check if user is EXPLICITLY asking for product search/info."""
    message_lower = user_message.lower()
    for keyword in PRODUCT_SEARCH_KEYWORDS:
        if keyword.lower() in message_lower:
            logger.info(f"🔍 Product search request detected (keyword: '{keyword}')")
            return True
    return False

def is_general_query(user_message):
    """Check if user message is a general store query (not a product search)"""
    message_lower = user_message.lower()
    for keyword in GENERAL_QUERY_KEYWORDS:
        if keyword.lower() in message_lower:
            logger.info(f"🏪 General query detected (keyword: '{keyword}')")
            return True
    return False

def local_fallback(user_message):
    """Check for specific keywords and return static responses without calling AI.
    Returns None if no match, allowing the AI to handle it.
    Only applies to general store info (address, phone, website), NOT product queries.
    """
    message_lower = user_message.lower()
    
    # Skip local fallback if this is a product search request
    if is_product_search_request(user_message):
        return None
    
    # Address queries
    if 'მისამართი' in message_lower or 'სად არის მაღაზია' in message_lower:
        logger.info("🏪 Local fallback: address query")
        return 'ჩვენი მაღაზია მდებარეობს: 142 აკაკი წერეთლის გამზირი. გელოდებით!'
    
    # Phone queries
    if 'ტელეფონი' in message_lower or 'ნომერი' in message_lower:
        logger.info("🏪 Local fallback: phone query")
        return 'დაგვირეკეთ: +995 551 160 562'
    
    # Website queries
    if 'საიტი' in message_lower:
        logger.info("🏪 Local fallback: website query")
        return 'ეწვიეთ ჩვენს საიტს: https://acoustic.ge'
    
    return None

def search_products(query, all_products):
    """Search for products using fuzzy matching, return top 5 relevant matches"""
    if not all_products:
        return []
    
    query = query.strip().lower()
    matches = []
    
    # Score each product using fuzzy matching
    for product in all_products:
        product_name = product.get('product', '')
        sku = product.get('sku', '')
        
        # Calculate fuzzy match scores
        sku_score = fuzz.ratio(query, sku.lower()) if sku else 0
        name_score = fuzz.partial_ratio(query, product_name.lower()) if product_name else 0
        
        # Use the higher score
        best_score = max(sku_score, name_score)
        
        if best_score > 60:  # Threshold for relevance
            matches.append({'score': best_score, 'product': product})
    
    # Sort by score and return top 5
    matches.sort(key=lambda x: x['score'], reverse=True)
    top_matches = [match['product'] for match in matches[:5]]
    
    logger.info(f"🔍 Fuzzy search for '{query}': found {len(top_matches)} relevant products")
    return top_matches

def find_product_by_code(code, products):
    """Find product by exact SKU match in the already-fetched product list.
    
    Uses the live data already retrieved by mandatory_fetch_products() this
    request - does NOT make a second API call.
    """
    if not products:
        return None
    for item in products:
        if str(item.get('sku')) == str(code):
            return item
    return None

def mandatory_fetch_products():
    """MANDATORY API FETCH - called at the start of EVERY message.
    
    This function MUST be called before any response logic runs. It makes a
    fresh live request to acoustic.ge/data/products.json every single time.
    
    Returns:
        tuple: (data, error_message)
            - On success: (list_of_products, None)
            - On failure: (None, georgian_error_message)
    """
    try:
        response = requests.get('https://acoustic.ge/data/products.json', timeout=15)
        response.raise_for_status()
        data = response.json()
        # Forced log - REQUIRED to verify the fetch happened
        print(f'FETCHED {len(data)} PRODUCTS FROM API')
        logger.info(f"FETCHED {len(data)} PRODUCTS FROM API")
        return data, None
    except requests.Timeout as e:
        logger.error(f"❌ MANDATORY FETCH FAILED (timeout): {e}")
    except requests.ConnectionError as e:
        logger.error(f"❌ MANDATORY FETCH FAILED (connection): {e}")
    except requests.HTTPError as e:
        logger.error(f"❌ MANDATORY FETCH FAILED (HTTP): {e}")
    except requests.RequestException as e:
        logger.error(f"❌ MANDATORY FETCH FAILED (request): {e}")
    except json.JSONDecodeError as e:
        logger.error(f"❌ MANDATORY FETCH FAILED (JSON decode): {e}")
    except Exception as e:
        logger.error(f"❌ MANDATORY FETCH FAILED (unexpected): {e}")
    
    # NO FALLBACK to local cache - if the live API is down, the bot MUST
    # tell the user and not guess from stale or internal knowledge.
    error_msg = (
        "სამწუხაროდ, ამ წუთას პროდუქტების მონაცემებს ვერ ვუკავშირდები. "
        "გთხოვთ სცადოთ მოგვიანებით ან დაგვირეკეთ ნომერზე +995 551 160 562."
    )
    return None, error_msg

# Backwards-compat alias (in case other code paths still reference it)
def get_latest_data():
    data, _ = mandatory_fetch_products()
    return data if data is not None else []



def initialize_groq():
    """Initialize Groq AI client"""
    try:
        print(f'Initializing Groq client with key: {GROQ_API_KEY[:5]}...')
        logger.info(f'Initializing Groq client with key: {GROQ_API_KEY[:5]}...')
        
        client = Groq(api_key=GROQ_API_KEY)
        
        print("✅ Groq AI initialized successfully")
        logger.info("Groq AI initialized successfully")
        return client
        
    except Exception as e:
        print(f"❌ Failed to initialize Groq: {e}")
        logger.error(f"Failed to initialize Groq: {e}")
        return None

def format_product_directly(product):
    """Format a single product as a Georgian customer reply, WITHOUT calling AI.
    Used as a fallback when Groq is unavailable but we already have the data.
    """
    name = product.get('product', 'N/A')
    sku = product.get('sku', 'N/A')
    price = product.get('price', 'N/A')
    amount = product.get('amount', 0)
    url = product.get('url', '')
    
    try:
        amount_int = int(amount)
    except (ValueError, TypeError):
        amount_int = 0
    stock_line = (
        f"✅ მარაგშია ({amount_int} ერთეული)" if amount_int > 0
        else "❌ ამჟამად მარაგში არ არის"
    )
    
    lines = [
        f"🎵 {name}",
        f"კოდი: {sku}",
        f"ფასი: {price} ₾",
        stock_line,
    ]
    if url:
        lines.append(f"🔗 {url}")
    return "\n".join(lines)


def format_products_list_directly(products):
    """Format multiple products as a compact Georgian list (no AI)."""
    lines = ["აი რასაც ვიპოვე ჩვენს კატალოგში:\n"]
    for p in products[:5]:
        name = p.get('product', 'N/A')
        sku = p.get('sku', 'N/A')
        price = p.get('price', 'N/A')
        amount = p.get('amount', 0)
        try:
            amount_int = int(amount)
        except (ValueError, TypeError):
            amount_int = 0
        stock = f"მარაგი: {amount_int}" if amount_int > 0 else "მარაგშია არაა"
        lines.append(f"• {name}\n  კოდი: {sku} | ფასი: {price} ₾ | {stock}")
    lines.append("\nუფრო კონკრეტული პროდუქტისთვის გამომიგზავნეთ მისი 6-ნიშნა კოდი.")
    return "\n".join(lines)


def generate_ai_response(user_message, products_data, client):
    """Generate AI response using Groq.
    
    SEPARATION OF LOGIC AND TONE:
    - LOCAL FALLBACK: Check for static keyword responses first
    - STEP A: Search logic runs FIRST (code -> exact match -> fuzzy fallback)
    - STEP B: Found product data is injected into system prompt
    - STEP C: Groq is told to use product data if found, store info otherwise
    
    FALLBACK: If Groq fails (rate limit, network), and we have product data
    found in STEP A, we return that data directly formatted - never lose
    information just because the AI is down.
    """
    # ============================================================
    # LOCAL FALLBACK: Check for static keyword responses
    # ============================================================
    static_response = local_fallback(user_message)
    if static_response is not None:
        return static_response
    
    # ============================================================
    # STEP A: SEARCH LOGIC - Only run when EXPLICITLY requested
    # ============================================================
    found_product_data = None
    search_log = ""
    
    # Always check for a 6-digit code FIRST - this is an explicit product request
    code_match = re.search(r'\b\d{6}\b', user_message)
    
    if code_match:
        code = code_match.group()
        print(f"🔢 Executing search by code: {code}")
        logger.info(f"🔢 STEP A: Code detected -> running find_product_by_code({code})")
        
        product = find_product_by_code(code, products_data)
        
        if product:
            print(f"✅ Product found in JSON: {product.get('product', 'N/A')}")
            logger.info(f"✅ STEP A: Product found for code {code}: {product.get('product', 'N/A')}")
            found_product_data = product
            search_log = f"Found product by code {code}"
        else:
            print(f"❌ No product matched code {code}")
            logger.info(f"❌ STEP A: No product found for code {code}")
            search_log = f"Code {code} not found in catalog"
    
    # Only do fuzzy search if user EXPLICITLY asks for product info (keywords)
    elif is_product_search_request(user_message):
        print(f"🔍 Product search request detected - running fuzzy search")
        logger.info(f"🔍 STEP A: Product search keywords detected - running fuzzy search for '{user_message}'")
        relevant_products = search_products(user_message, products_data)
        
        if relevant_products:
            print(f"✅ Fuzzy search found {len(relevant_products)} products")
            logger.info(f"✅ STEP A: Found {len(relevant_products)} relevant products")
            found_product_data = relevant_products
            search_log = f"Found {len(relevant_products)} products via fuzzy search"
        else:
            print(f"❌ Fuzzy search returned no matches")
            logger.info("❌ STEP A: No fuzzy matches")
            search_log = "No products matched query"
    
    else:
        # No code, no product keywords - skip search, let AI handle as general conversation
        print(f"💬 General conversation - skipping product search")
        logger.info("💬 STEP A: No product search request - skipping search, letting AI handle as conversation")
        search_log = "General conversation (no product search requested)"
    
    # ============================================================
    # STEP B: Build context with found data
    # ============================================================
    if found_product_data is not None:
        product_json = json.dumps(found_product_data, ensure_ascii=False, indent=2)
        context_section = f"\n\nSEARCH RESULT: {search_log}\n\nPRODUCT DATA FOUND IN JSON:\n{product_json}\n\nUse this product data to answer the customer. Quote exact prices, SKUs, and stock levels from the data above."
    else:
        # No product data - this is a general conversation, NOT a failed search
        context_section = f"\n\nCONVERSATION MODE: {search_log}\n\nThe user is having a general conversation or asking non-product questions. Be a friendly, helpful shop assistant. Answer naturally using the OFFICIAL STORE INFORMATION in your instructions. Do NOT mention products or search unless the user specifically asks."
    
    final_system_instruction = BASE_SYSTEM_INSTRUCTION + context_section
    
    # ============================================================
    # STEP C: Send to Groq with the data and instructions
    # ============================================================
    print(f'Sending system instruction to AI...')
    logger.info(f"📤 STEP C: Sending system instruction to AI ({len(final_system_instruction)} chars, product_data={'YES' if found_product_data else 'NO'})")
    
    try:
        chat_completion = client.chat.completions.create(
            messages=[
                {"role": "system", "content": final_system_instruction},
                {"role": "user", "content": user_message}
            ],
            model="llama-3.3-70b-versatile",
        )
        response_text = chat_completion.choices[0].message.content
        logger.info(f"✅ AI response generated: {len(response_text)} characters")
        return response_text
        
    except Exception as e:
        # AI call failed (rate limit, timeout, etc.) - DO NOT lose the data
        err_str = str(e)
        is_rate_limit = '429' in err_str or 'rate_limit' in err_str.lower()
        logger.error(f"Error generating AI response: {e}")
        logger.error(f"Error type: {type(e).__name__} (rate_limit={is_rate_limit})")
        
        # If we have product data, format and return it directly - no AI needed
        if found_product_data is not None:
            logger.info("🛟 AI failed but product data was found - returning direct data response")
            prefix = ""
            if is_rate_limit:
                # Try to extract reset time from the error if available
                reset_minutes = "რამდენიმე"
                if 'Please try again in' in err_str:
                    time_match = re.search(r'Please try again in (\d+)m', err_str)
                    if time_match:
                        reset_minutes = time_match.group(1)
                prefix = f"⚠️ AI ლიმიტი დროებით ამოწურულია. განახლდება დაახლოებით {reset_minutes} წუთში. მაგრამ მონაცემები ვიპოვე:\n\n"
            if isinstance(found_product_data, dict):
                return prefix + format_product_directly(found_product_data)
            elif isinstance(found_product_data, list):
                return prefix + format_products_list_directly(found_product_data)
        
        # No product data and AI down - be honest about the situation
        if is_rate_limit:
            # Try to extract reset time from the error
            reset_minutes = "რამდენიმე"
            if 'Please try again in' in err_str:
                time_match = re.search(r'Please try again in (\d+)m', err_str)
                if time_match:
                    reset_minutes = time_match.group(1)
            return (f"⚠️ AI ლიმიტი დროებით ამოწურულია. განახლდება დაახლოებით {reset_minutes} წუთში. "
                    "მანამდე შეგიძლიათ დაგვირეკოთ: +995 551 160 562.")
        return ("სამწუხაროდ, ამ წუთას ტექნიკური ხარვეზია. "
                "გთხოვთ, დაგვიკავშირდეთ: sales@acoustic.ge ან +995 551 160 562.")

async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle /start command"""
    welcome_message = """
🎵 გამარჯობა! Welcome to Acoustic.ge 🎵

I am your friendly virtual assistant for Acoustic.ge - your music instrument store in Tbilisi.

How can I help you today?
- Find musical instruments in our catalog
- Look up product details by code or name
- Get store information (address, hours, contact)

📍 Address: 142 Akaki Tsereteli Ave, Tbilisi
📞 Phone: +995 551 160 562
📧 Email: sales@acoustic.ge
🕐 Hours: 11:00 - 19:00

Feel free to ask me anything!
"""
    await update.message.reply_text(welcome_message)

async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle /help command"""
    help_message = """
📚 Available Commands:

/start - Welcome message and store info
/help - Show this help message

I can help you with:
- 🎸 Finding musical instruments in our catalog
- 🔍 Looking up products by code (6 digits) or name
- 📍 Store contact information and hours
- 💬 General questions about our products

Simply send me your question and I'll do my best to help!

For sales inquiries, contact sales@acoustic.ge or call +995 551 160 562.
"""
    await update.message.reply_text(help_message)

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Handle regular text messages with AI integration.
    
    HARD REQUIREMENT: The product API is fetched FIRST, before ANY decision
    about how to respond. If the fetch fails, the user is told immediately -
    the bot never guesses from internal/stale knowledge.
    """
    try:
        user_message = update.message.text
        user_name = update.effective_user.first_name
        
        logger.info(f"📨 Received message from {user_name}: {user_message}")
        
        # ====================================================================
        # MANDATORY DATA FETCH - happens BEFORE any other decision
        # ====================================================================
        all_products, fetch_error = mandatory_fetch_products()
        
        if fetch_error is not None:
            # API is down - tell user immediately, do NOT guess
            logger.warning("⚠️  API fetch failed - informing user, NOT guessing")
            await update.message.reply_text(fetch_error)
            return
        
        # Get AI client
        client = context.bot_data.get('groq_client')
        if not client:
            logger.error("❌ AI client not available in bot data")
            await update.message.reply_text("AI service is currently unavailable. Please try again later.")
            return
        
        # Generate typing indicator
        await update.message.chat.send_action('typing')
        
        # Generate AI response with dynamic product search
        logger.info("🧠 Generating AI response with dynamic product search...")
        ai_response = generate_ai_response(user_message, all_products, client)
        
        # Send response
        logger.info("📤 Sending response to user...")
        await update.message.reply_text(ai_response)
        logger.info("✅ Response sent successfully")
        
    except Exception as e:
        logger.error(f"❌ Error in handle_message: {e}")
        logger.error(f"Error type: {type(e).__name__}")
        logger.error(f"Error details: {str(e)}")
        
        # Send error message to user
        try:
            await update.message.reply_text("I apologize, but I encountered an error processing your request. Please try again.")
        except Exception as send_error:
            logger.error(f"❌ Failed to send error message to user: {send_error}")

def main():
    """Main function to run the bot"""
    # Validate configuration
    if not TELEGRAM_BOT_TOKEN or TELEGRAM_BOT_TOKEN == "YOUR_TELEGRAM_BOT_TOKEN_HERE":
        logger.error("TELEGRAM_BOT_TOKEN not configured in .env file")
        return
    
    if not GROQ_API_KEY:
        logger.error("GROQ_API_KEY not configured in .env file")
        return
    
    # Initialize Groq AI
    groq_client = initialize_groq()
    if not groq_client:
        logger.error("Failed to initialize Groq AI. Exiting.")
        return
    
    # Create application
    application = Application.builder().token(TELEGRAM_BOT_TOKEN).build()
    
    # Store AI client in bot data
    application.bot_data['groq_client'] = groq_client
    
    # Add handlers
    application.add_handler(CommandHandler("start", start_command))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    # Start bot
    logger.info("Starting Telegram Brain Bot...")
    logger.info("Bot operates in READ-ONLY mode - no data modifications")
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == '__main__':
    main()
