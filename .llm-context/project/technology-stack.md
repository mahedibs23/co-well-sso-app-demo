# Flutter Boilerplate - Technology Stack and Dependencies

## Core Technology Stack

### Platform
- **Target Platform**: Cross-platform (iOS & Android)
- **Flutter SDK**: 3.27.1
- **Dart SDK**: 3.6.0
- **Minimum iOS**: iOS 12.0
- **Minimum Android**: API 21 (Android 5.0)

### Programming Languages
- **Primary Language**: Dart 3.6.0 with null safety
- **Build Scripts**: pubspec.yaml configuration
- **Platform Code**: Swift (iOS), Kotlin/Java (Android)

### Architecture Framework
- **Architecture Pattern**: MVVM with Clean Architecture
- **State Management**: ValueNotifier with BaseViewModel
- **Dependency Injection**: Custom DiModule container
- **Navigation**: Flutter Navigator with typed arguments

## Development Dependencies

### Core Flutter Dependencies

#### Main App Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Multi-package Architecture
  domain:
    path: domain
  data:
    path: data
  
  # UI Components
  cupertino_icons: ^1.0.2
  flutter_svg: 2.0.0
  flutter_screenutil: 5.9.0
  google_fonts: 6.1.0
  
  # Navigation
  go_router: 13.0.0
  
  # Localization
  flutter_localizations:
    sdk: flutter
  
  # User Feedback
  fluttertoast: 8.2.12
```

#### Domain Layer Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  logger: 2.0.2        # Pretty logging
  encrypt: 5.0.3       # Encryption utilities
```

#### Data Layer Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  domain:
    path: ../domain
  
  # Network
  http: 1.2.2
  
  # Local Storage
  shared_preferences: 2.2.2
  
  # Location Services
  geolocator: 14.0.1
  geocoding: 4.0.0
  
  # Device Info
  package_info_plus: 8.1.1
```

### Testing Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: 2.0.0
```

### Storage and Data Persistence
- **Local Storage**: SharedPreferences 2.2.2 for simple key-value storage
- **Encryption**: Custom encryption utilities (encrypt: 5.0.3) in domain layer
- **Location Services**: Geolocator 14.0.1 for GPS functionality
- **Geocoding**: Geocoding 4.0.0 for address to coordinates conversion

### Network and API
- **HTTP Client**: http 1.2.2 for REST API calls
- **Custom API Client**: Domain-driven API client pattern
- **Error Handling**: Custom exception handling in domain layer

### Dependency Injection
- **Custom DI Container**: Custom DiModule implementation in domain layer
- **Service Locator Pattern**: Manual dependency management
- **Modular Architecture**: Separate DI modules for each layer

## UI and User Experience

### UI Components
- **Material Design**: Flutter's built-in Material Design components
- **Cupertino Icons**: iOS-style icons (cupertino_icons: ^1.0.2)
- **SVG Support**: flutter_svg 2.0.0 for scalable vector graphics
- **Screen Adaptation**: flutter_screenutil 5.9.0 for responsive design
- **Custom Fonts**: google_fonts 6.1.0 for typography
- **Toast Messages**: fluttertoast 8.2.12 for user feedback

### Navigation
- **Router**: go_router 13.0.0 for declarative routing
- **Type Safety**: Strongly typed route parameters
- **Deep Linking**: Support for URL-based navigation

### Internationalization
- **Localization**: flutter_localizations for multi-language support
- **Generated Assets**: Automatic asset generation enabled

## Development Tools

### Code Quality
- **Linting**: flutter_lints 2.0.0 for code analysis
- **Static Analysis**: Built-in Dart analyzer
- **Formatting**: dart format for consistent code style

### Logging and Debugging
- **Logger**: logger 2.0.2 for structured logging in domain layer
- **Flutter Inspector**: Built-in widget tree debugging
- **DevTools**: Flutter DevTools for performance profiling

## Build Tools and Configuration

### Flutter Build System
- **SDK Version**: Flutter 3.27.1, Dart 3.6.0
- **Build Flavors**: Support for multiple environments
- **Asset Generation**: Automatic asset bundling
- **Multi-package**: Modular architecture with separate packages

```

### Asset Management
- **Images**: PNG and SVG assets in organized directories
- **Fonts**: Google Fonts integration for custom typography
- **Encrypted Environment**: Secure environment variable storage
- **Localization**: Generated localization files

### Build Configuration
- **Multi-package Structure**: Separate domain and data packages
- **Asset Generation**: Automatic asset bundling enabled
- **Localization**: Generated l10n files for internationalization
- **Environment Variables**: Encrypted environment configuration

## Security

### Data Security
- **Encryption**: encrypt 5.0.3 for sensitive data encryption in domain layer
- **Secure Storage**: SharedPreferences for non-sensitive data
- **Custom Security**: Domain-driven security patterns

### App Security
- **Code Obfuscation**: Flutter's built-in obfuscation for release builds
- **Certificate Pinning**: Can be implemented with http package
- **Secure Communication**: HTTPS enforcement

## Performance and Monitoring

### Performance Optimization
- **Flutter Performance**: Built-in performance profiling tools
- **Memory Management**: Dart garbage collection
- **Widget Optimization**: Efficient widget rebuilding patterns
- **Asset Optimization**: Compressed images and optimized assets

### Monitoring and Analytics
- **Flutter DevTools**: Performance monitoring and debugging
- **Crash Reporting**: Can be integrated with Firebase Crashlytics
- **Custom Logging**: logger 2.0.2 for structured application logging

## Development Environment

### IDE and Tools
- **Flutter SDK**: 3.27.1
- **Dart SDK**: 3.6.0
- **IDE Support**: VS Code, Android Studio, IntelliJ IDEA
- **Hot Reload**: Instant code changes during development

### Version Control
- **Git**: Distributed version control
- **Multi-package**: Separate versioning for domain and data packages
- **Branching Strategy**: Feature-based development workflow

## Deployment and Distribution

### Platform Targets
- **Debug**: Development and testing
- **Staging**: Pre-production testing
- **Release**: Production deployment

### Distribution Channels
- **Google Play Store**: Primary distribution channel
- **Internal Testing**: Firebase App Distribution
- **Beta Testing**: Google Play Internal Testing

## Third-Party Integrations

### Payment Processing
- **Stripe**: Payment processing for contractor services
- **PayPal**: Alternative payment method

### Maps and Location
- **Google Maps**: Location services and mapping
- **Places API**: Location search and autocomplete

### Communication
- **Twilio**: SMS and voice communication
- **Socket.IO**: Real-time messaging

## Dependency Management Strategy

### Version Management
- **Gradle Version Catalogs**: Centralized dependency management
- **Semantic Versioning**: Consistent version numbering
- **Security Updates**: Regular security patch updates

### Dependency Auditing
- **OWASP Dependency Check**: Security vulnerability scanning
- **License Compliance**: Open source license management
- **Update Strategy**: Regular dependency updates with testing

## Performance Benchmarks

### Target Metrics
- **App Launch Time**: < 3 seconds cold start
- **Memory Usage**: < 150MB average RAM usage
- **APK Size**: < 50MB release APK
- **Network Efficiency**: Minimal data usage with caching

### Monitoring Tools
- **Firebase Performance**: Real-time performance monitoring
- **Android Vitals**: Google Play performance insights
- **Custom Metrics**: Application-specific performance tracking
