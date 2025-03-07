#!/bin/bash

# Install Chrome without sudo (Render allows this)
apt-get update && apt-get install -y wget unzip
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install

# Ensure Gunicorn is installed
pip install --no-cache-dir gunicorn

# Start Flask with Gunicorn
gunicorn --bind 0.0.0.0:$PORT wsgi:app
