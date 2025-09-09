# Installation Guide

This guide will walk you through setting up your development environment for the Flutter Boilerplate project.

## 📋 System Requirements

### Operating System Support
- **macOS**: 10.14 (Mojave) or later
- **Windows**: Windows 10 (64-bit) or later
- **Linux**: Ubuntu 18.04 LTS or later

### Hardware Requirements
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 10GB free space for tools and dependencies
- **Processor**: x64 processor with virtualization support

## 🛠 Required Tools Installation

### 1. Android Studio (Required)

**Download and Install:**
1. Visit [Android Studio Download Page](https://developer.android.com/studio)
2. Download Android Studio 2024.1.1 or later
3. Follow the installation wizard
4. Install Android SDK and build tools when prompted

**Verify Installation:**
```bash
# Check Android Studio installation
which android-studio
# or on Windows
where android-studio
```

**Configure Android Studio:**
1. Open Android Studio
2. Go to `Configure > SDK Manager`
3. Install Android SDK Platform 34 (Android 14)
4. Install Android SDK Build-Tools 34.0.0
5. Install Android Emulator (if needed)

### 2. FVM (Flutter Version Management)

**Install FVM:**

**macOS/Linux:**
```bash
# Using Homebrew (recommended)
brew tap leoafarias/fvm
brew install fvm

# Or using pub global
dart pub global activate fvm
```

**Windows:**
```bash
# Using Chocolatey
choco install fvm

# Or using pub global
dart pub global activate fvm
```

**Verify FVM Installation:**
```bash
fvm --version
# Should show: 2.4.1 or later
```

### 3. Git Version Control

**Install Git:**

**macOS:**
```bash
# Using Homebrew
brew install git

# Or download from https://git-scm.com/download/mac
```

**Windows:**
```bash
# Download from https://git-scm.com/download/win
# Or using Chocolatey
choco install git
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install git
```

**Verify Git Installation:**
```bash
git --version
# Should show: 2.33.0 or later
```

### 4. Flutter SDK via FVM

**Install Flutter 3.24.3:**
```bash
# Install the specific Flutter version
fvm install 3.24.3

# Set as global default (optional)
fvm global 3.24.3
```

**Verify Flutter Installation:**
```bash
fvm flutter --version
# Should show: Flutter 3.24.3 • channel stable
```

## 🔧 Project Setup

### 1. Clone the Repository

```bash
# Clone the project
git clone <your-repository-url>
cd flutter-boilerplate

# Use project-specific Flutter version
fvm use 3.24.3
```

### 2. Install Project Dependencies

```bash
# Install main app dependencies
fvm flutter pub get

# Install domain layer dependencies
cd domain
fvm flutter pub get
cd ..

# Install data layer dependencies
cd data
fvm flutter pub get
cd ..
```

### 3. Configure Android Studio for FVM

**Set Flutter SDK Path:**
1. Open Android Studio
2. Go to `File > Settings` (or `Android Studio > Preferences` on macOS)
3. Navigate to `Languages & Frameworks > Flutter`
4. Set Flutter SDK path to: `<project-root>/.fvm/flutter_sdk`
5. Click `Apply` and `OK`

**Verify IDE Configuration:**
1. Open the project in Android Studio
2. Check that Flutter version shows as 3.24.3 in the status bar
3. Verify that pub get runs without errors

## ✅ Verification Steps

### 1. Run Flutter Doctor

```bash
fvm flutter doctor -v
```

**Expected Output:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.24.3, on macOS 14.0 22A380 darwin-arm64, locale en-US)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 15.0)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2024.1)
[✓] VS Code (version 1.85.0)
[✓] Connected device (2 available)
[✓] Network resources
```

### 2. Test Build Configuration

```bash
# Test development build
fvm flutter build apk --flavor flavor_dev -t lib/main/main_flavor_dev.dart --debug

# Verify no build errors
echo $?  # Should return 0 for success
```

### 3. Verify IDE Integration

1. Open Android Studio
2. Open the flutter-boilerplate project
3. Check run configurations dropdown (top-right)
4. Verify these configurations are available:
   - `dev_android_aab`
   - `flavor_dev`
   - `flavor_test`
   - `flavor_staging`
   - `flavor_prod`

## 🚨 Troubleshooting

### Common Issues and Solutions

#### Flutter Doctor Issues

**Issue: Android licenses not accepted**
```bash
# Solution: Accept Android licenses
fvm flutter doctor --android-licenses
```

**Issue: Xcode not found (macOS)**
```bash
# Solution: Install Xcode from App Store
# Then run:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### FVM Issues

**Issue: FVM command not found**
```bash
# Solution: Add to PATH
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

**Issue: Flutter version not switching**
```bash
# Solution: Clear FVM cache and reinstall
fvm list
fvm remove 3.24.3
fvm install 3.24.3
fvm use 3.24.3
```

#### Android Studio Issues

**Issue: Flutter plugin not detected**
1. Go to `File > Settings > Plugins`
2. Search for "Flutter"
3. Install Flutter plugin
4. Restart Android Studio

**Issue: SDK path not found**
1. Go to `File > Settings > Appearance & Behavior > System Settings > Android SDK`
2. Set Android SDK Location to your SDK path
3. Usually: `~/Library/Android/sdk` (macOS) or `%LOCALAPPDATA%\Android\Sdk` (Windows)

#### Build Issues

**Issue: Gradle build fails**
```bash
# Solution: Clean and rebuild
cd android
./gradlew clean
cd ..
fvm flutter clean
fvm flutter pub get
```

**Issue: iOS build fails (macOS)**
```bash
# Solution: Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
fvm flutter clean
fvm flutter pub get
```

## 📚 Next Steps

After successful installation:

1. **[Configure IDE](ide-setup.md)** - Set up Android Studio for optimal development
2. **[First Run](first-run.md)** - Run your first build and verify everything works
3. **[Environment Setup](../configuration/environment-setup.md)** - Configure environment variables and secrets

## 🆘 Getting Help

If you encounter issues not covered here:

1. Check the [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
2. Review [FVM Documentation](https://fvm.app/documentation)
3. Search existing project issues
4. Create a new issue with:
   - Your operating system and version
   - Flutter doctor output
   - Complete error messages
   - Steps to reproduce the problem

---

*Installation typically takes 20-30 minutes depending on internet speed and system performance.*
