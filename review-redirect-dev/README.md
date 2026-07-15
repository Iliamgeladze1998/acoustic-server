# Acoustic Review Redirect

QR code redirect system for acoustic.ge Google Maps reviews.

- **Live URL:** https://acoustic-review.surge.sh
- **QR Code:** `acoustic_review_qr.png`
- **How it works:** User scans QR → sees question → positive = Google Maps review, negative = thank you message

## Files
- `index.html` — Static landing page with question and redirect logic
- `app.py` — Flask server (alternative hosting, for custom domain)
- `acoustic_review_qr.png` — QR code image

## Deploy
```bash
surge /root/review-redirect acoustic-review.surge.sh
```

## Custom Domain
When DNS record is added (review.acoustic.ge → 178.104.173.138), update QR code and run Flask on port 80.
