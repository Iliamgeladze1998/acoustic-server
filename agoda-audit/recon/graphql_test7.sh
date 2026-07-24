#!/bin/bash
OUT=/root/agoda-audit/recon/graphql_test7.txt
> "$OUT"
{
echo "=== search complete query ==="
curl -sS --max-time 15 --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"query{search(SearchRequest:{context:{currency:\"USD\",experimentInfo:{}},searchRequest:{searchType:CITY,searchValue:\"Bangkok\",searchCriteria:{pagination:{size:10,number:0},sort:{},filters:{valueFilters:[],rangeFilters:[]}}}}){__typename}}"}' 2>&1 | head -c 3000
echo
} >> "$OUT" 2>&1
