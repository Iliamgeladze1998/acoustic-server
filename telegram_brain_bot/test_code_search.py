#!/usr/bin/env python3
"""
Test the new code search functionality
"""

import re
import requests

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

def test_code_detection():
    """Test regex pattern for detecting 6-digit codes"""
    test_messages = [
        "What about product 123456?",
        "I want information about 789012",
        "Tell me about guitar 345678 please",
        "No code here",
        "Code: 456789 and more text",
        "12345"  # Only 5 digits - should not match
    ]
    
    print("Testing code detection:")
    print("=" * 60)
    
    for msg in test_messages:
        code_match = re.search(r'\b\d{6}\b', msg)
        if code_match:
            print(f"✅ '{msg}' -> Code found: {code_match.group()}")
        else:
            print(f"❌ '{msg}' -> No code found")
    
    print("=" * 60)

def test_product_lookup():
    """Test actual product lookup"""
    print("\nTesting product lookup:")
    print("=" * 60)
    
    # Test with real codes from the database
    test_codes = ["421687", "123456", "789012", "000000"]
    
    for code in test_codes:
        product = find_product_by_code(code)
        if product:
            print(f"✅ Code {code}: Found - {product.get('product', 'N/A')}")
            print(f"   Price: {product.get('price', 'N/A')}, Stock: {product.get('amount', 'N/A')}")
        else:
            print(f"❌ Code {code}: Not found in database")
    
    print("=" * 60)

if __name__ == '__main__':
    test_code_detection()
    test_product_lookup()
