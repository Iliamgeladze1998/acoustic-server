#!/bin/bash
OUT=/root/agoda-audit/recon/api_tests2.txt
> "$OUT"
{
echo "=== savepointsmax with fields ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/cronos/pointsmax/savepointsmax' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"memberProgramId":1,"providerCode":"test","membershipId":"test123"}'
echo
echo "=== insertmembership with fields ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/cronos/loyaltyexternal/insertmembership' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"providerCode":"test","membershipId":"test123","userId":"test"}'
echo
echo "=== addfavoritehotel with userId ==="
curl -sS --max-time 15 -X POST 'https://www.agoda.com/api/cronos/favorite/addfavoritehotel' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -d '{"hotelId":12345,"userId":"test"}'
echo
echo "=== getmemberprograms ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cronos/pointsmax/getmemberprograms' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
echo
echo "=== search redirect ==="
curl -sS --max-time 15 -D - 'https://www.agoda.com/api/cronos/search/redirect' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' -o /dev/null
echo
echo "=== GetHotCities ==="
curl -sS --max-time 15 'https://www.agoda.com/api/cronos/layout/GetHotCities' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' | head -c 500
echo
echo "=== campaigns ==="
curl -sS --max-time 15 'https://www.agoda.com/api/card/campaigns' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' | head -c 500
echo
} >> "$OUT" 2>&1
