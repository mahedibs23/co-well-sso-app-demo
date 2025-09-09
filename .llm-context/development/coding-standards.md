# Flutter Boilerplate - Coding Standards

## Overview
This document defines the coding standards and best practices for Flutter applications using this boilerplate. These standards ensure code consistency, maintainability, and quality across the development team.

## Language Standards

### Dart Standards
- **Primary Language**: Dart is the primary language for Flutter development
- **Dart Version**: Use latest stable Dart version (currently 3.6.0+)
- **Null Safety**: Leverage Dart's null safety features, avoid non-null assertion operator
- **Data Classes**: Use classes with named constructors for data containers
- **Extension Functions**: Use extension methods for utility functions

#### Dart Code Style
```dart
// Good: Clear, concise class declaration
class User {
  final String id;
  final String name;
  final String? email;
  
  const User({
    required this.id,
    required this.name,
    this.email,
  });
  
  // Good: Null safety with null-aware operators
  String get displayName {
    return name.isNotEmpty ? name : 'Unknown User';
  }
}

// Good: Sealed classes for state management
sealed class UiState<T> {
  const UiState();
}

class Loading<T> extends UiState<T> {
  const Loading();
}

class Success<T> extends UiState<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends UiState<T> {
  final Exception exception;
  const Error(this.exception);
}
```

### Platform-Specific Code
- **Method Channels**: Use for platform-specific functionality
- **Native Code**: Minimize native code, prefer Flutter packages
- **Platform Integration**: Follow Flutter's platform integration guidelines

## Naming Conventions

### Classes and Interfaces
```dart
// Good: PascalCase for classes
class UserRepository
class HomeScreenViewModel
abstract class LocationService
abstract class BaseScreen

// Good: Descriptive names
class NetworkConnectionManager
class ApiService
```

### Variables and Functions
```dart
// Good: camelCase for variables and functions
String userName;
bool isLocationEnabled;
double calculateFare();
void updateUserProfile(User user);

// Good: Boolean naming
bool isLoading;
bool hasPermission;
bool canProceed;
```

### Constants
```dart
// Good: lowerCamelCase for constants in Dart
class AppConstants {
  static const int maxRetryAttempts = 3;
  static const int defaultTimeoutSeconds = 30;
  static const String apiBaseUrl = 'https://api.example.com/';
}
```

### Assets and Resources
```dart
// Good: Descriptive asset names
class AppAssets {
  static const String logoImage = 'assets/images/logo.png';
  static const String errorIcon = 'assets/images/svg/error.svg';
}

// Good: Localization keys
class AppStrings {
  static const String errorNetworkUnavailable = 'error_network_unavailable';
  static const String buttonSubmit = 'button_submit';
}
```

## Architecture Standards

### MVVM Pattern with BaseViewModel
```dart
// Good: ViewModel implementation extending BaseViewModel
class HomeViewModel extends BaseViewModel<HomeArgument> {
  final AuthRepository authRepository;
  
  // Private ValueNotifiers for state management
  final ValueNotifier<String?> _userId = ValueNotifier(null);
  final ValueNotifier<int> _currentPageIndex = ValueNotifier(0);
  
  // Public getters exposing ValueListenable
  ValueListenable<String?> get userId => _userId;
  ValueListenable<int> get currentPageIndex => _currentPageIndex;
  
  // Constructor with required dependencies
  HomeViewModel({required this.authRepository});
  
  @override
  onViewReady({HomeArgument? argument}) {
    Logger.debug("HomeViewModel onViewReady");
    _userId.value = argument?.userId;
    _loadUserSession();
  }
  
  // Use BaseViewModel's loadData method for error handling
  Future<void> _loadUserSession() async {
    try {
      final userSession = await loadData(
        authRepository.getCurrentUser(),
        showLoading: false,
      );
      Logger.debug("User session: $userSession");
    } catch (e) {
      // Error handling is done by BaseViewModel.loadData
      Logger.error("Failed to load user session: $e");
    }
  }
  
  // Business logic methods
  void onPageChanged(int index) {
    _currentPageIndex.value = index;
  }
  
  void onNavigationItemClicked(int index) {
    _currentPageIndex.value = index;
  }
  
  // Navigation using BaseViewModel methods
  void onClickBack() {
    navigateBack();
  }
  
  @override
  void onDispose() {
    _userId.dispose();
    _currentPageIndex.dispose();
    super.onDispose();
  }
}
```

### Repository Pattern with Domain/Data Separation
```dart
// Domain layer - Repository interface
abstract class AppRepository {
  Future<AppLanguage> getApplicationLocale();
  Future<AppThemeMode> getApplicationThemeMode();
  Future<void> saveApplicationLocale(AppLanguage appLanguage);
  Future<void> saveApplicationThemeMode(AppThemeMode themeMode);
  Future<AppInfo> getAppInfo();
}

// Data layer - Repository implementation
class AppRepositoryImpl implements AppRepository {
  final SharedPrefManager sharedPrefManager;
  
  AppRepositoryImpl({required this.sharedPrefManager});
  
  @override
  Future<AppLanguage> getApplicationLocale() async {
    String? savedLanguage = await sharedPrefManager.getValue<String?>('language', null);
    if (savedLanguage == null) {
      return AppLanguage.fromString(Platform.localeName);
    }
    return AppLanguage.fromString(savedLanguage);
  }
  
  @override
  Future<void> saveApplicationLocale(AppLanguage appLanguage) {
    return sharedPrefManager.saveValue('language', appLanguage.toString());
  }
  
  @override
  Future<AppInfo> getAppInfo() async {
    AppPlatform platform = Platform.isAndroid ? AppPlatform.android : AppPlatform.ios;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    
    Logger.info('App Info: ${platform.toString()} ${packageInfo.appName}');
    
    return AppInfo(
      platform: platform,
      name: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
  }
}
```

## Code Organization

### Package Structure
```
lib/
├── main/                        # Entry points for different flavors
│   ├── main.dart               # Default entry point
│   ├── main_flavor_dev.dart    # Development flavor
│   ├── main_flavor_test.dart   # Test flavor
│   ├── main_flavor_staging.dart # Staging flavor
│   └── main_flavor_prod.dart   # Production flavor
└── presentation/               # Presentation layer
    ├── app/                    # App configuration and setup
    ├── base/                   # Base classes (BaseViewModel, BaseUiState)
    │   ├── adaptive_util/      # Adaptive UI utilities
    │   ├── screen_util/        # Screen size utilities
    │   ├── base_viewmodel.dart # Base ViewModel with common functionality
    │   ├── base_ui_state.dart  # Base State class for widgets
    │   ├── base_state.dart     # Base state management
    │   └── base_*.dart         # Other base classes
    ├── common/                 # Common widgets and utilities
    ├── feature/                # Feature-specific modules
    │   ├── auth/              # Authentication feature
    │   ├── home/              # Home feature with bottom navigation
    │   ├── settings/          # Settings feature
    │   └── [feature_name]/    # Other features
    ├── localization/          # Internationalization
    ├── navigation/            # App routing and navigation
    ├── theme/                 # App theming and styling
    └── values/                # Constants and app values

data/ (separate package)
├── lib/
│   ├── di/                    # Data layer dependency injection
│   │   └── data_module.dart   # DataModule for DI setup
│   ├── exceptions/            # Data layer specific exceptions
│   ├── local/                 # Local data sources
│   │   └── shared_preference/ # SharedPreferences management
│   ├── mapper/                # Data to Domain model mappers
│   ├── model/                 # Data transfer objects (DTOs)
│   ├── remote/                # Remote data sources
│   │   ├── api_client/        # HTTP clients
│   │   └── api_service/       # API service implementations
│   └── repository/            # Repository implementations
│       ├── app_repository_impl.dart
│       ├── auth_repository_impl.dart
│       └── [feature]_repository_impl.dart

domain/ (separate package)
├── lib/
│   ├── di/                    # Domain dependency injection
│   │   ├── di_container.dart  # DI container interface
│   │   ├── di_container_impl.dart # DI container implementation
│   │   └── di_module.dart     # DiModule singleton
│   ├── exceptions/            # Domain exceptions
│   │   ├── base_exception.dart
│   │   ├── network_exceptions.dart
│   │   └── authentication_exception.dart
│   ├── model/                 # Domain models/entities
│   │   ├── app_info.dart
│   │   ├── app_language.dart
│   │   ├── app_theme_mode.dart
│   │   └── [entity].dart
│   ├── repository/            # Repository interfaces
│   │   ├── app_repository.dart
│   │   ├── auth_repository.dart
│   │   └── [feature]_repository.dart
│   └── util/                  # Domain utilities
│       └── logger.dart        # Logging utility
```
│   ├── fragments/
│   ├── adapters/
│   ├── viewmodels/
│   └── custom/
├── domain/                      # Business logic layer
│   ├── models/
│   ├── usecases/
│   └── repositories/
├── data/                        # Data layer
│   ├── repositories/
│   ├── remote/
│   ├── local/
│   └── models/
├── di/                          # Dependency injection
├── utils/                       # Utilities
└── constants/                   # Constants
```

### File Organization
```dart
// Good: Organized imports following package structure
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';
import 'package:hello_flutter/presentation/feature/home/bottom_navigation_item_type.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_argument.dart';

// Good: Class organization following BaseViewModel pattern
class HomeViewModel extends BaseViewModel<HomeArgument> {
  // Dependencies (injected through constructor)
  final AuthRepository authRepository;
  
  // Private ValueNotifiers for state
  final ValueNotifier<String?> _userId = ValueNotifier(null);
  final ValueNotifier<int> _currentPageIndex = ValueNotifier(initialPageIndex);
  
  // Public getters exposing ValueListenable
  ValueListenable<String?> get userId => _userId;
  ValueListenable<int> get currentPageIndex => _currentPageIndex;
  
  // Static constants
  static const int initialPageIndex = 0;
  
  // Constructor with required dependencies
  HomeViewModel({required this.authRepository});
  
  // BaseViewModel lifecycle method
  @override
  onViewReady({HomeArgument? argument}) {
    Logger.debug("HomeViewModel onViewReady");
    _userId.value = argument?.userId;
    _printUserSession();
  }
  
  // Public business logic methods
  void onPageChanged(int index) {
    _currentPageIndex.value = index;
  }
  
  void onNavigationItemClicked(int index) {
    _currentPageIndex.value = index;
  }
  
  void onClickBack() {
    navigateBack(); // Using BaseViewModel navigation
  }
  
  // Private helper methods
  void _printUserSession() async {
    final userSession = await authRepository.getCurrentUser();
    Logger.debug("User session: $userSession");
  }
  
  // Disposal handled by BaseViewModel.onDispose()
}
```

## Error Handling

### Exception Handling
```dart
// Good: Specific exception handling
try {
  final result = await apiService.getData();
  handleSuccess(result);
} on NetworkException catch (networkException) {
  handleNetworkError(networkException);
} on AuthenticationException catch (authException) {
  handleAuthError(authException);
} catch (exception) {
  handleGenericError(exception);
}

// Good: Result wrapper for error handling
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Exception exception;
  const Error(this.exception);
}

Future<Result<User>> fetchUserData() async {
  try {
    final user = await apiService.getUser();
    return Success(user);
  } catch (exception) {
    return Error(Exception(exception.toString()));
  }
}
```

### Logging Standards
```dart
// Good: Structured logging with Logger
import 'package:domain/util/logger.dart';

class BookingService {
  
  Future<void> bookRide(BookRideRequest request) async {
    Logger.debug('Booking ride: pickup=${request.pickup}, destination=${request.destination}');
    
    try {
      final result = await processBooking(request);
      Logger.info('Ride booked successfully: rideId=${result.rideId}');
    } catch (exception) {
      Logger.error('Failed to book ride', exception);
      rethrow;
    }
  }
}

// Good: Log levels
Logger.verbose('Verbose: Detailed debug information');
Logger.debug('Debug: General debug information');
Logger.info('Info: General information');
Logger.warning('Warning: Potential issues');
Logger.error('Error: Error conditions', exception);
```

## UI Standards

### Widget Structure
```dart
// Good: StatefulWidget with proper lifecycle
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends BaseUiState<BookingScreen> {
  late BookingViewModel viewModel;
  
  @override
  void initState() {
    super.initState();
    viewModel = BookingViewModel();
    setupViewModel();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Ride')),
      body: Column(
        children: [
          _buildAddressInput(),
          _buildBookButton(),
        ],
      ),
    );
  }
  
  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: () => viewModel.bookRide(),
      child: const Text('Book Ride'),
    );
  }
  
  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
```

### Widget Layout Standards
```dart
// Good: Consistent widget structure and naming
class BookingFormWidget extends StatelessWidget {
  final VoidCallback? onBookRide;
  
  const BookingFormWidget({
    super.key,
    this.onBookRide,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Good: Descriptive widget names
          _buildPickupAddressField(),
          const SizedBox(height: 16),
          _buildDestinationField(),
          const Spacer(),
          _buildBookRideButton(),
        ],
      ),
    );
  }
  
  Widget _buildPickupAddressField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Pickup Address',
        border: OutlineInputBorder(),
      ),
    );
  }
  
  Widget _buildBookRideButton() {
    return ElevatedButton(
      onPressed: onBookRide,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Book Ride'),
    );
  }
}
```

## Testing Standards

### Unit Testing
```dart
// Good: Unit test structure
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ApiService, LocalDataSource])
void main() {
  group('UserRepository', () {
    late UserRepository repository;
    late MockApiService mockApiService;
    late MockLocalDataSource mockLocalDataSource;
    
    setUp(() {
      mockApiService = MockApiService();
      mockLocalDataSource = MockLocalDataSource();
      repository = UserRepositoryImpl(
        apiService: mockApiService,
        localDataSource: mockLocalDataSource,
      );
    });
    
    test('when getUserProfile is called, then return user from API', () async {
      // Given
      const expectedUser = User(id: '123', name: 'John Doe');
      when(mockApiService.getUserProfile()).thenAnswer((_) async => expectedUser);
      
      // When
      final result = await repository.getUserProfile();
      
      // Then
      expect(result, equals(expectedUser));
      verify(mockApiService.getUserProfile()).called(1);
    });
    
    test('when API fails, then return cached user', () async {
      // Given
      const cachedUser = User(id: '123', name: 'John Doe');
      when(mockApiService.getUserProfile()).thenThrow(NetworkException());
      when(mockLocalDataSource.getCachedUser()).thenAnswer((_) async => cachedUser);
      
      // When
      final result = await repository.getUserProfile();
      
      // Then
      expect(result, equals(cachedUser));
    });
  });
}
```

### Widget Testing
```dart
// Good: Widget test structure
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingScreen Widget Tests', () {
    testWidgets('when book ride button is tapped, then show confirmation dialog', (tester) async {
      // Given
      await tester.pumpWidget(
        const MaterialApp(
          home: BookingScreen(),
        ),
      );
      
      // Verify initial state
      expect(find.byType(BookingScreen), findsOneWidget);
      expect(find.text('Book Ride'), findsOneWidget);
      
      // When
      await tester.tap(find.text('Book Ride'));
      await tester.pumpAndSettle();
      
      // Then
      expect(find.text('Confirm Booking'), findsOneWidget);
    });
    
    testWidgets('when pickup address is entered, then enable book button', (tester) async {
      // Given
      await tester.pumpWidget(
        const MaterialApp(
          home: BookingScreen(),
        ),
      );
      
      // When
      await tester.enterText(find.byType(TextFormField).first, '123 Main St');
      await tester.pump();
      
      // Then
      final bookButton = find.text('Book Ride');
      expect(tester.widget<ElevatedButton>(bookButton).enabled, isTrue);
    });
  });
}
```

## Performance Standards

### Memory Management
```dart
// Good: Proper lifecycle management
class LocationTrackingService {
  StreamSubscription<Position>? _locationSubscription;
  Timer? _periodicTimer;
  
  void startTracking() {
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      // Handle location update
      _handleLocationUpdate(position);
    });
  }
  
  void dispose() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }
  
  void _handleLocationUpdate(Position position) {
    // Process location update
  }
}
```

### Network Optimization
```dart
// Good: Efficient network calls with caching
class ApiService {
  final http.Client _client;
  final Map<String, CachedResponse> _cache = {};
  
  ApiService(this._client);
  
  Future<List<Ride>> getNearbyRides({
    required double latitude,
    required double longitude,
    int radius = 5,
  }) async {
    final uri = Uri.parse('$baseUrl/rides/nearby')
        .replace(queryParameters: {
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'radius': radius.toString(),
    });
    
    final response = await _client.get(uri);
    return _parseRideList(response.body);
  }
  
  // Good: Request caching with TTL
  Future<User> getUserProfile() async {
    const cacheKey = 'user_profile';
    final cached = _cache[cacheKey];
    
    if (cached != null && !cached.isExpired) {
      return User.fromJson(cached.data);
    }
    
    final response = await _client.get(Uri.parse('$baseUrl/user/profile'));
    _cache[cacheKey] = CachedResponse(
      data: response.body,
      expiry: DateTime.now().add(const Duration(minutes: 5)),
    );
    
    return User.fromJson(response.body);
  }
}
```

## Security Standards

### Data Protection
```dart
// Good: Secure data storage
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> deleteAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }
  
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

### Input Validation
```dart
// Good: Input validation
class UserValidator {
  static ValidationResult validateEmail(String email) {
    if (email.trim().isEmpty) {
      return const ValidationResult.error('Email cannot be empty');
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return const ValidationResult.error('Invalid email format');
    }
    
    return const ValidationResult.success();
  }
  
  static ValidationResult validatePhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^+\d]'), '');
    
    if (cleanPhone.length < 10) {
      return const ValidationResult.error('Phone number too short');
    }
    
    if (cleanPhone.length > 15) {
      return const ValidationResult.error('Phone number too long');
    }
    
    return const ValidationResult.success();
  }
}

// Validation result sealed class
sealed class ValidationResult {
  const ValidationResult();
}

class Success extends ValidationResult {
  const Success();
}

class Error extends ValidationResult {
  final String message;
  const Error(this.message);
}
```

## Documentation Standards

### Code Comments
```dart
/// Repository for managing user-related data operations.
/// 
/// This repository handles both local and remote data sources,
/// implementing caching strategies for optimal performance.
class UserRepository {
  final ApiService _apiService;
  final LocalDataSource _localDataSource;
  
  UserRepository({
    required ApiService apiService,
    required LocalDataSource localDataSource,
  }) : _apiService = apiService,
       _localDataSource = localDataSource;
  
  /// Updates user profile with the specified information.
  /// 
  /// [user] The user data to update
  /// Returns the updated user details
  /// Throws [NetworkException] if network request fails
  /// Throws [ValidationException] if input validation fails
  Future<User> updateUserProfile(User user) async {
    // Validate input parameters
    if (!user.isValid()) {
      throw ValidationException('Invalid user data');
    }
    
    // Make API call and return result
    return await _apiService.updateUser(user);
  }
}
```

### README Documentation
- **Setup Instructions**: Clear step-by-step Flutter setup guide
- **Architecture Overview**: Flutter app architecture explanation
- **Package Documentation**: Key packages and their usage
- **Contributing Guidelines**: Flutter development contribution process

## Code Review Standards

### Review Checklist
- [ ] Code follows Dart/Flutter naming conventions
- [ ] MVVM and Clean Architecture patterns are properly implemented
- [ ] Error handling is comprehensive with proper exception types
- [ ] Unit and widget tests are included and meaningful
- [ ] Performance considerations are addressed (memory, rendering)
- [ ] Security best practices are followed (secure storage, validation)
- [ ] Documentation is updated where necessary
- [ ] Proper disposal of resources (controllers, subscriptions)
- [ ] Accessibility features are considered

### Review Process
1. **Self Review**: Author reviews own code before submission
2. **Peer Review**: At least one team member reviews code
3. **Architecture Review**: Senior developer reviews architectural changes
4. **Testing**: Automated tests must pass
5. **Approval**: Code approved before merge

## Dependency Injection Pattern

### Custom DI Container Implementation
```dart
// Domain layer - DI Module (Singleton)
class DiModule {
  static final DiModule _instance = DiModule._internal();
  static final DiContainer _diContainer = DiContainerImpl();
  
  factory DiModule() => _instance;
  DiModule._internal();
  
  Future<void> registerSingleton<T>(T instance) async {
    try {
      await _diContainer.registerSingleton(instance);
    } catch (e) {
      Logger.error('Failed to register singleton $T: $e');
    }
  }
  
  Future<T> resolve<T>() async {
    try {
      return await _diContainer.resolve<T>();
    } catch (e) {
      Logger.error('Failed to resolve $T: $e');
      rethrow;
    }
  }
}

// Data layer - Module for dependency setup
class DataModule {
  final DiModule _diModule = DiModule();
  
  Future<void> injectDependencies() async {
    await injectApiClient();
    await injectApiService();
    await injectRepositories();
  }
  
  Future<void> injectRepositories() async {
    final movieApiService = await _diModule.resolve<MovieApiService>();
    await _diModule.registerSingleton<MovieRepository>(
      MovieRepositoryImpl(movieApiService: movieApiService),
    );
    
    await _diModule.registerSingleton<AuthRepository>(AuthRepositoryImpl());
    await _diModule.registerSingleton<LocationRepository>(LocationRepositoryImpl());
  }
}
```

## BaseViewModel Integration

### Error Handling and Loading States
```dart
// BaseViewModel provides built-in error handling and loading states
abstract class BaseViewModel<A extends BaseArgument> {
  final ValueNotifier<BaseState> _baseState = ValueNotifier(BaseState());
  ValueListenable<BaseState> get baseState => _baseState;
  
  // Built-in loading management
  @protected
  void showLoadingDialog() {
    _baseState.value = ShowLoadingDialogBaseState();
  }
  
  // Built-in error handling with localized messages
  @protected
  void handleError({required BaseException baseError, bool shouldShowToast = true}) {
    _baseState.value = HandleErrorBaseState(
      baseError: baseError,
      shouldShowToast: shouldShowToast,
    );
  }
  
  // Unified data loading with error handling
  @protected
  Future<T> loadData<T>(Future<T> future, {bool showLoading = true}) async {
    try {
      if (showLoading) showLoadingDialog();
      return await future;
    } on BaseException catch (e) {
      handleError(baseError: e);
      return Future.error(e);
    } finally {
      dismissLoadingDialog();
    }
  }
}
```

## Tools and Automation

### Static Analysis
- **dart format**: Dart code formatting
- **dart analyze**: Dart static analysis with analysis_options.yaml
- **flutter_lints**: Flutter-specific linting rules (version 2.0.0)
- **SonarQube**: Code quality and security analysis

### IDE Configuration
- **Code Style**: Import Flutter/Dart code style settings
- **Inspections**: Enable relevant Dart code inspections
- **Formatting**: Auto-format on save with dart format
- **Import Organization**: Optimize imports automatically
- **Flutter Inspector**: Enable for widget debugging
- **Run Configurations**: Use predefined flavor configurations in .idea/runConfigurations/

### Git Hooks
- **Pre-commit**: Run dart format, dart analyze, and basic tests
- **Pre-push**: Run full Flutter test suite (flutter test)
- **Commit Message**: Enforce conventional commit format

### Build Flavors
```bash
# Development
flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart

# Test
flutter run --flavor flavor_test -t lib/main/main_flavor_test.dart

# Staging
flutter run --flavor flavor_staging -t lib/main/main_flavor_staging.dart

# Production
flutter run --flavor flavor_prod -t lib/main/main_flavor_prod.dart
```
