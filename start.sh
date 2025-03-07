#!/bin/bash

# Install dependencies (without root access)
mkdir -p /tmp/chrome && cd /tmp/chrome

# Download Chrome (prebuilt)
wget -O chrome-linux.zip "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_123.0.6312.105-1_amd64.deb"
ar x chrome-linux.zip
tar -xvf data.tar.xz
mv opt/google/chrome /tmp/chrome
chmod +x /tmp/chrome/chrome

# Download ChromeDriver matching version 123
wget -O chromedriver.zip "https://chromedriver.storage.googleapis.com/123.0.6312.105/chromedriver_linux64.zip"
unzip chromedriver.zip
chmod +x chromedriver
mv chromedriver /tmp/chrome/chromedriver

# Install Python dependencies
pip install --no-cache-dir gunicorn

# Start Flask App
gunicorn --bind 0.0.0.0:$PORT wsgi:app
