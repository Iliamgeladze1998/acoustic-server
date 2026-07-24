import re

with open('/root/heroeswm.ru/game_files/pages/allroul.html', 'rb') as f:
    data = f.read()
text = data.decode('windows-1251', errors='replace')

# Split by game ID links
parts = text.split('inforoul.php?id=')
results = []
for i, part in enumerate(parts[1:], 1):
    gid = part.split("'")[0].split('"')[0]
    # Find first bold number in this section (the result)
    m = re.search(r'<b>(\d{1,2})</b>', part[:500])
    if m:
        results.append((gid, m.group(1)))

print(f'Found {len(results)} game->number pairs')
for r in results[:30]:
    print(f'  Game {r[0]}: {r[1]}')
