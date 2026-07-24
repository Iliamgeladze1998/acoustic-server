#!/usr/bin/env python3
"""
Analyze roulette archive passwords for patterns.
All passwords are 66 chars, use printable ASCII special chars.
"""

passwords = [
    'zJm3gE3F(DKnyP)7a!;@d*9=GV4%rcsXAL)&TEWVU8ZN2SA%Xw\\Pgcx*m?fuG7^Q3(',
    'V+53sA!7T8$b)uEp^Bx4q9t3Lyc6X2aDse#La4N3sD\\27PYmQAGZEbFVfcB4z*+T;h',
    'eA7REDF=sp*q35?g;2\\%#x/9B@#umdj^MyJ#6?7*f%UzmhWQ^\\=!RZG+2xbKBstv:3',
]

import string
from collections import Counter

for i, pw in enumerate(passwords):
    print(f"\n=== Password {i+1} (len={len(pw)}) ===")
    print(f"  Value: {pw}")
    
    # Character classes
    upper = sum(1 for c in pw if c.isupper())
    lower = sum(1 for c in pw if c.islower())
    digit = sum(1 for c in pw if c.isdigit())
    special = sum(1 for c in pw if not c.isalnum())
    
    print(f"  Upper: {upper}, Lower: {lower}, Digit: {digit}, Special: {special}")
    
    # Character frequency
    freq = Counter(pw)
    print(f"  Unique chars: {len(freq)}")
    print(f"  Most common: {freq.most_common(5)}")
    
    # Check for patterns
    has_seq = False
    for j in range(len(pw)-2):
        if ord(pw[j])+1 == ord(pw[j+1]) and ord(pw[j+1])+1 == ord(pw[j+2]):
            has_seq = True
            print(f"  Sequential at pos {j}: {pw[j]}{pw[j+1]}{pw[j+2]}")
    
    # Check char set
    chars_used = set(pw)
    all_special = set(string.printable) - set(string.ascii_letters) - set(string.digits)
    special_used = chars_used & all_special
    print(f"  Special chars used: {''.join(sorted(special_used))}")

# Compare passwords
print("\n=== Comparison ===")
for i in range(len(passwords)-1):
    pw1, pw2 = passwords[i], passwords[i+1]
    same_pos = sum(1 for a, b in zip(pw1, pw2) if a == b)
    print(f"  PW{i+1} vs PW{i+2}: {same_pos} chars same at same position")

# Check if passwords could be base64 or similar encoding
import base64
for i, pw in enumerate(passwords):
    try:
        decoded = base64.b64decode(pw)
        print(f"  PW{i+1} base64 decode: {decoded[:20]}...")
    except:
        pass
    try:
        decoded = base64.b64decode(pw + '==')
        print(f"  PW{i+1} base64 decode (padded): {decoded[:20]}...")
    except:
        pass

# Check if they could be random generated with a seed
# Look for month-related patterns
months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', '01', '02', '03', '04', '2026']
for i, pw in enumerate(passwords):
    for m in months:
        if m.lower() in pw.lower():
            print(f"  PW{i+1} contains '{m}' at pos {pw.lower().index(m.lower())}")

print("\n=== Conclusion ===")
print("Passwords appear to be randomly generated 66-char strings.")
print("No obvious pattern between months.")
print("Brute force of 66-char random password is infeasible.")
print("The only viable approach is:")
print("1. Wait for password publication after month ends")
print("2. Find a server-side vulnerability to access pre-generated numbers")
print("3. Check if the fairness system has a bug (e.g., hash leaks)")
