# Flutter Development Container

This directory contains the development container configuration for AIDA Flutter project in GitHub Codespaces.

## Quick Start

1. Open this repository in GitHub Codespaces
2. The devcontainer will automatically:
   - Install Flutter SDK
   - Install required system dependencies
   - Install VS Code extensions for Flutter development
   - Configure Flutter for development

## What's Installed

- **Flutter SDK**: Latest stable version
- **Dart SDK**: Bundled with Flutter
- **System Dependencies**: All required libraries for Flutter development
- **VS Code Extensions**:
  - Dart
  - Flutter
  - C++ Tools
  - Remote - Containers
  - Remote - SSH
  - Remote - WSL

## Common Commands

```bash
# Check Flutter installation
flutter doctor -v

# Run the app
flutter run

# Build for web
flutter build web

# Build for Android
flutter build apk

# Run tests
flutter test

# Format code
dart format .

# Analyze code
dart analyze
```

## Configuration

- **devcontainer.json**: Main configuration file
- **Dockerfile**: Custom Docker image (optional, used if building custom image)
- **post-create.sh**: Script that runs after container creation

## Troubleshooting

If Flutter commands are not found:
```bash
source ~/.bashrc
flutter doctor -v
```

To rebuild the container:
1. Open Command Palette (Ctrl+Shift+P)
2. Select "Dev Containers: Rebuild Container"

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dev Containers Documentation](https://containers.dev/)
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)
