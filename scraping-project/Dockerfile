# Playwright-ის ოფიციალური იმიჯი - შეიცავს პითონს და საჭირო სისტემურ ბიბლიოთეკებს
FROM mcr.microsoft.com/playwright/python:v1.58.0-jammy

# UTF-8 გარემო და პითონის ლოგირების ოპტიმიზაცია
ENV PYTHONIOENCODING=utf-8
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# დამოკიდებულებების ინსტალაცია
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Playwright-ის ბრაუზერების ინსტალაცია (კონკრეტულად Chromium)
# --with-deps უზრუნველყოფს, რომ ყველა საჭირო ლინუქსის პაკეტი ადგილზე იყოს
RUN playwright install chromium --with-deps

# პროექტის ფაილების კოპირება
COPY . .

# საჭირო საქაღალდეების მომზადება
RUN mkdir -p /app/acms/data /app/acms/reports

# მთავარი სკრიპტის გაშვება
CMD ["python", "-u", "acms/acms_main.py"]