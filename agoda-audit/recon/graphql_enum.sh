#!/bin/bash
OUT=/root/agoda-audit/recon/graphql_enum.txt
> "$OUT"
HEADERS='-H Content-Type:application/json -H User-Agent:Mozilla/5.0 -H AG-LANGUAGE-LOCALE:en-us -H AG-LANGUAGE-ID:1 -H AG-PLATFORM-ID:1 -H AG-CID:-1'

# Try common GraphQL field names on activities endpoint
for field in activities activity activitiesSearch search products product items list bookings booking hotels hotel flights flight cars car tours tour events event experiences experience destinations destination categories category reviews review recommendations popular trending; do
  resp=$(curl -sS --max-time 10 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
    -H 'Content-Type: application/json' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
    -H 'AG-LANGUAGE-LOCALE: en-us' \
    -H 'AG-LANGUAGE-ID: 1' \
    -H 'AG-PLATFORM-ID: 1' \
    -H 'AG-CID: -1' \
    -d "{\"query\":\"query{$field{__typename}}\"}" 2>&1)
  if echo "$resp" | grep -qv "Cannot query field"; then
    echo "HIT: $field -> $resp" >> "$OUT"
  else
    echo "MISS: $field" >> "$OUT"
  fi
done

# Same for cars/graphql
echo "" >> "$OUT"
echo "=== CARS GRAPHQL ===" >> "$OUT"
for field in cars car vehicles vehicle search carsSearch products product items list bookings booking searchCars; do
  resp=$(curl -sS --max-time 10 --compressed -X POST 'https://www.agoda.com/cars/graphql' \
    -H 'Content-Type: application/json' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
    -H 'AG-LANGUAGE-LOCALE: en-us' \
    -H 'AG-LANGUAGE-ID: 1' \
    -H 'AG-PLATFORM-ID: 1' \
    -H 'AG-CID: -1' \
    -d "{\"query\":\"query{$field{__typename}}\"}" 2>&1)
  if echo "$resp" | grep -qv "Cannot query field"; then
    echo "HIT: $field -> $resp" >> "$OUT"
  else
    echo "MISS: $field" >> "$OUT"
  fi
done
