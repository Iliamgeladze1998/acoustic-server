"""Mirror every remote image referenced in data.json into dist/assets/img and
write data.local.json with rewritten (local) image paths."""
import hashlib
import json
import re
import urllib.request
from pathlib import Path

BASE = Path(__file__).parent
DATA = BASE / "data.json"
LOCAL = BASE / "data.local.json"
IMGDIR = BASE / "dist" / "assets" / "img"
UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"

IMGDIR.mkdir(parents=True, exist_ok=True)


def local_name(url):
    tail = re.sub(r"[^A-Za-z0-9._-]", "_", url.rsplit("/", 1)[-1])[-60:]
    return hashlib.md5(url.encode()).hexdigest()[:8] + "_" + tail


def download(url):
    name = local_name(url)
    path = IMGDIR / name
    if not path.exists():
        req = urllib.request.Request(url, headers={"User-Agent": UA, "Referer": "https://acoustic.ge/"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            path.write_bytes(resp.read())
    return "assets/img/" + name


def walk(node, stats):
    if isinstance(node, dict):
        return {k: walk(v, stats) for k, v in node.items()}
    if isinstance(node, list):
        return [walk(v, stats) for v in node]
    if isinstance(node, str) and node.startswith("https://acoustic.ge/images/"):
        try:
            out = download(node)
            stats["ok"] += 1
            return out
        except Exception as exc:  # keep the remote URL as a fallback
            stats["fail"] += 1
            print("FAIL", node, exc)
            return node
    return node


def main():
    data = json.loads(DATA.read_text(encoding="utf-8"))
    stats = {"ok": 0, "fail": 0}
    # also grab hi-dpi variants of product thumbnails (240 -> 480)
    for block in data.get("product_blocks", []):
        for product in block["products"]:
            hi = product["image"].replace("/240/240/", "/480/480/")
            if hi != product["image"]:
                try:
                    product["image_2x"] = download(hi)
                except Exception:
                    product["image_2x"] = ""
    LOCAL.write_text(json.dumps(walk(data, stats), ensure_ascii=False, indent=2), encoding="utf-8")
    print("downloaded:", stats)


if __name__ == "__main__":
    main()
