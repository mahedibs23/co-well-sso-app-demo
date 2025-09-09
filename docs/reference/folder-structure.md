# Folder Structure Guide

This guide provides a comprehensive overview of the Flutter Boilerplate project structure, explaining the purpose of each directory and how they interconnect.

## 📁 Root Directory Structure

```
flutter-boilerplate/
├── .fvm/                          # Flutter Version Management
├── .idea/                         # Android Studio IDE settings
├── .llm-context/                  # AI assistant context and team processes
├── android/                       # Android-specific code and configuration
├── assets/                        # Static assets (images, fonts, etc.)
├── data/                          # Data layer (separate Flutter package)
├── doc/                           # Legacy documentation
├── docs/                          # Developer documentation (this guide)
├── domain/                        # Domain layer (separate Flutter package)
├── env/                           # Environment configuration files
├── env-encrypted/                 # Encrypted environment files
├── ios/                           # iOS-specific code and configuration
├── lib/                           # Main Flutter application code
├── linux/                        # Linux desktop configuration
├── macos/                         # macOS desktop configuration
├── test/                          # Test files
├── web/                           # Web-specific assets and configuration
├── windows/                       # Windows desktop configuration
├── .fvmrc                         # FVM configuration
├── .gitignore                     # Git ignore rules
├── analysis_options.yaml          # Dart analyzer configuration
├── l10n.yaml                      # Localization configuration
├── pubspec.yaml                   # Main app dependencies
└── README.md                      # Project overview
```

## 🏗 Core Application Structure

### `/lib/` - Main Application Code

```
lib/
├── main/                          # Application entry points
│   ├── main.dart                  # Default entry point
│   ├── main_flavor_dev.dart       # Development flavor entry
│   ├── main_flavor_prod.dart      # Production flavor entry
│   ├── main_flavor_staging.dart   # Staging flavor entry
│   └── main_flavor_test.dart      # Test flavor entry
└── presentation/                  # UI layer
    ├── app/                       # App-level configuration
    │   ├── app.dart               # Main app widget
    │   ├── app_config.dart        # App configuration
    │   └── di_module.dart         # Dependency injection setup
    ├── base/                      # Base classes and utilities
    │   ├── base_view_model.dart   # Base ViewModel class
    │   ├── base_screen.dart       # Base Screen widget
    │   └── base_widget.dart       # Base Widget utilities
    ├── common/                    # Shared UI components
    │   ├── widgets/               # Reusable widgets
    │   ├── theme/                 # App theming
    │   └── constants/             # UI constants
    ├── feature/                   # Feature-specific screens
    │   ├── home/                  # Home feature
    │   ├── profile/               # Profile feature
    │   └── settings/              # Settings feature
    ├── navigation/                # Navigation and routing
    │   ├── app_router.dart        # Route definitions
    │   └── route_names.dart       # Route constants
    └── utils/                     # Presentation utilities
        ├── extensions/            # Dart extensions
        ├── helpers/               # Helper functions
        └── validators/            # Input validation
```

### `/domain/` - Business Logic Layer (Separate Package)

```
domain/
├── lib/
│   ├── di/                        # Domain dependency injection
│   │   └── domain_module.dart     # Domain DI configuration
│   ├── exceptions/                # Domain-specific exceptions
│   │   ├── base_exception.dart    # Base exception class
│   │   └── network_exception.dart # Network-related exceptions
│   ├── model/                     # Business entities
│   │   ├── user.dart              # User entity
│   │   └── product.dart           # Product entity
│   ├── repository/                # Repository interfaces
│   │   ├── user_repository.dart   # User data contract
│   │   └── product_repository.dart # Product data contract
│   └── use_case/                  # Business use cases
│       ├── get_user_use_case.dart # Get user business logic
│       └── create_user_use_case.dart # Create user business logic
├── pubspec.yaml                   # Domain package dependencies
└── README.md                      # Domain layer documentation
```

### `/data/` - Data Access Layer (Separate Package)

```
data/
├── lib/
│   ├── di/                        # Data dependency injection
│   │   └── data_module.dart       # Data DI configuration
│   ├── exceptions/                # Data-specific exceptions
│   │   ├── api_exception.dart     # API error handling
│   │   └── cache_exception.dart   # Cache error handling
│   ├── local/                     # Local data sources
│   │   ├── database/              # Local database
│   │   ├── preferences/           # Shared preferences
│   │   └── cache/                 # Local caching
│   ├── model/                     # Data transfer objects
│   │   ├── user_model.dart        # User API model
│   │   └── product_model.dart     # Product API model
│   ├── remote/                    # Remote data sources
│   │   ├── api/                   # API clients
│   │   ├── interceptors/          # HTTP interceptors
│   │   └── endpoints/             # API endpoint definitions
│   └── repository/                # Repository implementations
│       ├── user_repository_impl.dart # User repository implementation
│       └── product_repository_impl.dart # Product repository implementation
├── pubspec.yaml                   # Data package dependencies
└── README.md                      # Data layer documentation
```

## 🎨 Assets and Resources

### `/assets/` - Static Assets

```
assets/
├── images/                        # Image assets
│   ├── png/                       # PNG images
│   │   ├── app_logo.png           # App logo
│   │   └── placeholder.png        # Placeholder images
│   └── svg/                       # SVG vector images
│       ├── icons/                 # SVG icons
│       └── illustrations/         # SVG illustrations
└── gen_icon.dart                  # Generated icon constants
```

## 📱 Platform-Specific Code

### `/android/` - Android Configuration

```
android/
├── app/
│   ├── src/
│   │   ├── main/                  # Main Android code
│   │   ├── flavor_dev/            # Development flavor resources
│   │   ├── flavor_test/           # Test flavor resources
│   │   ├── flavor_staging/        # Staging flavor resources
│   │   └── debug/                 # Debug configuration
│   └── build.gradle               # App-level Gradle configuration
├── gradle/                        # Gradle wrapper
└── build.gradle                   # Project-level Gradle configuration
```

### `/ios/` - iOS Configuration

```
ios/
├── Flutter/                       # Flutter iOS configuration
│   ├── flavor_devDebug.xcconfig   # Dev debug configuration
│   ├── flavor_devRelease.xcconfig # Dev release configuration
│   ├── flavor_testDebug.xcconfig  # Test debug configuration
│   └── flavor_prodRelease.xcconfig # Prod release configuration
├── Runner/                        # iOS app code
│   ├── Assets.xcassets/           # iOS assets
│   ├── AppDelegate.swift          # iOS app delegate
│   └── Info.plist                 # iOS app configuration
└── Runner.xcodeproj/              # Xcode project file
```

## ⚙️ Configuration and Environment

### `/env/` - Environment Configuration

```
env/
├── .env.dev                       # Development environment variables
├── .env.test                      # Test environment variables
├── .env.staging                   # Staging environment variables
├── .env.prod                      # Production environment variables
└── README.md                      # Environment setup guide
```

### `/.idea/` - IDE Configuration

```
.idea/
├── runConfigurations/             # Android Studio run configurations
│   ├── before_pull_request.xml    # Pre-PR checks
│   ├── create_feature.xml         # Feature generation
│   ├── dev_android_aab.xml        # Development AAB build
│   ├── flavor_dev.xml             # Development flavor run
│   ├── flavor_test.xml            # Test flavor run
│   ├── flavor_staging.xml         # Staging flavor run
│   └── flavor_prod.xml            # Production flavor run
└── [other IDE settings]
```

## 📚 Documentation Structure

### `/docs/` - Developer Documentation

```
docs/
├── README.md                      # Documentation overview
├── getting-started/               # Onboarding guides
│   ├── installation.md            # Setup instructions
│   ├── first-run.md               # Running first build
│   └── ide-setup.md               # IDE configuration
├── architecture/                  # Architecture documentation
│   ├── folder-structure.md        # This file
│   ├── data-flow.md               # Data flow patterns
│   └── state-management.md        # State management guide
├── configuration/                 # Configuration guides
├── development/                   # Development workflows
├── deployment/                    # Deployment guides
└── api/                          # API documentation
```

### `/.llm-context/` - AI Assistant Context

```
.llm-context/
├── project-config.md              # Centralized project configuration
├── development/                   # Development processes
│   ├── coding-standards.md        # Code standards
│   ├── git-branching.md           # Git workflow and branching strategy
│   └── code-review-guidelines.md  # Review guidelines
├── project/                       # Project information
│   ├── architecture.md            # Architecture overview
│   ├── technology-stack.md        # Tech stack details
│   └── deployment-guide.md        # Deployment processes
└── templates/                     # Documentation templates
```

## 🔄 How Folders Interconnect

### Data Flow Between Layers

1. **Presentation → Domain**
   - ViewModels call Use Cases
   - UI components use Domain entities
   - Navigation uses Domain models

2. **Domain → Data**
   - Use Cases call Repository interfaces
   - Domain entities are mapped from Data models
   - Repository contracts define data access

3. **Data → External**
   - Repositories implement data access
   - API clients handle network requests
   - Local storage manages persistence

### Dependency Injection Flow

```
main.dart → DiModule → DomainModule → DataModule
    ↓           ↓           ↓            ↓
   App    → ViewModels → UseCases → Repositories
```

### Build Configuration Flow

```
pubspec.yaml → flavor configs → platform configs → build outputs
      ↓              ↓              ↓              ↓
Dependencies → Environment → Native code → APK/IPA
```

## 🎯 Key Design Principles

### 1. **Separation of Concerns**
- Each folder has a specific responsibility
- Clear boundaries between layers
- Minimal coupling between components

### 2. **Modular Architecture**
- Domain and Data as separate packages
- Feature-based organization in presentation
- Reusable components in common folders

### 3. **Configuration Management**
- Environment-specific configurations
- Build flavor support
- Platform-specific customizations

### 4. **Developer Experience**
- IDE configurations for easy development
- Documentation co-located with code
- Automated tooling and scripts

## 🚀 Adding New Features

### Feature Creation Process

1. **Generate Feature Structure**
   ```bash
   cd lib/presentation/feature
   dart create_feature.dart new_feature_name
   ```

2. **Created Structure**
   ```
   lib/presentation/feature/new_feature_name/
   ├── new_feature_name_screen.dart      # Main screen
   ├── new_feature_name_view_model.dart  # ViewModel
   ├── widgets/                          # Feature-specific widgets
   └── models/                           # UI-specific models
   ```

3. **Add Domain Logic** (if needed)
   ```
   domain/lib/
   ├── model/new_feature_entity.dart     # Business entity
   ├── repository/new_feature_repository.dart # Data contract
   └── use_case/new_feature_use_case.dart # Business logic
   ```

4. **Implement Data Access** (if needed)
   ```
   data/lib/
   ├── model/new_feature_model.dart      # API model
   ├── remote/new_feature_api.dart       # API client
   └── repository/new_feature_repository_impl.dart # Implementation
   ```

## 📖 Navigation Guide

### Finding Specific Code

- **UI Components**: `lib/presentation/feature/[feature_name]/`
- **Business Logic**: `domain/lib/use_case/`
- **Data Access**: `data/lib/repository/`
- **API Models**: `data/lib/model/`
- **Shared Widgets**: `lib/presentation/common/widgets/`
- **App Configuration**: `lib/presentation/app/`
- **Environment Config**: `env/`

### Common File Locations

- **App Entry Point**: `lib/main/main_flavor_[env].dart`
- **Dependency Injection**: `lib/presentation/app/di_module.dart`
- **Navigation Routes**: `lib/presentation/navigation/app_router.dart`
- **Theme Configuration**: `lib/presentation/common/theme/`
- **Constants**: `lib/presentation/common/constants/`

## 🔍 Understanding Connections

### How Features Connect

1. **Screen** → Uses **ViewModel** for state management
2. **ViewModel** → Calls **Use Cases** for business logic
3. **Use Cases** → Use **Repository** interfaces for data
4. **Repository Impl** → Calls **API clients** or **local storage**

### How Configuration Works

1. **Flavor Selection** → Determines environment variables
2. **Environment Variables** → Configure API endpoints and keys
3. **Build Configuration** → Sets app name, icons, and signing
4. **Platform Configuration** → Handles platform-specific settings

---

*This folder structure provides a scalable foundation that grows with your application while maintaining clear separation of concerns and developer productivity.*
