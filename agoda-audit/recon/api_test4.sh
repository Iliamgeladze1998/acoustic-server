#!/bin/bash
OUT=/root/agoda-audit/recon/api_tests4.txt
> "$OUT"
{
echo "=== GraphQL introspection ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"query":"{__schema{types{name fields{name}}}}"}' 2>&1 | head -c 2000
echo
echo "=== GraphQL simple query ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"query":"query{__typename}"}' 2>&1 | head -c 500
echo
echo "=== /api/cart/items (GET) ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cart/items' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 800
echo
echo "=== /api/saved/retrieve (GET) ==="
curl -sS --max-time 15 'https://www.agoda.com/api/saved/retrieve' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 800
echo
echo "=== /api/cronos/partnermember/partnerdata ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cronos/partnermember/partnerdata' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 800
echo
echo "=== /api/cronos/layout/PageHeaderApi/UserMenuViewModel ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cronos/layout/PageHeaderApi/UserMenuViewModel' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 800
echo
echo "=== /api/cronos/mkt/GetConsentBanner ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cronos/mkt/GetConsentBanner' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 800
echo
echo "=== /api/popup/campaigns ==="
curl -sS --max-time 15 'https://www.agoda.com/api/popup/campaigns' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 800
echo
} >> "$OUT" 2>&1
