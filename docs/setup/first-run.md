# First Run Guide

This guide will help you run your first build of the Flutter Boilerplate project and verify that everything is working correctly.

## 🎯 Prerequisites

Before proceeding, ensure you have completed:
- ✅ [Installation Guide](installation.md) - All tools installed and configured
- ✅ [IDE Setup](ide-setup.md) - Android Studio configured with Flutter plugin

## 🚀 Running Your First Build

### Method 1: Using IDE Run Configurations (Recommended)

**Step 1: Open Project in Android Studio**
1. Launch Android Studio
2. Open the `flutter-boilerplate` project
3. Wait for indexing to complete

**Step 2: Select Run Configuration**
1. Look at the top-right corner of Android Studio
2. Click the run configuration dropdown
3. Select one of the available configurations:
   - `flavor_dev` - Development environment
   - `flavor_test` - Testing environment
   - `flavor_staging` - Staging environment
   - `flavor_prod` - Production environment

**Step 3: Choose Target Device**
1. Click the device dropdown next to the run configuration
2. Select your target:
   - Physical device (if connected)
   - Android emulator
   - iOS simulator (macOS only)

**Step 4: Run the App**
1. Click the green play button (▶️) or press `Shift + F10`
2. Wait for the build to complete
3. The app should launch on your selected device

### Method 2: Using Terminal Commands

**Development Build:**
```bash
# Navigate to project root
cd flutter-boilerplate

# Run development flavor
fvm flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart
```

**Other Flavors:**
```bash
# Test environment
fvm flutter run --flavor flavor_test -t lib/main/main_flavor_test.dart

# Staging environment
fvm flutter run --flavor flavor_staging -t lib/main/main_flavor_staging.dart

# Production environment
fvm flutter run --flavor flavor_prod -t lib/main/main_flavor_prod.dart
```

## 📱 Expected Results

### Successful Build Indicators

**Console Output:**
```
Launching lib/main/main_flavor_dev.dart on iPhone 15 Pro in debug mode...
Running Xcode build...
Xcode build done.                                           15.2s
Syncing files to device iPhone 15 Pro...
Flutter run key commands.
r Hot reload. 🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

💪 Running with sound null safety 💪

An Observatory debugger and profiler on iPhone 15 Pro is available at: http://127.0.0.1:64394/
The Flutter DevTools debugger and profiler on iPhone 15 Pro is available at: http://127.0.0.1:9101?uri=http://127.0.0.1:64394/
```

**App Behavior:**
- App launches successfully
- Shows the correct app name for the selected flavor:
  - Dev: "Hello Flutter Dev"
  - Test: "Hello Flutter Test"
  - Staging: "Hello Flutter Staging"
  - Prod: "Hello Flutter"
- Navigation works between screens
- No crash or error dialogs appear

### Build Verification Checklist

- [ ] App builds without errors
- [ ] App launches on target device
- [ ] Correct flavor name displayed
- [ ] Navigation between screens works
- [ ] Hot reload functions properly (`r` key)
- [ ] No runtime exceptions in console

## 🔧 Testing Different Configurations

### Test All Flavors

Run each flavor to ensure they all work:

```bash
# Quick test all flavors (builds only, doesn't run)
fvm flutter build apk --flavor flavor_dev -t lib/main/main_flavor_dev.dart --debug
fvm flutter build apk --flavor flavor_test -t lib/main/main_flavor_test.dart --debug
fvm flutter build apk --flavor flavor_staging -t lib/main/main_flavor_staging.dart --debug
fvm flutter build apk --flavor flavor_prod -t lib/main/main_flavor_prod.dart --debug
```

### Test Hot Reload

1. Run the app in debug mode
2. Make a small change to the UI (e.g., change text color)
3. Press `r` in the terminal or use IDE hot reload
4. Verify changes appear instantly without full restart

### Test Platform Targets

**Android:**
```bash
fvm flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart -d android
```

**iOS (macOS only):**
```bash
fvm flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart -d ios
```

**Web:**
```bash
fvm flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart -d web-server
```

## 🚨 Common Build Issues

### Issue: Build Fails with Gradle Error

**Symptoms:**
```
FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':app:processDebugResources'.
```

**Solutions:**
```bash
# Clean and rebuild
cd android
./gradlew clean
cd ..
fvm flutter clean
fvm flutter pub get
fvm flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart
```

### Issue: iOS Build Fails (macOS)

**Symptoms:**
```
Error: CocoaPods not installed or not in valid state.
```

**Solutions:**
```bash
# Install/update CocoaPods
sudo gem install cocoapods
cd ios
pod install
cd ..
fvm flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart -d ios
```

### Issue: Flutter Doctor Shows Issues

**Symptoms:**
```
[!] Android toolchain - develop for Android devices
    ✗ Android license status unknown.
```

**Solutions:**
```bash
# Accept Android licenses
fvm flutter doctor --android-licenses

# Re-run doctor to verify
fvm flutter doctor -v
```

### Issue: Device Not Detected

**Symptoms:**
- No devices shown in IDE dropdown
- "No connected devices" error

**Solutions:**

**For Android:**
```bash
# Enable USB debugging on device
# Check device connection
adb devices

# If no devices, try:
adb kill-server
adb start-server
```

**For iOS:**
```bash
# Check iOS devices
xcrun simctl list devices

# Open iOS Simulator
open -a Simulator
```

### Issue: Environment Variables Not Loading

**Symptoms:**
- App builds but shows default/empty values
- API calls fail with configuration errors

**Solutions:**
1. Verify environment files exist in `env/` directory
2. Check [Environment Setup Guide](../configuration/environment-setup.md)
3. Ensure correct flavor is selected

## 🎉 Success! What's Next?

Once you have successfully run the app:

### 1. Explore the Project Structure
- Read [Folder Structure Guide](../architecture/folder-structure.md)
- Understand [Data Flow](../architecture/data-flow.md)
- Learn about [MVVM Implementation](../architecture/state-management.md)

### 2. Set Up Development Environment
- Configure [Environment Variables](../configuration/environment-setup.md)
- Understand [Build Flavors](../configuration/build-flavors.md)
- Set up [Secrets Management](../configuration/secrets-management.md)

### 3. Start Development
- Review [Coding Guidelines](../development/coding-guidelines.md)
- Set up [Testing Environment](../development/testing-guide.md)
- Learn [Common Development Tasks](../development/common-tasks.md)

## 📊 Performance Benchmarks

**Expected Build Times:**
- **Debug Build**: 30-60 seconds (first build)
- **Hot Reload**: 1-3 seconds
- **Hot Restart**: 5-10 seconds
- **Release Build**: 2-5 minutes

**Memory Usage:**
- **Debug Mode**: 150-300 MB RAM
- **Release Mode**: 50-150 MB RAM

## 🆘 Getting Help

If you're still experiencing issues:

1. Check the [Debugging Guide](../development/debugging.md)
2. Review [Common Tasks](../development/common-tasks.md)
3. Search existing project issues
4. Create a new issue with:
   - Complete error messages
   - Flutter doctor output
   - Steps to reproduce
   - Your operating system and versions

---

*First run typically takes 1-3 minutes depending on your system and selected target platform.*
