# JinoMusic Scraper Project — ახალი მაღაზიის დამატება

ახალი `Acoustic-JinoMusic` პროექტის შექმნა jinomusic.ge-ს დასასკრაპებლად, არსებული პროექტების პატერნის მიხედვით, Cloudflare-ის გარეშე (მარტივ `requests`-ით).

## საიტის ანალიზი

- **Cloudflare: არ არის** — nginx server, WooCommerce + WordPress, `curl`-ით პირდაპირ მუშაობს
- **ვერსია**: ინგლისური (`/en/`)
- **კატეგორიები**: guitar, drums, keyboard, audio-equipment, commutation, lighting, folk-instruments, orchestral-instrument, wind-instrument, wind-instruments
- **პროდუქტის URL**: `https://jinomusic.ge/en/product/{slug}/`
- **პროდუქტის გვერდზე** არის JSON-LD schema (`<script type="application/ld+json">`) რომელიც შეიცავს: name, price, SKU, availability, URL
- **ფასი**: `woocommerce-Price-amount` class-ში, ლარში (₾)
- **Stock**: `out-of-stock` / `in-stock` class
- **Google Sheets-ში უკვე არსებობს `JinoMusic` ტაბი**

## პროექტის სტრუქტურა

```
Acoustic-JinoMusic/
├── acjm/
│   ├── acjm_main.py              # Pipeline: scrape → merge → upload
│   ├── acjm_data_merger.py       # Acoustic vs JinoMusic მერჯინგი (model/fuzzy matching only, no ID)
│   └── acjm_sheet_uploader.py    # Google Sheets upload + Telegram alerts
├── scrapers/
│   ├── acoustic/                 # აკუსტიკის სკრაპერი (კოპირება არსებულიდან)
│   │   ├── acoustic_full_scraper.py
│   │   ├── run_acoustic.py
│   │   └── transform.py
│   └── jinomusic/
│       ├── get_category_links.py    # კატეგორიების ბმულები
│       ├── get_all_product_links.py # ყველა პროდუქტის ბმული კატეგორიებიდან
│       ├── jinomusic_scraper.py     # ინდივიდუალური პროდუქტების სკრაპინგი
│       ├── run_jinomusic.py         # მთავარი სკრაპერის runner
│       └── transform.py             # მონაცემების გასუფთავება/ნორმალიზაცია
├── credentials.json              # კოპირება არსებულიდან (იგივე Google account)
├── requirements.txt
├── venv/                         # შეიქმნება
└── reports/
```

## განსაკუთრებული ყურადღება

### მერჯინგი — განსხვავებული ლოგიკა
მომხმარებელმა აღნიშნა, რომ ID-ებით ვერ დავამთხვევთ პროდუქციას JinoMusic-ში. ამიტომ:
- **არ ვიყენებთ ID matching-ს** (როგორც Musikis-saxli/Mireli-ში)
- **მხოლოდ model/fuzzy matching** — პროდუქტის სახელის ნორმალიზაცია + fuzzywuzzy-ით მატჩინგი
- შესაძლოა ბრენდის გამოყოფა სახელიდან უკეთესი მატჩინგისთვის

### სკრაპინგი — მარტივი requests
- **Camoufox/FlareSolverr არ დაგვჭირდება** — `requests` + `BeautifulSoup` საკმარისია
- JSON-LD schema-დან შეიძლება პირდაპირ წავიკითხოთ ყველა მონაცემი (name, price, SKU, availability)
- პაგინაცია WooCommerce-ის სტანდარტულია (`/page/2/` და ა.შ.)

### Google Sheets
- გამოვიყენებთ არსებულ `JinoMusic` ტაბს
- სვეტები: `Product_Name_AC`, `Product_Name_JM`, `Price_AC`, `Price_JM`, `Price_Diff`, `Link_AC`, `Link_JM`, `Last_Updated`, `Feedback`
- Telegram ალერტები ფასის ცვლილებებზე (იგივე ლოგიკა რაც სხვა პროექტებში)

### run_scrapers.sh-ში ინტეგრაცია
- დაემატება მე-5 ნაწილად Mireli-ის შემდეგ
- 8 საათის sleep-ით სხვა პროექტების მსგავსად

## განხორციელების ნაბიჯები

1. **პროექტის ფოლდერის შექმნა** — `Acoustic-JinoMusic/` სტრუქტურით
2. **Acoustic scraper-ის კოპირება** — `scrapers/acoustic/` სხვა პროექტიდან
3. **JinoMusic scraper-ის დაწერა**:
   - `get_category_links.py` — კატეგორიების ამოღება `/en/products/` გვერდიდან
   - `get_all_product_links.py` — პროდუქტების ბმულების ამოღება კატეგორიებიდან (პაგინაციით)
   - `jinomusic_scraper.py` — ინდივიდუალური პროდუქტების სკრაპინგი (JSON-LD + BeautifulSoup)
   - `transform.py` — მონაცემების გასუფთავება
   - `run_jinomusic.py` — runner სკრიპტი
4. **მერჯერის დაწერა** — `acjm_data_merger.py` model/fuzzy matching-ით (ID-ის გარეშე)
5. **შიტ აფლოადერის დაწერა** — `acjm_sheet_uploader.py` Telegram ალერტებით
6. **მთავარი pipeline-ის დაწერა** — `acjm_main.py`
7. **requirements.txt შექმნა**
8. **venv შექმნა და დეპენდენსების დაყენება**
9. **run_scrapers.sh-ში ინტეგრაცია** — მე-5 ნაწილი
10. **ტესტირება** — ცალკე გაშვება პროექტის, შემდეგ pipeline-ში
