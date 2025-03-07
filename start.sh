#!/bin/bash

# Set up working directory
mkdir -p /tmp/chrome && cd /tmp/chrome

# Download and install Chrome manually (no sudo needed)
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
ar x google-chrome-stable_current_amd64.deb
tar -xvf data.tar.xz
mv opt/google/chrome /tmp/chrome
chmod +x /tmp/chrome/chrome

# Hardcode a stable ChromeDriver version (fixes 404 issue)
wget -q -O chromedriver.zip "https://chromedriver.storage.googleapis.com/121.0.6167.139/chromedriver_linux64.zip"
unzip chromedriver.zip
chmod +x chromedriver
mv chromedriver /tmp/chrome/chromedriver

# Install Gunicorn
pip install --no-cache-dir gunicorn

# Start Flask app
gunicorn --bind 0.0.0.0:$PORT wsgi:app
