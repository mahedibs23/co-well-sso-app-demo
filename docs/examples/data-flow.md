# Data Flow Guide

This guide explains how data moves through the Flutter Boilerplate's MVVM Clean Architecture, from user interactions to backend services and back to the UI.

## 🔄 Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │     Domain      │    │      Data       │
│     Layer       │    │     Layer       │    │     Layer       │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Views         │    │ • Use Cases     │    │ • Repositories  │
│ • ViewModels    │◄──►│ • Entities      │◄──►│ • Data Sources  │
│ • Widgets       │    │ • Interfaces    │    │ • Models        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📊 Data Flow Patterns

### 1. User Action → Data Retrieval

```
User Tap → View → ViewModel → Use Case → Repository → API → Database
    ↑                                                        ↓
    └──────────── UI Update ←─ State ←─ Entity ←─ Model ←───┘
```

### 2. Real-time Data Updates

```
WebSocket/Push → Data Source → Repository → Use Case → ViewModel → View
                                    ↓
                              Local Cache Update
```

### 3. Offline-First Pattern

```
User Action → ViewModel → Use Case → Repository
                                        ↓
                              ┌─ Local Database (Primary)
                              └─ Remote API (Sync when online)
```

## 🏗 Layer Responsibilities

### Presentation Layer (`lib/presentation/`)

**Views (Screens & Widgets)**
- Display UI components
- Handle user interactions
- Listen to ViewModel state changes
- Trigger ViewModel methods

**ViewModels**
- Manage UI state using `ValueNotifier`
- Call Use Cases for business logic
- Transform domain entities for UI consumption
- Handle loading, error, and success states

```dart
// Example: UserViewModel
class UserViewModel extends BaseViewModel {
  final GetUserUseCase _getUserUseCase;
  
  final ValueNotifier<User?> user = ValueNotifier(null);
  final ValueNotifier<List<User>> users = ValueNotifier([]);
  
  Future<void> loadUser(String userId) async {
    try {
      setLoading(true);
      final userData = await _getUserUseCase.execute(userId);
      user.value = userData;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
```

### Domain Layer (`domain/`)

**Use Cases**
- Contain business logic and rules
- Orchestrate data flow between layers
- Independent of UI and data implementation
- Single responsibility per use case

**Entities**
- Core business objects
- Platform-agnostic data structures
- Contain business rules and validation
- No dependencies on external frameworks

**Repository Interfaces**
- Define contracts for data access
- Abstract data source implementations
- Enable dependency inversion
- Support multiple data sources

```dart
// Example: Use Case
class GetUserUseCase {
  final UserRepository _repository;
  
  GetUserUseCase(this._repository);
  
  Future<User> execute(String userId) async {
    // Business logic
    if (userId.isEmpty) {
      throw ValidationException('User ID cannot be empty');
    }
    
    // Delegate to repository
    return await _repository.getUser(userId);
  }
}
```

### Data Layer (`data/`)

**Repositories**
- Implement domain repository interfaces
- Coordinate between multiple data sources
- Handle data transformation and caching
- Manage offline/online synchronization

**Data Sources**
- **Implement abstract interfaces** defined in domain layer
- Handle specific data access through abstracted clients
- **Network abstraction**: Use `NetworkClient` interface instead of direct Dio usage
- **Storage abstraction**: Use abstract storage interfaces
- Convert between data models and domain entities
- Manage requests through dependency-injected abstract clients

**Models**
- Data transfer objects (DTOs)
- JSON serialization/deserialization
- Platform-specific data representations
- Mapping to domain entities

```dart
// Example: Repository Implementation with Abstract Dependencies
class UserRepositoryImpl implements UserRepository {
  final UserDataSource _remoteDataSource;  // Abstract interface from domain
  final UserDataSource _localDataSource;   // Abstract interface from domain
  
  UserRepositoryImpl(this._remoteDataSource, this._localDataSource);
  
  @override
  Future<User> getUser(String userId) async {
    try {
      // Try remote first - using abstract interface
      final user = await _remoteDataSource.getUser(userId);
      
      // Cache locally - using abstract interface
      await _localDataSource.saveUser(user);
      
      return user; // Already domain entity from abstract interface
    } catch (e) {
      // Fallback to local cache - using abstract interface
      return await _localDataSource.getUser(userId);
    }
  }
}
```

## 🔄 Detailed Data Flow Examples

### Example 1: Loading User Profile

**Step-by-Step Flow:**

1. **User Interaction**
   ```dart
   // User taps profile button
   onTap: () => viewModel.loadUserProfile(userId)
   ```

2. **ViewModel Processing**
   ```dart
   Future<void> loadUserProfile(String userId) async {
     setLoading(true);
     try {
       final user = await getUserUseCase.execute(userId);
       userProfile.value = user;
     } catch (e) {
       setError(e.toString());
     } finally {
       setLoading(false);
     }
   }
   ```

3. **Use Case Execution**
   ```dart
   Future<User> execute(String userId) async {
     // Validate input
     if (!_isValidUserId(userId)) {
       throw ValidationException('Invalid user ID');
     }
     
     // Get user data
     return await userRepository.getUser(userId);
   }
   ```

4. **Repository Data Access**
   ```dart
   Future<User> getUser(String userId) async {
     // Check cache first
     final cached = await localDataSource.getUser(userId);
     if (cached != null && !cached.isExpired) {
       return cached.toEntity();
     }
     
     // Fetch from API
     final userModel = await remoteDataSource.fetchUser(userId);
     
     // Update cache
     await localDataSource.saveUser(userModel);
     
     return userModel.toEntity();
   }
   ```

5. **UI Update**
   ```dart
   ValueListenableBuilder<User?>(
     valueListenable: viewModel.userProfile,
     builder: (context, user, child) {
       if (user == null) return LoadingWidget();
       return UserProfileWidget(user: user);
     },
   )
   ```

### Example 2: Creating New User

**Step-by-Step Flow:**

1. **Form Submission**
   ```dart
   onPressed: () => viewModel.createUser(formData)
   ```

2. **ViewModel Validation**
   ```dart
   Future<void> createUser(UserFormData formData) async {
     if (!_validateForm(formData)) return;
     
     setLoading(true);
     try {
       final user = await createUserUseCase.execute(formData);
       // Navigate to profile or show success
       navigationService.navigateToProfile(user.id);
     } catch (e) {
       setError(e.toString());
     } finally {
       setLoading(false);
     }
   }
   ```

3. **Use Case Business Logic**
   ```dart
   Future<User> execute(UserFormData formData) async {
     // Apply business rules
     final user = User(
       id: generateUserId(),
       name: formData.name.trim(),
       email: formData.email.toLowerCase(),
       createdAt: DateTime.now(),
     );
     
     // Validate business rules
     await _validateUserRules(user);
     
     // Save user
     return await userRepository.createUser(user);
   }
   ```

4. **Repository Implementation**
   ```dart
   Future<User> createUser(User user) async {
     // Convert to API model
     final userModel = UserModel.fromEntity(user);
     
     // Send to API
     final createdModel = await remoteDataSource.createUser(userModel);
     
     // Cache locally
     await localDataSource.saveUser(createdModel);
     
     // Return domain entity
     return createdModel.toEntity();
   }
   ```

## 🔄 State Management Flow

### ValueNotifier Pattern

```dart
// ViewModel state management
class ProductListViewModel extends BaseViewModel {
  final ValueNotifier<List<Product>> products = ValueNotifier([]);
  final ValueNotifier<String?> searchQuery = ValueNotifier(null);
  final ValueNotifier<ProductFilter> filter = ValueNotifier(ProductFilter.all);
  
  // Computed state
  ValueNotifier<List<Product>> get filteredProducts {
    return ValueNotifier(
      products.value.where((product) {
        final matchesSearch = searchQuery.value?.isEmpty ?? true ||
            product.name.contains(searchQuery.value!);
        final matchesFilter = filter.value == ProductFilter.all ||
            product.category == filter.value;
        return matchesSearch && matchesFilter;
      }).toList(),
    );
  }
}
```

### UI Reactive Updates

```dart
// Widget listening to multiple state changes
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search input
          ValueListenableBuilder<String?>(
            valueListenable: viewModel.searchQuery,
            builder: (context, query, child) {
              return SearchField(
                initialValue: query,
                onChanged: viewModel.updateSearchQuery,
              );
            },
          ),
          
          // Product list
          Expanded(
            child: ValueListenableBuilder<List<Product>>(
              valueListenable: viewModel.filteredProducts,
              builder: (context, products, child) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductTile(product: products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🌐 Network Data Flow

### API Request Flow

```dart
// 1. API Client Setup
class ApiClient {
  final Dio _dio;
  
  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
  )) {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }
}

// 2. Data Source Implementation
class UserRemoteDataSource {
  final ApiClient _apiClient;
  
  Future<UserModel> fetchUser(String userId) async {
    final response = await _apiClient.get('/users/$userId');
    return UserModel.fromJson(response.data);
  }
}

// 3. Error Handling Flow
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapToAppException(err);
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: exception,
    ));
  }
  
  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.receiveTimeout:
        return NetworkException('Receive timeout');
      case DioExceptionType.badResponse:
        return ServerException('Server error: ${err.response?.statusCode}');
      default:
        return UnknownException('Unknown error occurred');
    }
  }
}
```

## 💾 Local Data Flow

### Database Operations

```dart
// 1. Local Data Source
class UserLocalDataSource {
  final Database _database;
  
  Future<UserModel?> getUser(String userId) async {
    final maps = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }
  
  Future<void> saveUser(UserModel user) async {
    await _database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// 2. Cache Management
class CacheManager {
  static const Duration defaultTTL = Duration(hours: 1);
  
  bool isExpired(DateTime cachedAt, {Duration? ttl}) {
    final expiryTime = cachedAt.add(ttl ?? defaultTTL);
    return DateTime.now().isAfter(expiryTime);
  }
}
```

## 🔄 Synchronization Patterns

### Offline-First Approach

```dart
class OfflineFirstRepository implements UserRepository {
  @override
  Future<User> getUser(String userId) async {
    // Always return local data first
    final localUser = await _localDataSource.getUser(userId);
    
    // Sync in background if online
    if (await _connectivityService.isOnline()) {
      _syncUserInBackground(userId);
    }
    
    if (localUser != null) {
      return localUser.toEntity();
    }
    
    // If no local data and online, fetch from remote
    if (await _connectivityService.isOnline()) {
      return await _fetchAndCacheUser(userId);
    }
    
    throw OfflineException('No cached data available');
  }
  
  Future<void> _syncUserInBackground(String userId) async {
    try {
      final remoteUser = await _remoteDataSource.fetchUser(userId);
      await _localDataSource.saveUser(remoteUser);
    } catch (e) {
      // Log error but don't throw - this is background sync
      logger.warning('Background sync failed: $e');
    }
  }
}
```

## 📊 Performance Considerations

### Efficient Data Loading

```dart
// 1. Pagination
class PaginatedRepository {
  Future<PaginatedResult<Product>> getProducts({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _remoteDataSource.fetchProducts(
      offset: (page - 1) * limit,
      limit: limit,
    );
    
    return PaginatedResult(
      items: response.items.map((model) => model.toEntity()).toList(),
      hasMore: response.hasMore,
      totalCount: response.totalCount,
    );
  }
}

// 2. Lazy Loading
class LazyLoadingViewModel extends BaseViewModel {
  final List<Product> _allProducts = [];
  final ValueNotifier<List<Product>> displayedProducts = ValueNotifier([]);
  
  Future<void> loadMoreProducts() async {
    if (isLoading.value) return;
    
    setLoading(true);
    try {
      final result = await _getProductsUseCase.execute(
        page: (_allProducts.length ~/ 20) + 1,
      );
      
      _allProducts.addAll(result.items);
      displayedProducts.value = List.from(_allProducts);
    } finally {
      setLoading(false);
    }
  }
}
```

## 🚨 Error Handling Flow

### Exception Propagation

```
Data Source Exception → Repository → Use Case → ViewModel → UI
        ↓                ↓           ↓           ↓        ↓
   Network Error → Cache Fallback → Business Rule → User Message → Error Dialog
```

```dart
// Error handling in ViewModel
Future<void> loadData() async {
  try {
    setLoading(true);
    final data = await _useCase.execute();
    _data.value = data;
  } on NetworkException catch (e) {
    setError('Network error: Please check your connection');
  } on ValidationException catch (e) {
    setError('Validation error: ${e.message}');
  } on ServerException catch (e) {
    setError('Server error: Please try again later');
  } catch (e) {
    setError('An unexpected error occurred');
  } finally {
    setLoading(false);
  }
}
```

## 📚 Best Practices

### 1. Dependency Abstraction
- **Define all external dependencies as interfaces** in domain layer
- **Inject concrete implementations** through dependency injection
- **Keep domain layer pure** - no direct imports of external packages
- **Use abstract factories** for creating complex dependencies

### 2. Data Transformation
- Convert between layers at boundaries
- Keep domain entities pure
- Use extension methods for conversions
- **Abstract data sources return domain entities**, not models

### 3. State Management
- Use `ValueNotifier` for reactive UI updates
- Keep ViewModels focused and testable
- Dispose resources properly

### 4. Error Handling
- **Map external library exceptions** to domain exceptions at data layer
- Handle errors at appropriate layers
- Provide meaningful error messages
- Implement fallback strategies

### 5. Performance
- Implement caching through abstract interfaces
- Use pagination for large datasets
- Optimize requests through abstract network clients

### 6. Testing Benefits
- **Mock abstract interfaces** instead of concrete implementations
- **Test business logic** independently of external dependencies
- **Verify data flow** through clean layer boundaries

---

*Understanding data flow is crucial for maintaining clean architecture and building scalable Flutter applications.*
