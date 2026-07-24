#!/bin/bash
OUT=/root/agoda-audit/recon/api_tests6.txt
> "$OUT"
{
echo "=== GraphQL with headers ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -d '{"query":"query{__typename}"}' 2>&1 | head -c 2000
echo
echo "=== GraphQL introspection with headers ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -d '{"query":"{__schema{queryType{name}types{name fields{name type{name}}}}"}' 2>&1 | head -c 5000
echo
echo "=== /api/cart/items POST ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/cart/items' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{}' 2>&1 | head -c 800
echo
echo "=== /api/saved/retrieve POST ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/saved/retrieve' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{}' 2>&1 | head -c 800
echo
echo "=== /api/saved/add POST ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/saved/add' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"hotelId":12345}' 2>&1 | head -c 800
echo
echo "=== /api/cart/add POST ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/cart/add' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"hotelId":12345}' 2>&1 | head -c 800
echo
} >> "$OUT" 2>&1
