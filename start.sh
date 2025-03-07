#!/bin/bash

# Ensure the script runs as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 1
fi

# Install Chrome (requires superuser privileges)
apt-get update && apt-get install -y wget unzip
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install

# Install Gunicorn
pip install gunicorn

# Start Flask with Gunicorn
gunicorn --bind 0.0.0.0:$PORT wsgi:app
