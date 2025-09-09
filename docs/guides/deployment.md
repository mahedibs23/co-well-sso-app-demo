# Deployment Guide

This guide covers the complete deployment process for the Flutter Boilerplate project, from building release versions to publishing on app stores.

## 🚀 Deployment Overview

### Supported Platforms
- **Android**: Google Play Store, Firebase App Distribution
- **iOS**: Apple App Store, TestFlight
- **Web**: Firebase Hosting, GitHub Pages
- **Desktop**: Direct distribution (Windows, macOS, Linux)

### Build Flavors
- **Development** (`flavor_dev`) - Internal testing
- **Test** (`flavor_test`) - QA testing
- **Staging** (`flavor_staging`) - Pre-production validation
- **Production** (`flavor_prod`) - Live release

## 📚 Deployment Guides

### Core Deployment
- **[Build Process](build-process.md)** - Creating release builds
- **[CI/CD Pipeline](ci-cd.md)** - Automated deployment
- **[App Store Deployment](app-store-deployment.md)** - Publishing to stores

### Platform-Specific
- **[Android Deployment](android-deployment.md)** - Google Play Store process
- **[iOS Deployment](ios-deployment.md)** - Apple App Store process
- **[Web Deployment](web-deployment.md)** - Web hosting deployment

## 🔧 Quick Deployment Commands

### Android Release Build
```bash
# Production APK
fvm flutter build apk --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart

# Production AAB (for Play Store)
fvm flutter build appbundle --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart

# Staging build for testing
fvm flutter build apk --release --flavor flavor_staging -t lib/main/main_flavor_staging.dart
```

### iOS Release Build
```bash
# Production IPA
fvm flutter build ipa --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart

# Staging build for TestFlight
fvm flutter build ipa --release --flavor flavor_staging -t lib/main/main_flavor_staging.dart
```

### Web Release Build
```bash
# Production web build
fvm flutter build web --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart

# Deploy to Firebase Hosting
firebase deploy --only hosting:prod
```

## 🏗 Build Configuration

### Android Build Configuration
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.yourcompany.yourapp"
        minSdkVersion 26
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    flavorDimensions "env"
    productFlavors {
        flavor_dev {
            dimension "env"
            applicationIdSuffix ".dev"
            resValue "string", "app_name", "Your App Dev"
        }
        flavor_test {
            dimension "env"
            applicationIdSuffix ".test"
            resValue "string", "app_name", "Your App Test"
        }
        flavor_staging {
            dimension "env"
            applicationIdSuffix ".staging"
            resValue "string", "app_name", "Your App Staging"
        }
        flavor_prod {
            dimension "env"
            resValue "string", "app_name", "Your App"
        }
    }
}
```

### iOS Build Configuration
```xcconfig
// ios/Flutter/flavor_prodRelease.xcconfig
#include "Generated.xcconfig"

FLUTTER_TARGET=lib/main/main_flavor_prod.dart
BUNDLE_NAME=Your App
BUNDLE_DISPLAY_NAME=Your App
BUNDLE_IDENTIFIER=com.yourcompany.yourapp

// Build settings
ENABLE_BITCODE=NO
SWIFT_VERSION=5.0
IPHONEOS_DEPLOYMENT_TARGET=12.0
```

## 🔐 Code Signing & Security

### Android Signing
```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Create key.properties
echo "storePassword=your_store_password" > android/key.properties
echo "keyPassword=your_key_password" >> android/key.properties
echo "keyAlias=upload" >> android/key.properties
echo "storeFile=../upload-keystore.jks" >> android/key.properties
```

### iOS Signing
```bash
# Create certificates and provisioning profiles in Apple Developer Console
# Configure in Xcode:
# 1. Open ios/Runner.xcworkspace
# 2. Select Runner target
# 3. Go to Signing & Capabilities
# 4. Configure Team and Bundle Identifier
# 5. Ensure provisioning profiles are selected
```

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow
```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      - name: Setup Android signing
        run: |
          echo "${{ secrets.ANDROID_KEYSTORE }}" | base64 --decode > android/app/upload-keystore.jks
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=upload-keystore.jks" >> android/key.properties
      - run: flutter pub get
      - run: flutter build appbundle --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.yourcompany.yourapp
          releaseFiles: build/app/outputs/bundle/flavor_prodRelease/app-flavor_prod-release.aab
          track: internal

  build-ios:
    needs: test
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      - name: Setup iOS signing
        run: |
          echo "${{ secrets.IOS_CERTIFICATE }}" | base64 --decode > ios_certificate.p12
          echo "${{ secrets.IOS_PROVISIONING_PROFILE }}" | base64 --decode > ios_profile.mobileprovision
          security create-keychain -p "" build.keychain
          security import ios_certificate.p12 -t agg -k build.keychain -P "${{ secrets.IOS_CERTIFICATE_PASSWORD }}" -A
          security list-keychains -s build.keychain
          security default-keychain -s build.keychain
          security unlock-keychain -p "" build.keychain
          mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
          cp ios_profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
      - run: flutter pub get
      - run: flutter build ipa --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart
      - name: Upload to TestFlight
        run: |
          xcrun altool --upload-app --type ios --file build/ios/ipa/Runner.ipa --username "${{ secrets.APPLE_ID }}" --password "${{ secrets.APPLE_APP_PASSWORD }}"
```

## 📱 Store Deployment Process

### Google Play Store
1. **Prepare Release**
   - Build signed AAB
   - Update version code/name
   - Prepare store listing
   - Create release notes

2. **Upload to Play Console**
   - Upload AAB file
   - Configure release details
   - Set rollout percentage
   - Submit for review

3. **Release Management**
   - Monitor crash reports
   - Track user feedback
   - Manage rollout percentage
   - Handle updates

### Apple App Store
1. **Prepare Release**
   - Build signed IPA
   - Update version/build number
   - Prepare App Store metadata
   - Create screenshots

2. **Upload to App Store Connect**
   - Upload IPA via Xcode or Transporter
   - Configure app information
   - Set pricing and availability
   - Submit for review

3. **Release Management**
   - Monitor review status
   - Respond to review feedback
   - Manage phased release
   - Track analytics

## 🌐 Web Deployment

### Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init hosting

# Build and deploy
flutter build web --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart
firebase deploy --only hosting
```

### GitHub Pages
```yaml
# .github/workflows/web-deploy.yml
name: Deploy Web

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      - run: flutter pub get
      - run: flutter build web --release --flavor flavor_prod -t lib/main/main_flavor_prod.dart --base-href "/flutter-boilerplate/"
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

## 📊 Release Management

### Version Management
```yaml
# pubspec.yaml
version: 1.0.0+1
# Format: major.minor.patch+build_number
```

### Release Checklist
- [ ] Update version numbers
- [ ] Update changelog
- [ ] Run all tests
- [ ] Build release versions
- [ ] Test on physical devices
- [ ] Update store metadata
- [ ] Create release notes
- [ ] Submit for review
- [ ] Monitor deployment
- [ ] Update documentation

### Rollback Strategy
```bash
# Android - Rollback via Play Console
# 1. Go to Play Console
# 2. Select previous version
# 3. Promote to production

# iOS - Rollback via App Store Connect
# 1. Go to App Store Connect
# 2. Select previous version
# 3. Submit for expedited review
```

## 🔍 Monitoring & Analytics

### Crash Reporting
```dart
// Setup Firebase Crashlytics
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kReleaseMode) {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  
  runApp(MyApp());
}
```

### Performance Monitoring
```dart
// Setup Firebase Performance
class ApiClient {
  Future<Response> get(String url) async {
    final trace = FirebasePerformance.instance.newHttpTrace(
      url,
      HttpMethod.Get,
    );
    
    await trace.start();
    
    try {
      final response = await _dio.get(url);
      trace.setHttpResponseCode(response.statusCode);
      return response;
    } finally {
      await trace.stop();
    }
  }
}
```

## 🚨 Troubleshooting

### Common Build Issues
- **Signing errors**: Verify certificates and provisioning profiles
- **Version conflicts**: Check version codes and build numbers
- **Missing dependencies**: Run `flutter pub get`
- **Platform-specific errors**: Check platform configurations

### Deployment Issues
- **Store rejection**: Review store guidelines and fix issues
- **Upload failures**: Check file formats and signing
- **Review delays**: Follow up with store support
- **Rollout issues**: Monitor metrics and user feedback

## 📚 Best Practices

### 1. Release Strategy
- Use staged rollouts
- Monitor key metrics
- Have rollback plans ready
- Test thoroughly before release

### 2. Security
- Keep signing keys secure
- Use environment-specific configurations
- Implement certificate pinning
- Regular security audits

### 3. Performance
- Optimize app size
- Monitor startup time
- Track crash rates
- Analyze user flows

### 4. User Experience
- Provide clear release notes
- Handle app updates gracefully
- Monitor user feedback
- Respond to issues quickly

---

*Successful deployment requires careful planning, thorough testing, and continuous monitoring to ensure a smooth user experience.*
