# Use Python 3.11 slim image as base (mandatory for rapidfuzz>=4.12.0)
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for Playwright/Chromium
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    libnss3 \
    libfontconfig1 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libatspi2.0-0 \
    libdrm2 \
    libxkbcommon-x11-0 \
    libpango-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libcups2 \
    libdbus-1-3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers
RUN playwright install chromium
RUN playwright install-deps chromium

# Copy entire project
COPY . .

# Create necessary directories
RUN mkdir -p /app/acgv/data /app/reports

# Set environment variables for headless mode
ENV DISPLAY=:99

# Default command
CMD ["python", "acgv/acgv_main.py"]
