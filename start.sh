#!/bin/bash

# Set up working directory
mkdir -p /tmp/chrome && cd /tmp/chrome

# Download and install Chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || { echo "Failed to download Chrome"; exit 1; }

ar x google-chrome-stable_current_amd64.deb
tar -xvf data.tar.xz
mv opt/google/chrome /tmp/chrome
chmod +x /tmp/chrome/chrome

# Download and install ChromeDriver
CHROME_DRIVER_VERSION="121.0.6167.139"
wget -q -O chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip" || { echo "Failed to download ChromeDriver"; exit 1; }

unzip -t chromedriver.zip || { echo "Invalid ChromeDriver zip file"; exit 1; }
unzip -o chromedriver.zip
chmod +x chromedriver
mv chromedriver /tmp/chrome/chromedriver

# Install Gunicorn
pip install --no-cache-dir gunicorn

# Start Flask app
gunicorn --bind 0.0.0.0:$PORT wsgi:app
