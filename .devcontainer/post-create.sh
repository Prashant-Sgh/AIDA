#!/bin/bash
set -e

echo "Installing Flutter and dependencies..."

# Install system dependencies
sudo apt-get update
sudo apt-get install -y \
  curl \
  git \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa \
  libgl1-mesa-glx \
  fonts-dejavu-core \
  fonts-liberation \
  fonts-noto-core \
  fonts-noto-mono \
  fonts-noto-nerd \
  wget \
  gnupg

# Install Chrome
echo "Installing Chrome..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable

echo "Chrome version:"
google-chrome --version

# Install Flutter
echo "Cloning Flutter repository..."
git clone https://github.com/flutter/flutter.git /opt/flutter --depth 1

# Add Flutter to PATH
export PATH="/opt/flutter/bin:$PATH"
echo 'export PATH="/opt/flutter/bin:$PATH"' >> /home/vscode/.bashrc

# Run Flutter doctor
echo "Running Flutter doctor..."
flutter doctor -v

# Accept licenses
echo "Accepting Android SDK licenses..."
flutter config --android-sdk /usr/lib/android-sdk || true

# Upgrade Flutter
echo "Upgrading Flutter..."
flutter upgrade

# Disable analytics and crash reporting
flutter config --no-analytics
flutter config --no-crash-reporting

# Enable web platform
echo "Enabling Flutter web platform..."
flutter config --enable-web

echo "Flutter setup complete!"
echo "Available devices:"
flutter devices
