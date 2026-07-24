#!/bin/bash
OUT=/root/agoda-audit/recon/api_tests5.txt
> "$OUT"
{
echo "=== GraphQL --compressed ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'Accept-Encoding: gzip, deflate, br' \
  -d '{"query":"query{__typename}"}' 2>&1 | head -c 2000
echo
echo "=== GraphQL introspection --compressed ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'Accept-Encoding: gzip, deflate, br' \
  -d '{"query":"{__schema{queryType{name}types{name fields{name type{name}}}}"}' 2>&1 | head -c 3000
echo
echo "=== Flights search ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/flights-bff/search/v1/top-routes?origin=BKK&destination=DMK' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 1000
echo
echo "=== Flights location ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/flights-bff/content/v1/location?keyword=Bangkok' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 1000
echo
echo "=== /api/cart/items with CORS test ==="
curl -sS --max-time 15 -H 'Origin: https://evil.com' -D - 'https://www.agoda.com/api/cart/items' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -o /dev/null 2>&1 | tr -d '\r' | grep -iE '^(HTTP/|access-control|content-type)'
echo
echo "=== /api/saved/retrieve with CORS test ==="
curl -sS --max-time 15 -H 'Origin: https://evil.com' -D - 'https://www.agoda.com/api/saved/retrieve' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -o /dev/null 2>&1 | tr -d '\r' | grep -iE '^(HTTP/|access-control|content-type)'
echo
echo "=== UserMenuViewModel with CORS ==="
curl -sS --max-time 15 -H 'Origin: https://evil.com' -D - 'https://www.agoda.com/api/cronos/layout/PageHeaderApi/UserMenuViewModel' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -o /dev/null 2>&1 | tr -d '\r' | grep -iE '^(HTTP/|access-control|content-type)'
echo
} >> "$OUT" 2>&1
