# {{PROJECT_NAME}} - Deployment and Release Process Guide

*Reference: See project-config.md for centralized project configuration*

## Deployment Overview

### Release Strategy
- **Environment Progression**: Development → Test → Staging → Production
- **Release Cadence**: Bi-weekly releases with hotfix capability
- **Deployment Method**: Flutter build system with FVM version management
- **Rollback Strategy**: Immediate rollback capability for critical issues

### Build Flavors
The project uses Flutter flavors for different environments:

```dart
// Available flavors:
// - flavor_dev: Development environment
// - flavor_test: Testing environment  
// - flavor_staging: Staging environment
// - flavor_prod: Production environment
```

### Environment Configuration
```yaml
# Main entry points for each flavor:
# lib/main/main_flavor_dev.dart
# lib/main/main_flavor_test.dart
# lib/main/main_flavor_staging.dart
# lib/main/main_flavor_prod.dart
```
## Build Commands

### Using IDE Run Configurations (Recommended)

**For Android Studio/IntelliJ IDEA users**: Use the pre-configured run configurations from the dropdown menu instead of manual commands.

#### Available Run Configurations:
- **main_dev** - Run development flavor
- **main_test** - Run test flavor  
- **main_staging** - Run staging flavor
- **main_prod** - Run production flavor

#### Available Build Configurations:
- **dev_android_apk** - Build development APK
- **dev_android_aab** - Build development AAB
- **dev_ios_ipa** - Build development IPA
- **staging_android_apk** - Build staging APK
- **staging_android_aab** - Build staging AAB
- **staging_ios_ipa** - Build staging IPA
- **prod_android_apk** - Build production APK
- **prod_android_aab** - Build production AAB
- **prod_ios_ipa** - Build production IPA
- **test_android_apk** - Build test APK
- **test_android_aab** - Build test AAB
- **test_ios_ipa** - Build test IPA

#### Quality Assurance:
- **before_pull_request** - Run complete quality pipeline (pub get + gen-l10n + test + analyze)

#### Utility Commands:
- **generate_android_keystores** - Generate Android keystores
- **encrypt_env** - Encrypt environment variables

### Manual Commands (Alternative)

If you prefer using terminal commands or are not using Android Studio:

#### Development Builds
```bash
# Run development flavor
fvm flutter run --flavor flavor_dev -t ./lib/main/main_flavor_dev.dart

# Build development APK
fvm flutter build apk --flavor flavor_dev --release -t ./lib/main/main_flavor_dev.dart

# Build development AAB
fvm flutter build appbundle --flavor flavor_dev --release -t ./lib/main/main_flavor_dev.dart
```

#### Test Builds
```bash
# Run test flavor
fvm flutter run --flavor flavor_test -t ./lib/main/main_flavor_test.dart

# Build test APK
fvm flutter build apk --flavor flavor_test --release -t ./lib/main/main_flavor_test.dart

# Build test AAB
fvm flutter build appbundle --flavor flavor_test --release -t ./lib/main/main_flavor_test.dart
```

#### Staging Builds
```bash
# Run staging flavor
fvm flutter run --flavor flavor_staging -t ./lib/main/main_flavor_staging.dart

# Build staging APK
fvm flutter build apk --flavor flavor_staging --release -t ./lib/main/main_flavor_staging.dart

# Build staging AAB
fvm flutter build appbundle --flavor flavor_staging --release -t ./lib/main/main_flavor_staging.dart
```

#### Production Builds
```bash
# Run production flavor
fvm flutter run --flavor flavor_prod -t ./lib/main/main_flavor_prod.dart

# Build production APK
fvm flutter build apk --flavor flavor_prod --release -t ./lib/main/main_flavor_prod.dart

# Build production AAB
fvm flutter build appbundle --flavor flavor_prod --release -t ./lib/main/main_flavor_prod.dart
```

## iOS Builds
```bash
# Build iOS IPA for development
fvm flutter build ipa --flavor flavor_dev -t ./lib/main/main_flavor_dev.dart

# Build iOS IPA for staging
fvm flutter build ipa --flavor flavor_staging -t ./lib/main/main_flavor_staging.dart

# Build iOS IPA for production
fvm flutter build ipa --flavor flavor_prod -t ./lib/main/main_flavor_prod.dart
```

## Environment Configuration

### Development Environment
- **Purpose**: Local development and testing
- **API Endpoint**: `{{DEV_API_URL}}`
- **Logging**: Full debug logging enabled
- **Analytics**: Disabled
- **Crash Reporting**: Disabled

### Test Environment
- **Purpose**: Automated testing and CI/CD
- **API Endpoint**: Test API endpoints
- **Logging**: Test logging enabled
- **Analytics**: Disabled
- **Crash Reporting**: Disabled

### Staging Environment
- **Purpose**: Pre-production testing and QA
- **API Endpoint**: `{{STAGING_API_URL}}`
- **Logging**: Limited logging enabled
- **Analytics**: Test analytics enabled
- **Crash Reporting**: Enabled with staging configuration

### Production Environment
- **Purpose**: Live application for end users
- **API Endpoint**: `{{PROD_API_URL}}`
- **Logging**: Error logging only
- **Analytics**: Full analytics enabled
- **Crash Reporting**: Full crash reporting enabled

## Pre-Release Quality Checks

### Automated Quality Pipeline
```bash
# Run before pull request (IDE configuration available)
fvm flutter pub get && fvm flutter gen-l10n && fvm flutter test && fvm flutter analyze

```

### Quality Checks Breakdown
- **pub get**: Download and resolve dependencies
- **gen-l10n**: Generate localization files
- **test**: Run unit and widget tests
- **analyze**: Static code analysis and linting

## CI/CD Pipeline

### Flutter CI/CD Workflow
```yaml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '{{FLUTTER_VERSION}}'
        channel: 'stable'
    
    - name: Install FVM
      run: |
        dart pub global activate fvm
        fvm install
        fvm use
    
    - name: Get dependencies
      run: fvm flutter pub get
    
    - name: Generate l10n
      run: fvm flutter gen-l10n
    
    - name: Run tests
      run: fvm flutter test
    
    - name: Analyze code
      run: fvm flutter analyze
    
    - name: Upload test results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results
        path: test/

  build_android:
    needs: test
    runs-on: ubuntu-latest
    strategy:
      matrix:
        flavor: [dev, test, staging, prod]
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '{{FLUTTER_VERSION}}'
    
    - name: Build Android AAB
      run: |
        fvm flutter build appbundle \
          --flavor flavor_${{ matrix.flavor }} \
          --release \
          -t ./lib/main/main_flavor_${{ matrix.flavor }}.dart
    
    - name: Upload AAB
      uses: actions/upload-artifact@v3
      with:
        name: ${{ matrix.flavor }}-aab
        path: build/app/outputs/bundle/

  build_ios:
    needs: test
    runs-on: macos-latest
    strategy:
      matrix:
        flavor: [dev, staging, prod]
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '{{FLUTTER_VERSION}}'
    
    - name: Build iOS IPA
      run: |
        fvm flutter build ipa \
          --flavor flavor_${{ matrix.flavor }} \
          -t ./lib/main/main_flavor_${{ matrix.flavor }}.dart
    
    - name: Upload IPA
      uses: actions/upload-artifact@v3
      with:
        name: ${{ matrix.flavor }}-ipa
        path: build/ios/ipa/
```

## Keystore Management

### Android Keystore Generation
```bash
# Generate keystores for Android (IDE configuration available)
./gradlew generateKeystores
```

### Keystore Security
- **Location**: Secure storage outside version control
- **Backup**: Multiple secure backup locations
- **Access**: Limited to authorized personnel only
- **Environment Variables**: Use secure environment variable storage

### iOS Code Signing
- **Development**: Automatic signing for development
- **Distribution**: Manual signing for App Store distribution
- **Certificates**: Managed through Apple Developer Portal
- **Provisioning Profiles**: Environment-specific profiles

## App Store Deployment

### Google Play Store

#### App Bundle Generation
```bash
# Generate App Bundle for Play Store
fvm flutter build appbundle --flavor flavor_prod --release -t ./lib/main/main_flavor_prod.dart

# Verify bundle contents (if bundletool is installed)
bundletool build-apks --bundle=build/app/outputs/bundle/flavor_prodRelease/app-flavor_prod-release.aab --output=app.apks
```

#### Play Console Configuration
- **Package Name**: `{{PACKAGE_NAME}}`
- **Release Tracks**: Internal → Alpha → Beta → Production
- **Staged Rollout**: 5% → 20% → 50% → 100%
- **Review Process**: Automated pre-launch reports

### Apple App Store

#### IPA Generation
```bash
# Generate IPA for App Store
fvm flutter build ipa --flavor flavor_prod -t ./lib/main/main_flavor_prod.dart
```

#### App Store Connect Configuration
- **Bundle ID**: Configured per flavor
- **Release Process**: TestFlight → App Store Review → Production
- **Review Guidelines**: Follow Apple's App Store Review Guidelines

### Release Tracks Strategy

#### Internal Testing
- **Purpose**: Developer and QA team testing
- **Audience**: Internal team members (max 100 users)
- **Duration**: Immediate deployment
- **Approval**: Automatic

#### Alpha Testing
- **Purpose**: Early feature testing with select users
- **Audience**: Alpha testers (max 1000 users)
- **Duration**: 1-2 weeks
- **Approval**: Manual review required

#### Beta Testing
- **Purpose**: Pre-production testing with broader audience
- **Audience**: Beta testers (max 10,000 users)
- **Duration**: 2-3 weeks
- **Approval**: Manual review and stakeholder approval

#### Production Release
- **Purpose**: Public release to all users
- **Audience**: All Play Store users
- **Duration**: Staged rollout over 1 week
- **Approval**: Full stakeholder approval required

## Internal Distribution

### Firebase App Distribution (Optional)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Deploy Android AAB to App Distribution
firebase appdistribution:distribute build/app/outputs/bundle/flavor_stagingRelease/app-flavor_staging-release.aab \
  --app YOUR_ANDROID_APP_ID \
  --groups "qa-team, beta-testers" \
  --release-notes "Latest staging build with bug fixes"

# Deploy iOS IPA to App Distribution
firebase appdistribution:distribute build/ios/ipa/hello_flutter.ipa \
  --app YOUR_IOS_APP_ID \
  --groups "qa-team, beta-testers" \
  --release-notes "Latest staging build for iOS"
```

### Distribution Groups
- **QA Team**: Quality assurance testers
- **Beta Testers**: External beta testing group
- **Stakeholders**: Product managers and executives
- **Developers**: Development team members

## Version Management

### Semantic Versioning
- **Format**: MAJOR.MINOR.PATCH (e.g., 1.2.3)
- **MAJOR**: Breaking changes or major feature releases
- **MINOR**: New features with backward compatibility
- **PATCH**: Bug fixes and minor improvements

### Flutter Version Management
```yaml
# pubspec.yaml
name: {{PACKAGE_NAME}}
version: {{PROJECT_VERSION}}

# Version format: MAJOR.MINOR.PATCH+BUILD_NUMBER
# Example: 1.0.0+1
```

### Build Number Strategy
- **Format**: Semantic version + build number (e.g., 1.0.0+1)
- **Increment**: Build number increments with each build
- **CI/CD**: Automated version bumping in CI/CD pipeline

## Release Checklist

### Pre-Release Checklist
- [ ] All unit tests passing
- [ ] Integration tests completed
- [ ] UI/UX review completed
- [ ] Performance testing completed
- [ ] Security review completed
- [ ] API compatibility verified
- [ ] Database migration tested
- [ ] Crash reporting configured
- [ ] Analytics tracking verified
- [ ] App store metadata updated

### Release Day Checklist
- [ ] Final build generated and signed
- [ ] Release notes prepared
- [ ] Staged rollout configured
- [ ] Monitoring dashboards ready
- [ ] Support team notified
- [ ] Rollback plan confirmed
- [ ] Stakeholder approval obtained
- [ ] Release deployed to production

### Post-Release Checklist
- [ ] Deployment monitoring active
- [ ] User feedback monitoring
- [ ] Crash rate monitoring
- [ ] Performance metrics tracking
- [ ] App store review monitoring
- [ ] Support ticket monitoring
- [ ] Release retrospective scheduled

## Monitoring and Rollback

### Release Monitoring
```dart
// Flutter Performance Monitoring (if Firebase is integrated)
// Example with custom logging
import 'package:logger/logger.dart';

final logger = Logger();

void trackAppStartup() {
  final stopwatch = Stopwatch()..start();
  
  // App startup code
  
  stopwatch.stop();
  logger.i('App startup time: ${stopwatch.elapsedMilliseconds}ms');
}

// Custom performance tracking
void trackUserAction(String action) {
  logger.i('User action: $action');
}
```

### Rollback Procedures

#### Immediate Rollback Triggers
- Crash rate > 2%
- ANR rate > 1%
- Critical security vulnerability
- Data corruption issues
- Payment processing failures

#### Rollback Process
1. **Halt Staged Rollout**: Stop current release progression
2. **Assess Impact**: Evaluate affected user percentage
3. **Execute Rollback**: Revert to previous stable version
4. **Communicate**: Notify stakeholders and users
5. **Investigate**: Root cause analysis and fix preparation

## Environment Variables and Secrets

### Environment Variables
```bash
# Use encrypted environment files (see env-encrypted/ directory)
# Decrypt environment variables using encrypt_env.dart
dart run encrypt_env.dart

# Environment-specific configuration
# - Development: .env.dev
# - Test: .env.test  
# - Staging: .env.staging
# - Production: .env.prod
```

### CI/CD Secrets Management
- **GitHub Secrets**: Encrypted environment variables
- **Firebase Service Account**: JSON key for Firebase services
- **Play Store Service Account**: JSON key for Play Console API
- **Signing Keys**: Base64 encoded keystore files

## Performance Optimization

### Flutter Build Optimization
```bash
# Release builds with optimization
fvm flutter build apk --release --shrink --obfuscate --split-debug-info=debug-info/
fvm flutter build appbundle --release --shrink --obfuscate --split-debug-info=debug-info/
fvm flutter build ipa --release --obfuscate --split-debug-info=debug-info/
```

### App Size Optimization
- **Tree Shaking**: Automatic removal of unused code
- **Code Obfuscation**: Minify and obfuscate Dart code
- **Asset Optimization**: Compress images and optimize assets
- **Split Debug Info**: Separate debug symbols for crash reporting
- **Deferred Components**: Load features on demand (advanced)

## Compliance and Security

### Security Scanning
```bash
# Flutter security analysis
fvm flutter analyze

# Dependency vulnerability check
fvm flutter pub deps

# Custom security linting (if configured)
fvm flutter pub run custom_lint
```

### Compliance Requirements
- **GDPR**: Data protection and privacy compliance
- **CCPA**: California Consumer Privacy Act compliance
- **PCI DSS**: Payment card industry security standards
- **SOC 2**: Security and availability controls

## Disaster Recovery

### Backup Strategy
- **Source Code**: Git repository with multiple remotes
- **Build Artifacts**: Archived builds for rollback capability
- **Signing Keys**: Secure backup in multiple locations
- **Configuration**: Environment configuration backups

### Recovery Procedures
1. **Assess Situation**: Determine scope and impact
2. **Activate Team**: Notify incident response team
3. **Implement Fix**: Deploy hotfix or rollback
4. **Monitor Recovery**: Verify system stability
5. **Post-Incident Review**: Document lessons learned
