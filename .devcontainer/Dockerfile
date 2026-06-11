FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install Flutter dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    libgl1-mesa-glx \
    lib32stdc++6 \
    libc6 \
    fonts-dejavu-core \
    fonts-liberation \
    fonts-noto-core \
    fonts-noto-mono \
    fonts-noto-nerd \
    && rm -rf /var/lib/apt/lists/*

# Clone Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter --depth 1

# Add Flutter to PATH
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Disable telemetry
RUN flutter config --no-analytics && \
    flutter config --no-crash-reporting

# Run flutter doctor to download components
RUN flutter doctor -v

WORKDIR /workspace
