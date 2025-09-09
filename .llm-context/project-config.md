# Flutter Boilerplate - Project Configuration

## Project Information
- **PROJECT_NAME**: Flutter Boilerplate
- **PROJECT_DISPLAY_NAME**: Flutter Boilerplate
- **PROJECT_DESCRIPTION**: Production-ready Flutter boilerplate with modular MVVM Clean Architecture
- **PROJECT_VERSION**: 1.0.0+1
- **PROJECT_TYPE**: Mobile App Boilerplate

## Technical Stack
- **FLUTTER_VERSION**: 3.27.1
- **DART_VERSION**: 3.6.0
- **PRIMARY_LANGUAGE**: Dart
- **ARCHITECTURE_PATTERN**: MVVM with Clean Architecture
- **STATE_MANAGEMENT**: ValueNotifier with BaseViewModel
- **DEPENDENCY_INJECTION**: Custom DiModule container
- **NAVIGATION**: go_router 13.0.0

## Platform Configuration
- **TARGET_PLATFORMS**: Cross-platform (iOS & Android)
- **MIN_IOS_VERSION**: iOS 12.0
- **MIN_ANDROID_API**: API 21 (Android 5.0)
- **PACKAGE_NAME**: hello_flutter

## Team and Organization
- **ORGANIZATION**: Development Team
- **TEAM_SIZE**: Medium (5-8 developers)
- **PROJECT_STAGE**: Existing Codebase

## Compliance and Distribution
- **COMPLIANCE_REQUIREMENTS**: Play Store, App Store, Mobile Security Best Practices
- **DISTRIBUTION_CHANNELS**: Google Play Store, App Store
- **GIT_REPOSITORY**: Git

## Build Configuration
- **BUILD_SYSTEM**: Flutter Build System
- **PACKAGE_STRUCTURE**: Multi-package (domain, data, presentation)
- **ASSET_GENERATION**: Enabled
- **LOCALIZATION**: flutter_localizations

## Environment URLs
- **DEV_API_URL**: https://api-dev.example.com/v1/
- **STAGING_API_URL**: https://api-staging.example.com/v1/
- **PROD_API_URL**: https://api.example.com/v1/

## Key Dependencies
- **NAVIGATION**: go_router: 13.0.0
- **HTTP_CLIENT**: http: 1.2.2
- **LOCAL_STORAGE**: shared_preferences: 2.2.2
- **LOGGING**: logger: 2.0.2
- **ENCRYPTION**: encrypt: 5.0.3
- **UI_COMPONENTS**: flutter_svg: 2.0.0, flutter_screenutil: 5.9.0, google_fonts: 6.1.0
- **LOCATION**: geolocator: 14.0.1, geocoding: 4.0.0
- **DEVICE_INFO**: package_info_plus: 8.1.1
- **USER_FEEDBACK**: fluttertoast: 8.2.12

## Development Tools
- **LINTING**: flutter_lints: 2.0.0
- **TESTING**: flutter_test (SDK)
- **IDE_SUPPORT**: VS Code, Android Studio, IntelliJ IDEA

---

**Note**: This file serves as the single source of truth for project configuration. All other documentation files in `.llm-context` should reference these values instead of hardcoding project-specific information.

**Usage**: Reference values using the format `{{PROJECT_NAME}}`, `{{FLUTTER_VERSION}}`, etc. in other documentation files.
