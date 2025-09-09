# System Architecture Overview

## Project Information
- **Project Name**: Flutter Boilerplate Template
- **Technology Stack**: Flutter/Dart, MVVM with Clean Architecture
- **Project Type**: Cross-platform Mobile Application Boilerplate
- **Current Status**: Template Project for New Developments

## High-Level Architecture

### Application Architecture Pattern
- **Pattern**: MVVM (Model-View-ViewModel) with Clean Architecture
- **Rationale**: Separation of concerns, testability, and maintainability
- **State Management**: ValueNotifier with custom base classes for reactive UI updates

### Component Relationships

```
┌─────────────────────────────────────────────────────────────────┐
│                        Main App (lib/)                         │
│  ┌─────────────────┐    ┌──────────────────────────────────────┐ │
│  │ main/           │    │         presentation/               │ │
│  │ ├─main.dart     │    │  ┌─────────────┐  ┌─────────────────┐ │ │
│  │ ├─main_dev.dart │    │  │    base/    │  │    feature/     │ │ │
│  │ └─main_prod.dart│    │  │BaseViewModel│  │  HomeViewModel  │ │ │
│  └─────────────────┘    │  │BaseUiState  │  │  AuthViewModel  │ │ │
│                         │  └─────────────┘  └─────────────────┘ │ │
│                         └──────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Domain Package                            │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │     di/         │    │    repository/  │    │   model/    │ │
│  │  DiModule       │    │  AppRepository  │    │  AppInfo    │ │
│  │  DiContainer    │    │  AuthRepository │    │  AppLanguage│ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
│                                    ▲                           │
└────────────────────────────────────┼───────────────────────────┘
                                    │
                                    │ implements
                                    │
┌─────────────────────────────────────────────────────────────────┐
│                       Data Package                             │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │      di/        │    │   repository/   │    │   remote/   │ │
│  │  DataModule     │    │AppRepositoryImpl│    │ ApiClient   │ │
│  └─────────────────┘    │AuthRepositoryImp│    │ ApiService  │ │
│                         └─────────────────┘    └─────────────┘ │
│  ┌─────────────────┐                           ┌─────────────┐ │
│  │     local/      │                           │   mapper/   │ │
│  │SharedPrefManager│                           │DTO→Domain  │ │
│  └─────────────────┘                           └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘

Data Flow:
1. UI triggers ViewModel method
2. ViewModel calls Repository interface (domain)
3. Repository implementation (data) fetches from API/local
4. Data mapped to domain models
5. ViewModel updates ValueNotifier
6. UI rebuilds via ValueListenableBuilder

## Core Components

### Presentation Layer (`lib/presentation/`)
- **BaseViewModel**: Abstract base class providing common functionality:
  - State management with ValueNotifier
  - Error handling and loading states
  - Navigation helpers
  - Lifecycle management (onViewReady, onDispose)
- **BaseUiState**: Base State class extending Flutter State with ValueListenableBuilder helpers
- **Feature ViewModels**: Extend BaseViewModel for specific business logic
- **Screens**: UI components built with Flutter widgets using BaseUiState
- **Adaptive Utilities**: Screen size and platform-specific adaptations
- **Navigation**: Centralized routing with typed arguments
- **Themes**: Material Design theming with dark/light mode support

### Domain Layer (`domain/lib/`)
- **Models/Entities**: Core business objects (AppInfo, AppLanguage, AppThemeMode, etc.)
- **Repository Interfaces**: Abstract contracts for data access
- **Custom DI Container**: DiModule singleton with DiContainer implementation
- **Domain Exceptions**: BaseException hierarchy for error handling
- **Utilities**: Logger and other domain-specific utilities

### Data Layer (`data/lib/`)
- **Repository Implementations**: Concrete implementations of domain interfaces
- **DataModule**: Dependency injection setup for data layer components
- **Remote Data Sources**: API clients and services (MovieApiClient, MovieApiService)
- **Local Data Sources**: SharedPreferences management (SharedPrefManager)
- **Data Models**: DTOs for API responses
- **Mappers**: Convert between data DTOs and domain entities

## Key Architectural Decisions

### State Management
- **ValueNotifier Pattern**: Reactive UI updates with minimal boilerplate
- **BaseViewModel Architecture**: Centralized state management with:
  - Built-in loading states (showLoadingDialog, dismissLoadingDialog)
  - Unified error handling (handleError with BaseException)
  - Navigation helpers (navigateBack, navigateTo)
  - Data loading wrapper (loadData method with error handling)
- **ValueListenable Exposure**: ViewModels expose ValueListenable for read-only access
- **BaseUiState Integration**: Simplified ValueListenableBuilder usage in widgets

### Custom Dependency Injection
- **DiModule Singleton**: Central dependency registry with error handling
- **DiContainer Implementation**: Custom DI container with async registration/resolution
- **Modular Setup**: DataModule handles data layer dependency injection
- **Repository Pattern**: Interface-implementation separation between domain and data layers

### Multi-Package Architecture
- **Separate Packages**: domain/, data/, and main app for clear boundaries
- **Package Dependencies**: 
  - App depends on domain and data
  - Data depends on domain
  - Domain has no external package dependencies
- **Import Organization**: Clear package-based import structure

### Error Handling Strategy
- **BaseException Hierarchy**: Structured exception types (NetworkException, AuthenticationException)
- **ViewModel Error Integration**: BaseViewModel.handleError for consistent error display
- **Logging Integration**: Domain Logger utility for debugging and monitoring
- **Graceful Degradation**: Fallback mechanisms in repository implementations

### Build Flavor Support
- **Multiple Entry Points**: Separate main files for dev/test/staging/prod
- **Environment Configuration**: Flavor-specific configurations
- **IDE Integration**: Predefined run configurations in .idea/runConfigurations/

### Testing Strategy
- **Unit Tests**: Test ViewModels and repositories in isolation
- **Widget Tests**: Test UI components with BaseUiState
- **Integration Tests**: Test complete user flows with DI
- **Mocking**: Use mockito for repository and service mocking

### Firebase Services
- **Authentication**: User authentication and management
- **Cloud Messaging**: Push notifications
- **Analytics**: User behavior tracking

### Third-Party Libraries
- **Dependency Injection**: Dagger/Hilt for dependency management
- **Image Loading**: Glide/Picasso for image handling
- **Networking**: Retrofit + OkHttp for API communication

## Deployment Architecture

### Build Configuration
- **Build Variants**: Debug, staging, and production builds
- **Signing**: Secure app signing with keystore
- **Optimization**: ProGuard/R8 for code optimization

### Release Pipeline
- **Continuous Integration**: Automated testing and building
- **Quality Gates**: Code quality and security checks
- **Distribution**: Google Play Store deployment

## Future Considerations

### Planned Improvements
- **Modularization**: Further feature modularization
- **Compose Migration**: Gradual migration to Jetpack Compose
- **Architecture Components**: Enhanced use of Android Architecture Components

### Scalability Roadmap
- **Multi-module**: Transition to multi-module architecture
- **Microservices**: Backend microservices integration
- **Cross-platform**: Potential cross-platform considerations

## Architecture Validation

### Quality Metrics
- **Code Coverage**: Minimum 80% test coverage
- **Performance**: App launch time < 3 seconds
- **Memory Usage**: Efficient memory utilization
- **Battery Impact**: Minimal battery drain

### Monitoring and Observability
- **Crash Reporting**: Real-time crash monitoring
- **Performance Monitoring**: App performance tracking
- **User Analytics**: User behavior insights
- **Error Tracking**: Comprehensive error logging
