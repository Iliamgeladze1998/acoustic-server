#!/bin/bash
OUT=/root/agoda-audit/recon/api_tests8.txt
> "$OUT"
{
echo "=== /cars/graphql ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/cars/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"query{__typename}"}' 2>&1 | head -c 1000
echo
echo "=== GraphQL query with activitySearch ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"query{activitySearch{__typename}}"}' 2>&1 | head -c 1000
echo
echo "=== Flights BFF search ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/flights-bff/search/v1/flights' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{}' 2>&1 | head -c 1000
echo
echo "=== Flights BFF top-routes ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/flights-bff/search/v1/top-routes' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 1000
echo
echo "=== Flights BFF location ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/flights-bff/content/v1/location?keyword=Bangkok' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 1000
echo
echo "=== Flights BFF calendar ==="
curl -sS --max-time 15 --compressed 'https://www.agoda.com/api/flights-bff/calendar/v1/prices?origin=BKK&destination=DMK' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' 2>&1 | head -c 1000
echo
echo "=== UpdateConsentConfiguration POST ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/cronos/mkt/UpdateConsentConfiguration' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{}' 2>&1 | head -c 500
echo
} >> "$OUT" 2>&1
