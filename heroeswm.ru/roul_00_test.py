#!/usr/bin/env python3
"""
HeroesWM Roulette 0/00 Bug Verification

Place bets on BOTH 'Straight up 0' AND 'Straight up 00'
When result is 0, check which bet wins.

If BOTH win → bug confirmed, betting on 0 is profitable
If only 'Straight up 0' wins → 0 and 00 are separate, no bug
If only 'Straight up 00' wins → archive is misleading, no bug on 0
"""
import urllib.request
import urllib.parse
import time
import re
import sys

COOKIE = "PHPSESSID=8356c909f3f0a190aeeba8040c0c637f; pl_id=8777586"
HOST = "www.heroeswm.ru"
BASE = f"https://{HOST}/"

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

def place_bet(game_id, bet, bettype):
    data = {
        "parlay_dec": str(game_id),
        "minutes": "4",
        "seconds": "59",
        "bet": str(bet),
        "bettype": bettype,
        "cur_pl_bet": "0",
    }
    html = fetch(BASE + "parlay.php", data, timeout=5)
    m = re.search(r'data-hwm-topline-resource-amount="gold">\s*([^<]+)', html)
    if m:
        return int(m.group(1).replace(",", "").strip())
    return -1

def check_bets(game_id):
    """Check our bets in the game results."""
    html = fetch(f"{BASE}inforoul.php?id={game_id}", timeout=5)
    # Find all our bets
    bets = []
    for m in re.finditer(r"8777586.*?<b>(\d+)</b>.*?<td[^>]*>([^<]+)</td>.*?<b>([\d,]+)</b>", html, re.DOTALL):
        bet_amount = int(m.group(1))
        bet_type = m.group(2).strip()
        winnings = int(m.group(3).replace(",", ""))
        bets.append({"amount": bet_amount, "type": bet_type, "winnings": winnings})
    return bets

# ============================================
print("=" * 60)
print("HeroesWM 0/00 Bug Verification")
print("=" * 60)

gold_start = get_gold()
print(f"Starting gold: {gold_start}")

game_id, wait, _ = get_roulette_info()
print(f"Current game: {game_id}, wait: {wait}s")

# Place 100 on Straight up 0
print(f"\nPlacing 100g on 'Straight up 0'...")
gold_after_0 = place_bet(game_id, 100, "Straight up 0")
print(f"Gold: {gold_start} → {gold_after_0}")

if gold_after_0 < gold_start:
    print("  Bet on 0 ACCEPTED")
else:
    print("  Bet on 0 REJECTED")

# Place 100 on Straight up 00
print(f"\nPlacing 100g on 'Straight up 00'...")
gold_after_00 = place_bet(game_id, 100, "Straight up 00")
print(f"Gold: {gold_after_0} → {gold_after_00}")

if gold_after_00 < gold_after_0:
    print("  Bet on 00 ACCEPTED")
else:
    print("  Bet on 00 REJECTED")

# Wait for result
print(f"\nWaiting for result (game {game_id})...")
if wait > 10:
    print(f"Waiting {wait-5}s...")
    time.sleep(wait - 5)

# Poll for result
result = None
start = time.time()
while result is None and (time.time() - start) < 60:
    result = check_result(game_id)
    if result is None:
        time.sleep(1)

if result is None:
    print("Timeout - no result found")
    sys.exit(1)

print(f"\nResult: {result}")

# Wait for game to finalize
time.sleep(5)

# Check our bets
bets = check_bets(game_id)
print(f"\nOur bets in game {game_id}:")
for bet in bets:
    status = "WON" if bet["winnings"] > 0 else "lost"
    print(f"  {bet['amount']}g on '{bet['type']}' → {bet['winnings']}g ({status})")

# Analysis
print(f"\n{'=' * 60}")
if result == 0:
    bet_0_won = any(b["type"] == "Straight up 0" and b["winnings"] > 0 for b in bets)
    bet_00_won = any(b["type"] == "Straight up 00" and b["winnings"] > 0 for b in bets)
    
    if bet_0_won and bet_00_won:
        print("BUG CONFIRMED: Both 0 and 00 bets win when result is 0!")
        print("Betting on 0 IS profitable (2x frequency, same payout)")
    elif bet_0_won and not bet_00_won:
        print("NO BUG: Only 'Straight up 0' wins, 00 is separate")
        print("0 frequency is high because 00 is recorded as 0 in archive")
        print("But 'Straight up 0' only wins on actual 0, not 00")
    elif bet_00_won and not bet_0_won:
        print("INTERESTING: Only 'Straight up 00' wins when result shows 0")
        print("This means the result was actually 00, not 0")
    else:
        print("NEITHER won - something else happened")
else:
    print(f"Result was {result}, not 0. Need to wait for a 0 result.")
    print("Run this script again on the next game.")

gold_final = get_gold()
print(f"\nGold: {gold_start} → {gold_final} (net: {gold_final - gold_start:+d})")
print(f"{'=' * 60}")
