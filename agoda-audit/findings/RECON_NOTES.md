# Agoda Bug Bounty - Reconnaissance Notes

## Program Details
- **Platform**: HackerOne
- **Scope**: `www.agoda.com` core web services, APIs, mobile application, specifically `https://www.agoda.com/book/`
- **Bounty**: $150 (Low) to $6,000 (Critical)
- **Triage**: 2 business days

## Tech Stack
- Backend: ASP.NET, Envoy proxy, Akamai CDN
- Frontend: React-based SPA with webpack bundles
- API Gateway: `/api/gw` (referenced but not directly accessible)
- GraphQL: `/api/activities/graphql` (activities), `/cars/graphql` (cars)
- Flights BFF: `/api/flights-bff/` (microservice)
- Cart/Saved: `/api/cart/`, `/api/saved/` (microservice)
- CDN: `cdn6.agoda.net`

## Discovered API Endpoints
### Cronos API (www.agoda.com)
- `/api/cronos/home/GetHomeContents`
- `/api/cronos/home/GetTopDestinations`
- `/api/cronos/layout/GetHotCities`
- `/api/cronos/layout/GetCalendarExtrasAsync/`
- `/api/cronos/layout/PageHeaderApi/UserMenuViewModel`
- `/api/cronos/layout/culture/getlanguages`
- `/api/cronos/layout/currency/getlist`
- `/api/cronos/layout/currency/set`
- `/api/cronos/layout/getgiftcardvalue`
- `/api/cronos/layout/login/params`
- `/api/cronos/layout/logincallback`
- `/api/cronos/layout/notification/get`
- `/api/cronos/mkt/GetConsentBanner`
- `/api/cronos/mkt/UpdateConsentConfiguration`
- `/api/cronos/favorite/addfavoritehotel`
- `/api/cronos/loyaltyexternal/insertmembership`
- `/api/cronos/loyaltyexternal/updatemembership`
- `/api/cronos/main/logout`
- `/api/cronos/pointsmax/getmemberprograms`
- `/api/cronos/pointsmax/savepointsmax`
- `/api/cronos/partnermember/partnerdata` (requires auth)
- `/api/cronos/price/ChangePriceView`
- `/api/cronos/rtaheaderfooter/module`
- `/api/cronos/search/GetUnifiedSuggestResult/3/1/1/0/`
- `/api/cronos/search/redirect`
- `/api/cronos/seo/base`

### Cart/Saved APIs
- `/api/cart/add` (POST, requires Context + ProductItems)
- `/api/cart/items` (POST, requires Context + Filter + Pagination)
- `/api/cart/remove` (POST)
- `/api/saved/add` (POST, requires Context + SavedItems)
- `/api/saved/remove` (POST)
- `/api/saved/retrieve` (POST, requires Context)

### GraphQL
- `/api/activities/graphql` (POST, introspection disabled but schema extractable via validation errors)
- `/cars/graphql` (POST, working)

### Flights BFF
- `/api/flights-bff/search/v1/flights`
- `/api/flights-bff/search/v1/top-routes`
- `/api/flights-bff/search/v1/itinerary`
- `/api/flights-bff/content/v1/location`
- `/api/flights-bff/calendar/v1/prices`
- `/api/flights-bff/ancillaries/v1/baggage`
- `/api/flights-bff/ancillaries/v1/seats`

### Other
- `/api/review/get-last-pending-review` (POST, returns booking data structure, leaks ServerName)
- `/api/card/campaigns` (404)
- `/api/contentCard/campaigns` (404)
- `/api/popup/campaigns` (404)
- `/api/partnerwebcomp/headerfooter/module`
- `/api/login` (inactive)
- `/api/login/FacebookAssociate` (inactive)
- `/api/login/sendEmailToSignUpDesktop` (inactive)
- `/api/cronos/property/review/ReviewComments` (POST, returns review data with reviewer PII)
- `/api/cronos/favorite/getfavoritehotels` (POST, accepts userId parameter without auth)
- `/api/cronos/favorite/addfavoritehotel` (POST, returns false without auth)
- `/api/cronos/loyaltyexternal/insertmembership` (inactive)
- `/api/cronos/loyaltyexternal/updatemembership` (inactive)
- `/api/cronos/loyaltyexternal/getmembership` (inactive)
- `/api/cronos/home/GetTravelerReviewsUrl`
- `/api/cronos/layout/GetHolidaysAsync/`
- `/api/cronos/layout/unseenexperiments/send`
- `/api/cronos/home/GetTimeSaleContent`
- `/api/en-us/Recommended/GetRecommendedCities`
- `/api/en-us/Recommended/_action_`
- `/api/en-us/Login/Params`
- `/api/en-us/Main/contacthost` (inactive)
- `/ul/api/v1/oauth` (POST, returns 500 with any payload)

## Subdomains
- `www.agoda.com` - main site
- `ycs.agoda.com` - Yield Cloud Suite (hotel partner portal), redirects to `/mldc/en-us/public/login`
- `flights.agoda.com` - flights (CNAME to `agoda.r9cdn.net`, Server: KAYAK/1.0)
- `analytics.agoda.com` - analytics (returns "OK")
- `tracking.agoda.com` - tracking (returns "OK")
- `bento.agoda.com` - Bento (CNAME to analytics.agoda.com, returns "OK")
- `hkg.agoda.com` - Hong Kong datacenter (full Agoda mirror, 194KB page)
- `partners.agoda.com` - Agoda Affiliate portal (45.113.60.65, has form with CSRF token)
- `vpn.agoda.com` - Pulse Secure VPN (103.200.108.180, redirects to Okta_Realm)
- `rocketmiles.agoda.com` - RocketMiles (204.74.99.103)
- `reservations.agoda.com` - CNAME to SendGrid (`u7154445.wl196.sendgrid.net`)
- `security.agoda.com` - CNAME to SendGrid (`u3902286.wl037.sendgrid.net`)
- Most other subdomains resolve to wildcard `103.6.182.20` and redirect to `www.agoda.com`
- `portal.agoda.com` - CNAME to `ycs.agoda.com.edgekey.net`
- `secure.agoda.com` - CNAME to `secure.agoda.com.edgekey.net`
- `gw.agoda.com` - CNAME to `e7851.x.akamaiedge.net`
- `img.agoda.com` - CNAME to `img.agoda.net`
- `images.agoda.com` - CNAME to `hkgimages.agoda.com`

## Key Findings
1. **CORS Misconfiguration** - All endpoints reflect Origin if it ends with `.agoda.com` with `ACAC: true`
   - Confirmed: `https://evil.agoda.com`, `https://x.agoda.com`, `https://evil.AGODA.COM` all get ACAO reflection
   - `https://agoda.com.evil.com` does NOT get reflected (proper suffix check)
   - `null` origin does NOT get reflected
   - CRLF injection in Origin header does not work
2. **Cookie Security Issues** - `agoda.user.03` (contains UserId) has no HttpOnly, SameSite=None, domain=.agoda.com
   - Cookie format: `UserId=<GUID>`
   - Cookie is set on ALL `.agoda.com` subdomains
3. **GraphQL Schema Extraction** - Introspection disabled but schema extractable via validation error messages
   - Activities GraphQL requires `AG-Language-Id`, `AG-Cid`, `AG-Platform-Id` headers
   - Schema has `search` (SearchResponse!) and `review` (ReviewResponse!) queries
   - `InternalContext` requires: `currency` (String!), `experimentInfo` (ExperimentInfo!)
   - `SearchRequestParameters` requires: `searchType` (SearchType! enum), `searchValue` (String!)
   - `ReviewSearchCriteria` has: `propertyId`, `activityId` (Int!), `sort` (Sort! enum), `pagination` (PaginationInput!)
   - Valid Sort values: RELEVANCE, NEWEST, OLDEST, HIGHEST, LOWEST, HELPFUL, etc.
   - No mutations configured
4. **No Auth on State-Changing APIs** - `addfavoritehotel`, `insertmembership`, `updatemembership` don't return 401
5. **No Rate Limiting** - 20 rapid requests to `/ul/api/v1/oauth`, `ReviewComments`, login params - no 429
6. **Internal Hostname Leakage** - SSR pages expose Kubernetes pod names:
   - `am-pc-4i-acm-web-user-5d7644dc5f-snsxz`
   - `AM-P***-4I-REVIEW-WEB-MAIN-7D65B78FBF-4ZJP2`
7. **Parameter Reflection on Review Pages** - Query params reflected in href attribute (URL-encoded, not exploitable XSS)
8. **VPN Portal Exposed** - `vpn.agoda.com` runs Pulse Secure with Okta_Realm authentication
9. **YCS Portal** - `ycs.agoda.com` reflects CORS for `evil.agoda.com` origin, uses Envoy proxy
10. **Review API Data** - `ReviewComments` returns reviewer display names, countries, room types, check-in/out dates
11. **Cart/Saved APIs** - Require `RequestContextViewModel` with `userSettings` and `clientInfo` (including userId)
    - `cart/items` needs `Filter` (status: Number) and `Pagination` (pageNumber, size)
    - `saved/add` needs `SavedItems`
    - All return "unexpected error" with fake userId (server-side auth check via cookie)
12. **reCAPTCHA Keys** - `partners.agoda.com`: `6LdNADUUAAAAANGH0HMtLvII1ckb7lw9awXQ7U1m`
    - `www.agoda.com`: `6LdfPZMUAAAAABUVfpzBjTdfhwUkaxeQqMknz7Ee`
