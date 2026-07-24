#!/bin/bash
OUT=/root/agoda-audit/recon/api_tests7.txt
> "$OUT"
{
echo "=== /api/cart/items POST with proper context ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/cart/items' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"context":{"userSettings":{"currencyCode":"USD"},"clientInfo":{"clientVersion":"1.0"}},"filter":{"status":1,"productTypes":[1]},"pagination":{"pageNumber":1,"size":10}}' 2>&1 | head -c 2000
echo
echo "=== /api/saved/retrieve POST with proper context ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/saved/retrieve' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"context":{"userSettings":{"currencyCode":"USD"},"clientInfo":{"clientVersion":"1.0"}}}' 2>&1 | head -c 2000
echo
echo "=== GraphQL with all headers ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"query{__typename}"}' 2>&1 | head -c 2000
echo
echo "=== /api/cronos/layout/GetCalendarExtrasAsync ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/cronos/layout/GetCalendarExtrasAsync/' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 500
echo
echo "=== /api/cronos/rtaheaderfooter/module ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/cronos/rtaheaderfooter/module' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 500
echo
echo "=== /api/partnerwebcomp/headerfooter/module ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/partnerwebcomp/headerfooter/module' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 500
echo
echo "=== /api/cronos/seo/base ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/cronos/seo/base' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 500
echo
echo "=== /api/contentCard/campaigns ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/contentCard/campaigns' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 500
echo
} >> "$OUT" 2>&1
