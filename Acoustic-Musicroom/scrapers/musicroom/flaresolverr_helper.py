import os
import time
import requests

FLARESOLVERR_URL = os.getenv('FLARESOLVERR_URL', 'http://localhost:8191/v1')


def flaresolverr_available():
    """Check if FlareSolverr is running and reachable."""
    try:
        r = requests.get(FLARESOLVERR_URL.rsplit('/v1', 1)[0] + '/', timeout=5)
        return r.status_code == 200
    except Exception:
        return False


def fetch_via_flaresolverr(url, timeout_ms=120000, return_url=False, max_retries=3):
    """Fetch a page through FlareSolverr to bypass Cloudflare.

    Returns HTML by default, or (html, final_url) tuple if return_url=True.
    final_url is the URL after any redirects (useful for detecting invalid pages).

    Retries on transient FlareSolverr errors (e.g., Cloudflare challenge timeouts).
    """
    last_error = None
    for attempt in range(1, max_retries + 1):
        try:
            resp = requests.post(
                FLARESOLVERR_URL,
                json={'cmd': 'request.get', 'url': url, 'maxTimeout': timeout_ms},
                timeout=timeout_ms / 1000 + 30
            )
            data = resp.json()
            if data.get('status') == 'ok':
                html = data['solution']['response']
                if return_url:
                    final_url = data.get('solution', {}).get('url', url)
                    return html, final_url
                return html
            error_message = data.get('message', 'unknown')
            last_error = error_message
            print(f"  FlareSolverr error (attempt {attempt}/{max_retries}): {error_message}")
            if attempt < max_retries:
                print(f"  Retrying in 5 seconds...")
                time.sleep(5)
        except Exception as e:
            last_error = str(e)[:80]
            print(f"  FlareSolverr request failed (attempt {attempt}/{max_retries}): {last_error}")
            if attempt < max_retries:
                print(f"  Retrying in 5 seconds...")
                time.sleep(5)

    return (None, None) if return_url else None
