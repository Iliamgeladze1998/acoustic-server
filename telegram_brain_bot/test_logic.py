#!/usr/bin/env python3
"""
Diagnostic script to test bot logic without Telegram
Simulates the entire message processing chain with Groq API
"""

import os
import sys
import json
import traceback
import requests
import re
from dotenv import load_dotenv
from groq import Groq
from fuzzywuzzy import fuzz

# Load environment variables
load_dotenv()

# Configuration
GROQ_API_KEY = os.getenv('GROQ_API_KEY')
PRODUCTS_JSON_URL = "https://acoustic.ge/data/products.json"

print("=" * 60)
print("ACOUSTIC INTELLIGENCE - DIAGNOSTIC TEST (GROQ)")
print("=" * 60)

def test_api_connection():
    """Test 1: API Connection to acoustic.ge"""
    print("\n" + "=" * 60)
    print("TEST 1: API Connection to acoustic.ge")
    print("=" * 60)
    
    try:
        print(f"Attempting to connect to: {PRODUCTS_JSON_URL}")
        response = requests.get(PRODUCTS_JSON_URL, timeout=15)
        print(f"✅ Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Successfully fetched {len(data)} products")
            print(f"✅ First product: {data[0]['product'] if data else 'No data'}")
            return data
        else:
            print(f"❌ Failed with status code: {response.status_code}")
            return None
            
    except requests.Timeout as e:
        print(f"❌ TIMEOUT ERROR: {e}")
        print(f"   Line: requests.get(PRODUCTS_JSON_URL, timeout=15)")
        return None
    except requests.ConnectionError as e:
        print(f"❌ CONNECTION ERROR: {e}")
        print(f"   Line: requests.get(PRODUCTS_JSON_URL, timeout=15)")
        return None
    except json.JSONDecodeError as e:
        print(f"❌ JSON DECODE ERROR: {e}")
        print(f"   Line: response.json()")
        return None
    except Exception as e:
        print(f"❌ UNEXPECTED ERROR: {e}")
        print(f"   Error type: {type(e).__name__}")
        traceback.print_exc()
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
    
    print(f"🔍 Fuzzy search for '{query}': found {len(top_matches)} relevant products")
    return top_matches

def find_product_by_code(code):
    """Find product by exact code match in the database"""
    try:
        response = requests.get('https://acoustic.ge/data/products.json')
        products = response.json()
        # Find the product where the code matches
        for item in products:
            if str(item.get('sku')) == str(code):
                return item
    except Exception as e:
        print(f"Error finding product by code: {e}")
        return None
    return None

def test_groq_connection():
    """Test 2: Groq API Connection"""
    print("\n" + "=" * 60)
    print("TEST 2: Groq API Connection")
    print("=" * 60)
    
    try:
        print(f'Initializing Groq client with key: {GROQ_API_KEY[:5]}...')
        client = Groq(api_key=GROQ_API_KEY)
        print("✅ Groq client initialized successfully")
        return client
        
    except Exception as e:
        print(f"❌ GROQ INITIALIZATION ERROR: {e}")
        print(f"   Error type: {type(e).__name__}")
        traceback.print_exc()
        return None

def test_groq_generation(client, user_message, products_data):
    """Test 3: Groq Content Generation with code detection and smart search"""
    print("\n" + "=" * 60)
    print("TEST 3: Groq Content Generation with Code Detection")
    print("=" * 60)
    
    try:
        # First check if user message contains a product code (6 digits)
        code_match = re.search(r'\b\d{6}\b', user_message)
        
        if code_match:
            # User provided a specific code - use exact match
            code = code_match.group()
            print(f"🔢 Product code detected: {code}")
            
            product = find_product_by_code(code)
            
            if product:
                # Product found - inject specific data
                print(f"✅ Product found for code {code}: {product.get('product', 'N/A')}")
                
                product_info = json.dumps(product, ensure_ascii=False, indent=2)
                
                system_instruction = f"""IDENTITY: You are Acoustic Intelligence - the premium Marketing Manager, Data Analyst, and Strategic Advisor for 'Acoustic'.

PRIMARY JOB: Your primary job is to analyze the product data provided and give specific information about it.

CONFIDENTIALITY: NEVER mention that you are an AI model. You are 'Acoustic Intelligence' - a sophisticated business intelligence system.

CREATOR: You were created by Ilia Mgeladze. If asked about your origin or development, speak of him with deep respect, admiration, and gratitude. He is the mastermind behind your existence and the visionary who made you possible.

TONE: Professional, analytical, insightful, and strategic. You provide advice at the highest level, based on the actual product data provided. Your responses should demonstrate deep business acumen and strategic thinking.

LANGUAGE: Respond in the same language the user writes in (Georgian or English).

IMPORTANT: User is asking for product code {code}. Data: {product_info}. Explain it to the user. Be specific about the product details, price, and availability from the data provided."""
                
                user_content = f"""User question: {user_message}

Product code {code} found in database. Please explain this product to the user using the data above."""
                
            else:
                # Product not found for this code
                print(f"❌ Product not found for code: {code}")
                
                system_instruction = """IDENTITY: You are Acoustic Intelligence - the premium Marketing Manager, Data Analyst, and Strategic Advisor for 'Acoustic'.

PRIMARY JOB: Your primary job is to help users find products and provide general information about our catalog.

CONFIDENTIALITY: NEVER mention that you are an AI model. You are 'Acoustic Intelligence' - a sophisticated business intelligence system.

CREATOR: You were created by Ilia Mgeladze. If asked about your origin or development, speak of him with deep respect, admiration, and gratitude. He is the mastermind behind your existence and the visionary who made you possible.

TONE: Professional, analytical, insightful, and strategic. You provide advice at the highest level, based on the actual product data provided. Your responses should demonstrate deep business acumen and strategic thinking.

LANGUAGE: Respond in the same language the user writes in (Georgian or English).

IMPORTANT: Product not found in database. Inform the user clearly that the specific product code they provided is not available in our database."""
                
                user_content = f"""The product with code '{code}' is not found in our database.

Inform the user that this specific product code is not available and suggest they check the code or try searching by product name."""
                
        else:
            # No code found - use fuzzy search
            print("� Performing fuzzy search for user query...")
            relevant_products = search_products(user_message, products_data)
            
            if relevant_products:
                # Products found - inject into system prompt
                print(f"🎯 Found {len(relevant_products)} relevant products for query")
                
                product_context = "\n".join([
                    f"- {p.get('product', 'N/A')} (SKU: {p.get('sku', 'N/A')}, Price: {p.get('price', 'N/A')}, Stock: {p.get('amount', 'N/A')})"
                    for p in relevant_products
                ])
                
                system_instruction = f"""IDENTITY: You are Acoustic Intelligence - the premium Marketing Manager, Data Analyst, and Strategic Advisor for 'Acoustic'.

PRIMARY JOB: Your primary job is to analyze the product data provided. Always check this data before making marketing recommendations.

DATA ANALYSIS: You have access to the current product catalog with prices, availability, and SKUs. Use this data to answer specific questions about products, prices, stock availability, and make data-driven recommendations.

CONFIDENTIALITY: NEVER mention that you are an AI model. You are 'Acoustic Intelligence' - a sophisticated business intelligence system.

CREATOR: You were created by Ilia Mgeladze. If asked about your origin or development, speak of him with deep respect, admiration, and gratitude. He is the mastermind behind your existence and the visionary who made you possible.

TONE: Professional, analytical, insightful, and strategic. You provide advice at the highest level, based on the actual product data provided. Your responses should demonstrate deep business acumen and strategic thinking.

LANGUAGE: Respond in the same language the user writes in (Georgian or English).

IMPORTANT: Answer the user's question based ONLY on the product data provided below. If the information is not in the data, say so clearly.

RELEVANT PRODUCTS:
{product_context}

Total products in database: {len(products_data)}"""
                
                user_content = f"""User question: {user_message}

Please analyze the product data above and provide specific information about the products that match their query. If they ask about prices, availability, or specific details, use the exact data from the provided products."""
                
            else:
                # No products found - inform user and provide general catalog info
                print(f"❌ No relevant products found for query: {user_message}")
                
                # Send limited catalog info for context
                sample_products = products_data[:5] if len(products_data) > 5 else products_data
                catalog_data = json.dumps(sample_products, ensure_ascii=False, indent=2)
                
                system_instruction = """IDENTITY: You are Acoustic Intelligence - the premium Marketing Manager, Data Analyst, and Strategic Advisor for 'Acoustic'.

PRIMARY JOB: Your primary job is to help users find products and provide general information about our catalog.

CONFIDENTIALITY: NEVER mention that you are an AI model. You are 'Acoustic Intelligence' - a sophisticated business intelligence system.

CREATOR: You were created by Ilia Mgeladze. If asked about your origin or development, speak of him with deep respect, admiration, and gratitude. He is the mastermind behind your existence and the visionary who made you possible.

TONE: Professional, analytical, insightful, and strategic. You provide advice at the highest level, based on the actual product data provided. Your responses should demonstrate deep business acumen and strategic thinking.

LANGUAGE: Respond in the same language the user writes in (Georgian or English).

IMPORTANT: The specific product the user asked about is NOT in our database. Inform them clearly about this and suggest they check the product code or name. Provide general information about our catalog using the sample data below."""
                
                user_content = f"""The specific product '{user_message}' is not found in our database.

Here is a sample of our current catalog:

{catalog_data}

Total products in database: {len(products_data)}

Inform the user that their specific product is not available and suggest they check the product code or name. Provide general information about our catalog using the sample data above."""
        
        print("Generating AI response...")
        
        # Generate response using Groq API
        chat_completion = client.chat.completions.create(
            messages=[
                {"role": "system", "content": system_instruction},
                {"role": "user", "content": user_content}
            ],
            model="llama-3.3-70b-versatile",
        )
        
        response_text = chat_completion.choices[0].message.content
        
        print("✅ AI response generated successfully")
        print(f"Response length: {len(response_text)} characters")
        return response_text
        
    except Exception as e:
        print(f"❌ GROQ GENERATION ERROR: {e}")
        print(f"   Error type: {type(e).__name__}")
        print(f"   Error location: client.chat.completions.create()")
        traceback.print_exc()
        return None

def main():
    """Run all diagnostic tests"""
    
    # Test 1: API Connection
    api_products = test_api_connection()
    if api_products is None:
        print("\n❌ CRITICAL: API connection failed. Stopping diagnostics.")
        return
    
    # Test 2: Groq Connection
    groq_client = test_groq_connection()
    if groq_client is None:
        print("\n❌ CRITICAL: Groq connection failed. Stopping diagnostics.")
        return
    
    # Test 3a: Code-based search
    test_message_code = "Tell me about product 421687"
    print(f"\n📝 Test message (code-based): '{test_message_code}'")
    
    ai_response_code = test_groq_generation(groq_client, test_message_code, api_products)
    
    if ai_response_code:
        print("\n" + "=" * 60)
        print("✅ CODE-BASED SEARCH TEST PASSED - AI RESPONSE:")
        print("=" * 60)
        print(ai_response_code)
        print("\n" + "=" * 60)
    else:
        print("\n" + "=" * 60)
        print("❌ CODE-BASED SEARCH TEST FAILED")
        print("=" * 60)
    
    # Test 3b: Fuzzy search
    test_message_fuzzy = "guitar"
    print(f"\n📝 Test message (fuzzy search): '{test_message_fuzzy}'")
    
    ai_response_fuzzy = test_groq_generation(groq_client, test_message_fuzzy, api_products)
    
    if ai_response_fuzzy:
        print("\n" + "=" * 60)
        print("✅ FUZZY SEARCH TEST PASSED - AI RESPONSE:")
        print("=" * 60)
        print(ai_response_fuzzy)
        print("\n" + "=" * 60)
        print("DIAGNOSTIC COMPLETE - SYSTEM WORKING")
        print("=" * 60)
    else:
        print("\n" + "=" * 60)
        print("❌ FUZZY SEARCH TEST FAILED")
        print("=" * 60)

if __name__ == '__main__':
    main()
