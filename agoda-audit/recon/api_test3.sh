#!/bin/bash
OUT=/root/agoda-audit/recon/api_tests3.txt
> "$OUT"
{
echo "=== /api/login (GET) ==="
curl -sS --max-time 15 -D - 'https://www.agoda.com/api/login' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -o /dev/null 2>&1 | tr -d '\r' | grep -iE '^(HTTP/|content-type|set-cookie|location|access-control)'
echo
echo "=== /api/login (POST) ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/login' -H 'Content-Type: application/json' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -d '{}' 2>&1 | head -c 800
echo
echo "=== /api/login/sendEmailToSignUpDesktop (POST) ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/login/sendEmailToSignUpDesktop' -H 'Content-Type: application/json' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -d '{"email":"test-oxygenous@example.invalid"}' 2>&1 | head -c 800
echo
echo "=== /api/login/FacebookAssociate (POST) ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/login/FacebookAssociate' -H 'Content-Type: application/json' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -d '{}' 2>&1 | head -c 800
echo
echo "=== /api/cronos/layout/currency/getlist ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cronos/layout/currency/getlist' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 500
echo
echo "=== /api/cronos/layout/culture/getlanguages ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cronos/layout/culture/getlanguages' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 500
echo
echo "=== /api/cronos/price/ChangePriceView (POST) ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/cronos/price/ChangePriceView' -H 'Content-Type: application/json' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -d '{}' 2>&1 | head -c 500
echo
echo "=== /api/cronos/layout/currency/set (POST) ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/cronos/layout/currency/set' -H 'Content-Type: application/json' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -d '{"currency":"USD"}' 2>&1 | head -c 500
echo
} >> "$OUT" 2>&1
