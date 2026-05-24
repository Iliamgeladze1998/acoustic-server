#!/usr/bin/env python3
"""
End-to-end verification script for the Telegram Brain Bot.

Verifies the full chain: API fetch -> code search -> AI response injection.
If the AI Output doesn't contain the correct price from Step 2, then the
system_instruction or the injection logic is broken.
"""

import sys
import requests

# Import directly from the running bot module so we test the REAL functions
sys.path.insert(0, '/root/telegram_brain_bot')
from brain_bot import find_product_by_code, generate_ai_response, initialize_groq

TEST_CODE = '434468'
TEST_MESSAGE = 'რა ღირს პროდუქტი კოდით 434468?'


def step1_raw_fetch():
    print("=" * 70)
    print("STEP 1: Raw Fetch Check")
    print("=" * 70)
    data = requests.get('https://acoustic.ge/data/products.json').json()
    print(f"API Fetch Successful. Total products: {len(data)}")
    return data


def step2_logic_test(data):
    print()
    print("=" * 70)
    print("STEP 2: Logic Test (find_product_by_code)")
    print("=" * 70)
    result = find_product_by_code(TEST_CODE, data)
    print(f"Search result for {TEST_CODE}: {result}")
    return result


def step3_ai_response_test(data, expected_product):
    print()
    print("=" * 70)
    print("STEP 3: AI Response Test")
    print("=" * 70)
    print(f"Dummy prompt: {TEST_MESSAGE!r}")
    client = initialize_groq()
    if client is None:
        print("FATAL: Could not initialize Groq client")
        return None
    ai_response = generate_ai_response(TEST_MESSAGE, data, client)
    print(f"AI Output: {ai_response}")
    return ai_response


def verdict(product, ai_response):
    print()
    print("=" * 70)
    print("VERDICT")
    print("=" * 70)
    if product is None:
        print(f"❌ Step 2 failed: code {TEST_CODE} not found in API data.")
        print("   Cannot verify the injection - the code itself doesn't exist.")
        return
    expected_price = str(product.get('price', ''))
    print(f"Expected price from JSON: {expected_price}")
    if ai_response is None:
        print("❌ Step 3 failed: no AI response.")
        return
    if expected_price and expected_price in ai_response:
        print(f"✅ PASS: AI output contains the correct price '{expected_price}'.")
        print("   The system_instruction and injection logic are working correctly.")
    else:
        print(f"❌ FAIL: AI output does NOT contain the expected price '{expected_price}'.")
        print("   The system_instruction or injection logic is broken.")


if __name__ == '__main__':
    data = step1_raw_fetch()
    product = step2_logic_test(data)
    ai_response = step3_ai_response_test(data, product)
    verdict(product, ai_response)
