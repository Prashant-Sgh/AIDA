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
  gnupg \
  apt-transport-https \
  ca-certificates

# Install Chrome
echo "Installing Chrome..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 2>/dev/null || true
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
sudo apt-get update
sudo apt-get install -y google-chrome-stable 2>&1 || echo "Chrome installation encountered issues, continuing..."

# Verify Chrome installation
if command -v google-chrome &> /dev/null; then
  echo "Chrome installed successfully:"
  google-chrome --version
else
  echo "Warning: Chrome not found in PATH. Attempting alternative location..."
  if [ -f /opt/google/chrome/chrome ]; then
    echo "Found Chrome at /opt/google/chrome/chrome"
  fi
fi

# Install Flutter
echo "Cloning Flutter repository..."
git clone https://github.com/flutter/flutter.git /opt/flutter --depth 1

# Add Flutter to PATH
export PATH="/opt/flutter/bin:$PATH"
echo 'export PATH="/opt/flutter/bin:$PATH"' >> /home/vscode/.bashrc

# Source bashrc to apply PATH changes in this session
source /home/vscode/.bashrc

# Run Flutter doctor
echo "Running Flutter doctor..."
flutter doctor -v

# Disable analytics and crash reporting
flutter config --no-analytics
flutter config --no-crash-reporting

# Enable web platform
echo "Enabling Flutter web platform..."
flutter config --enable-web

echo ""
echo "Flutter setup complete!"
echo "Available devices:"
flutter devices
