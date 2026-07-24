import subprocess, json

headers = [
    '-H', 'Content-Type: application/json',
    '-H', 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
    '-H', 'AG-LANGUAGE-LOCALE: en-us',
    '-H', 'AG-LANGUAGE-ID: 1',
    '-H', 'AG-PLATFORM-ID: 1',
    '-H', 'AG-CID: -1',
]

base_query = 'query{search(SearchRequest:{context:{currency:"USD",experimentInfo:{}},searchRequest:{searchType:CITY,searchValue:"Bangkok",searchCriteria:{pagination:{size:10,number:0},sort:{},filters:{valueFilters:[],rangeFilters:[]}}}})'

tests = [
    ("no subfields", base_query + '}'),
    ("results", base_query + '{results}}'),
    ("id", base_query + '{id}}'),
    ("name", base_query + '{name}}'),
    ("title", base_query + '{title}}'),
    ("activities", base_query + '{activities}}'),
    ("items", base_query + '{items}}'),
    ("data", base_query + '{data}}'),
    ("total", base_query + '{total}}'),
]

for label, q in tests:
    payload = json.dumps({"query": q})
    result = subprocess.run(
        ['curl', '-sS', '--max-time', '15', '--compressed', '-X', 'POST',
         'https://www.agoda.com/api/activities/graphql'] + headers +
        ['-d', payload],
        capture_output=True, text=True
    )
    print(f"=== {label} ===")
    print(result.stdout[:500])
    print()
