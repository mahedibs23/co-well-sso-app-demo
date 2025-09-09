# API Integration Guide

This guide covers API integration patterns, authentication flows, and data management strategies used in the Flutter Boilerplate project.

## 🌐 API Architecture Overview

### Clean Architecture Principles
This project follows **Clean Architecture** with strict dependency abstraction:
- **Domain Layer**: Contains abstract interfaces for all external dependencies
- **Data Layer**: Implements domain interfaces with concrete network libraries
- **Dependency Inversion**: Network libraries (Dio) are wrapped in abstract layers
- **Easy Migration**: Changing HTTP clients requires only data layer changes

### RESTful API Integration
- **Network Abstraction**: `NetworkClient` interface in domain layer
- **HTTP Implementation**: Dio-based implementation in data layer
- **Authentication**: JWT token-based authentication through abstract interfaces
- **Error Handling**: Domain exceptions mapped from network errors
- **Caching**: Response caching through abstract cache interfaces
- **Interceptors**: Request/response middleware abstracted from specific HTTP library

### Clean Architecture Layer Structure

#### Domain Layer Abstractions
```
domain/lib/
├── datasource/                    # Abstract data source interfaces
│   ├── network_client.dart        # HTTP client abstraction
│   ├── auth_datasource.dart       # Authentication data source interface
│   ├── user_datasource.dart       # User data source interface
│   └── cache_datasource.dart      # Cache abstraction interface
├── repository/                    # Repository interfaces
│   ├── auth_repository.dart       # Authentication repository contract
│   └── user_repository.dart       # User repository contract
└── exceptions/                    # Domain-specific exceptions
    ├── network_exception.dart     # Network-related exceptions
    └── auth_exception.dart        # Authentication exceptions
```

#### Data Layer Implementations
```
data/lib/remote/
├── client/                        # Network client implementations
│   ├── dio_network_client.dart    # Dio-based NetworkClient implementation
│   └── network_client_factory.dart # Factory for network client creation
├── datasource/                    # Concrete data source implementations
│   ├── auth_datasource_impl.dart  # Authentication API implementation
│   ├── user_datasource_impl.dart  # User API implementation
│   └── cache_datasource_impl.dart # Cache implementation
├── interceptors/                  # HTTP interceptors (Dio-specific)
│   ├── auth_interceptor.dart      # Authentication middleware
│   ├── logging_interceptor.dart   # Request/response logging
│   └── error_interceptor.dart     # Error handling middleware
├── endpoints/                     # API endpoint definitions
│   └── api_endpoints.dart         # Centralized endpoint constants
└── models/                        # API response models
    ├── auth_response_model.dart   # Authentication responses
    ├── user_model.dart            # User data models
    └── api_response_model.dart    # Generic API response wrapper
```

## 🔧 Network Client Abstraction

### Domain Layer Network Interface

```dart
// domain/lib/datasource/network_client.dart
abstract class NetworkClient {
  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  
  Future<NetworkResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  });
  
  Future<NetworkResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  });
  
  Future<NetworkResponse<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
  });
}

class NetworkResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, dynamic> headers;
  
  NetworkResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
  });
}
```

### Data Layer Dio Implementation

```dart
// data/lib/remote/client/dio_network_client.dart
class DioNetworkClient implements NetworkClient {
  late final Dio _dio;
  
  DioNetworkClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      CacheInterceptor(),
    ]);
  }
  
  @override
  Future<NetworkResponse<T>> get<T>(String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return NetworkResponse<T>(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }
  
  @override
  Future<NetworkResponse<T>> post<T>(String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
      
      return NetworkResponse<T>(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }
  
  // Similar implementations for put() and delete()...
  
  NetworkException _mapException(DioException e) {
    // Map Dio exceptions to domain exceptions
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      default:
        return NetworkException('Network error: ${e.message}');
    }
  }
}
```

### Authentication Interceptor

```dart
// data/lib/remote/interceptors/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  
  AuthInterceptor(this._tokenStorage);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for login/register endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }
    
    // Add access token to headers
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle token refresh on 401 errors
    if (err.response?.statusCode == 401) {
      try {
        await _refreshToken();
        
        // Retry original request with new token
        final retryResponse = await _dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        // Refresh failed, redirect to login
        await _handleAuthFailure();
      }
    }
    
    handler.next(err);
  }
  
  Future<void> _refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) throw AuthException('No refresh token');
    
    final response = await _dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    
    final authResponse = AuthResponseModel.fromJson(response.data);
    await _tokenStorage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );
  }
  
  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') || 
           path.contains('/auth/register') ||
           path.contains('/auth/refresh');
  }
}
```

## 🔐 Authentication Flow

### Domain Authentication DataSource Interface

```dart
// domain/lib/datasource/auth_datasource.dart
abstract class AuthDataSource {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(String name, String email, String password);
  Future<void> logout();
  Future<AuthResult> refreshToken(String refreshToken);
}

class AuthResult {
  final String accessToken;
  final String refreshToken;
  final User user;
  
  AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
```

### Data Layer Authentication Implementation

```dart
// data/lib/remote/datasource/auth_datasource_impl.dart
class AuthDataSourceImpl implements AuthDataSource {
  final NetworkClient _networkClient;
  
  AuthDataSourceImpl(this._networkClient);
  
  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final authModel = AuthResponseModel.fromJson(response.data);
      return AuthResult(
        accessToken: authModel.accessToken,
        refreshToken: authModel.refreshToken,
        user: authModel.user.toEntity(),
      );
    } on NetworkException {
      rethrow; // Domain exceptions pass through
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }
  
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapAuthException(e);
    }
  }
  
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      // Log error but don't throw - logout should always succeed locally
      logger.warning('Logout API call failed: $e');
    }
  }
  
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapAuthException(e);
    }
  }
  
  AuthException _mapAuthException(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return ValidationException('Invalid credentials');
      case 401:
        return AuthException('Authentication failed');
      case 403:
        return AuthException('Access denied');
      case 422:
        return ValidationException('Validation failed');
      default:
        return AuthException('Authentication error: ${e.message}');
    }
  }
}
```

### Authentication Repository Implementation

```dart
// data/lib/repository/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final TokenStorage _tokenStorage;
  final UserLocalDataSource _userLocalDataSource;
  
  AuthRepositoryImpl(
    this._authApi,
    this._tokenStorage,
    this._userLocalDataSource,
  );
  
  @override
  Future<User> login(String email, String password) async {
    try {
      final authResponse = await _authApi.login(
        email: email,
        password: password,
      );
      
      // Save tokens
      await _tokenStorage.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      
      // Cache user data
      await _userLocalDataSource.saveUser(authResponse.user);
      
      return authResponse.user.toEntity();
    } catch (e) {
      throw _mapToAuthException(e);
    }
  }
  
  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final authResponse = await _authApi.register(
        name: name,
        email: email,
        password: password,
      );
      
      // Save tokens
      await _tokenStorage.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      
      // Cache user data
      await _userLocalDataSource.saveUser(authResponse.user);
      
      return authResponse.user.toEntity();
    } catch (e) {
      throw _mapToAuthException(e);
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      // Call logout API
      await _authApi.logout();
    } finally {
      // Always clear local data
      await _tokenStorage.clearTokens();
      await _userLocalDataSource.clearUser();
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    final accessToken = await _tokenStorage.getAccessToken();
    return accessToken != null && !_isTokenExpired(accessToken);
  }
  
  @override
  Future<User?> getCurrentUser() async {
    if (!await isAuthenticated()) return null;
    
    final userModel = await _userLocalDataSource.getCurrentUser();
    return userModel?.toEntity();
  }
}
```

## 📊 Data API Patterns

### Generic API Response Wrapper

```dart
// data/lib/remote/models/api_response_model.dart
class ApiResponseModel<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final PaginationModel? pagination;
  
  ApiResponseModel({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.pagination,
  });
  
  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'],
      pagination: json['pagination'] != null 
          ? PaginationModel.fromJson(json['pagination'])
          : null,
    );
  }
}

class PaginationModel {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNext;
  final bool hasPrevious;
  
  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrevious,
  });
  
  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      totalItems: json['total_items'],
      itemsPerPage: json['items_per_page'],
      hasNext: json['has_next'],
      hasPrevious: json['has_previous'],
    );
  }
}
```

### CRUD API Implementation

```dart
// data/lib/remote/api/user_api.dart
class UserApi {
  final Dio _dio;
  
  UserApi(this._dio);
  
  Future<ApiResponseModel<UserModel>> getUser(String userId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.users}/$userId');
      
      return ApiResponseModel.fromJson(
        response.data,
        (data) => UserModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }
  
  Future<ApiResponseModel<List<UserModel>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    UserFilter? filter,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (filter != null) ...filter.toQueryParams(),
      };
      
      final response = await _dio.get(
        ApiEndpoints.users,
        queryParameters: queryParams,
      );
      
      return ApiResponseModel.fromJson(
        response.data,
        (data) => (data as List)
            .map((item) => UserModel.fromJson(item))
            .toList(),
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }
  
  Future<ApiResponseModel<UserModel>> createUser(UserModel user) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.users,
        data: user.toJson(),
      );
      
      return ApiResponseModel.fromJson(
        response.data,
        (data) => UserModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }
  
  Future<ApiResponseModel<UserModel>> updateUser(
    String userId,
    UserModel user,
  ) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.users}/$userId',
        data: user.toJson(),
      );
      
      return ApiResponseModel.fromJson(
        response.data,
        (data) => UserModel.fromJson(data),
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }
  
  Future<void> deleteUser(String userId) async {
    try {
      await _dio.delete('${ApiEndpoints.users}/$userId');
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }
  
  ApiException _mapException(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return ValidationException('Invalid request data');
      case 401:
        return AuthException('Authentication required');
      case 403:
        return AuthException('Access denied');
      case 404:
        return NotFoundException('User not found');
      case 422:
        return ValidationException('Validation failed');
      case 500:
        return ServerException('Internal server error');
      default:
        return NetworkException('Network error: ${e.message}');
    }
  }
}
```

## 🔄 Offline Support & Caching

### Cache Interceptor Implementation

```dart
// data/lib/remote/interceptors/cache_interceptor.dart
class CacheInterceptor extends Interceptor {
  final CacheManager _cacheManager;
  final ConnectivityService _connectivityService;
  
  CacheInterceptor(this._cacheManager, this._connectivityService);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Only cache GET requests
    if (options.method.toLowerCase() != 'get') {
      return handler.next(options);
    }
    
    // Check if offline
    final isOnline = await _connectivityService.isOnline();
    if (!isOnline) {
      // Try to serve from cache
      final cachedResponse = await _cacheManager.get(options.uri.toString());
      if (cachedResponse != null) {
        return handler.resolve(Response(
          requestOptions: options,
          data: cachedResponse.data,
          statusCode: 200,
          headers: Headers.fromMap({'x-cache': ['HIT']}),
        ));
      } else {
        return handler.reject(DioException(
          requestOptions: options,
          error: OfflineException('No cached data available'),
        ));
      }
    }
    
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Cache successful GET responses
    if (response.requestOptions.method.toLowerCase() == 'get' &&
        response.statusCode == 200) {
      await _cacheManager.put(
        response.requestOptions.uri.toString(),
        CachedResponse(
          data: response.data,
          timestamp: DateTime.now(),
          headers: response.headers.map,
        ),
      );
    }
    
    handler.next(response);
  }
}
```

### Repository with Offline Support

```dart
// data/lib/repository/user_repository_impl.dart (with offline support)
class UserRepositoryImpl implements UserRepository {
  final UserApi _userApi;
  final UserLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;
  
  @override
  Future<User> getUser(String userId) async {
    try {
      // Always try local first for immediate response
      final localUser = await _localDataSource.getUser(userId);
      
      // Check if we're online
      final isOnline = await _connectivityService.isOnline();
      
      if (isOnline) {
        try {
          // Fetch fresh data from API
          final apiResponse = await _userApi.getUser(userId);
          if (apiResponse.success && apiResponse.data != null) {
            // Update local cache
            await _localDataSource.saveUser(apiResponse.data!);
            return apiResponse.data!.toEntity();
          }
        } catch (e) {
          // API failed, fall back to local data if available
          if (localUser != null) {
            logger.warning('API failed, using cached data: $e');
            return localUser.toEntity();
          }
          rethrow;
        }
      }
      
      // Offline or API failed - use local data
      if (localUser != null) {
        return localUser.toEntity();
      }
      
      throw OfflineException('No cached data available for user $userId');
    } catch (e) {
      throw _mapException(e);
    }
  }
  
  @override
  Future<List<User>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final isOnline = await _connectivityService.isOnline();
      
      if (isOnline) {
        try {
          final apiResponse = await _userApi.getUsers(
            page: page,
            limit: limit,
            search: search,
          );
          
          if (apiResponse.success && apiResponse.data != null) {
            // Cache the results
            if (page == 1) {
              // Replace cache for first page
              await _localDataSource.saveUsers(apiResponse.data!);
            } else {
              // Append to cache for subsequent pages
              await _localDataSource.appendUsers(apiResponse.data!);
            }
            
            return apiResponse.data!.map((model) => model.toEntity()).toList();
          }
        } catch (e) {
          logger.warning('API failed, falling back to cache: $e');
        }
      }
      
      // Use cached data
      final cachedUsers = await _localDataSource.getUsers(
        offset: (page - 1) * limit,
        limit: limit,
        search: search,
      );
      
      return cachedUsers.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw _mapException(e);
    }
  }
}
```

## 🚨 Error Handling Strategies

### Centralized Error Handling

```dart
// data/lib/remote/interceptors/error_interceptor.dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapToAppException(err);
    
    // Log error for debugging
    logger.error('API Error: ${appException.toString()}', err);
    
    // Emit error event for global handling
    EventBus().emit(ApiErrorEvent(appException));
    
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: appException,
      response: err.response,
    ));
  }
  
  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
        
      case DioExceptionType.badResponse:
        return _mapHttpError(err.response!);
        
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled');
        
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
        
      default:
        return UnknownException('An unexpected error occurred: ${err.message}');
    }
  }
  
  AppException _mapHttpError(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;
    
    // Extract error message from response
    String? message;
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'];
    }
    
    switch (statusCode) {
      case 400:
        return ValidationException(message ?? 'Bad request');
      case 401:
        return AuthException(message ?? 'Authentication required');
      case 403:
        return AuthException(message ?? 'Access denied');
      case 404:
        return NotFoundException(message ?? 'Resource not found');
      case 422:
        return ValidationException(message ?? 'Validation failed');
      case 429:
        return NetworkException(message ?? 'Too many requests');
      case 500:
        return ServerException(message ?? 'Internal server error');
      case 502:
      case 503:
      case 504:
        return ServerException(message ?? 'Server temporarily unavailable');
      default:
        return ServerException(message ?? 'Server error ($statusCode)');
    }
  }
}
```

### Repository Error Handling

```dart
// Example of error handling in repository
class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> createUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final response = await _userApi.createUser(userModel);
      
      if (response.success && response.data != null) {
        // Cache the created user
        await _localDataSource.saveUser(response.data!);
        return response.data!.toEntity();
      } else {
        throw ServerException(response.message ?? 'Failed to create user');
      }
    } on ValidationException {
      // Re-throw validation errors as-is
      rethrow;
    } on AuthException {
      // Re-throw auth errors as-is
      rethrow;
    } on NetworkException {
      // For network errors, try to queue for later sync
      await _queueUserCreation(user);
      throw NetworkException('User will be created when connection is restored');
    } catch (e) {
      // Wrap unknown errors
      throw UnknownException('Failed to create user: ${e.toString()}');
    }
  }
  
  Future<void> _queueUserCreation(User user) async {
    // Queue the operation for later sync
    await _syncQueue.add(SyncOperation.createUser(user));
  }
}
```

## 📚 Best Practices

### 1. Dependency Abstraction
- **Always define interfaces in domain layer** for external dependencies
- **Wrap network libraries** (Dio, http) behind abstract interfaces
- **Use dependency injection** to provide concrete implementations
- **Keep domain layer pure** - no direct dependency on external packages

### 2. Clean Architecture Benefits
- **Easy migration**: Change HTTP client by updating only data layer
- **Better testing**: Mock interfaces instead of concrete implementations
- **Separation of concerns**: Business logic independent of network libraries
- **Maintainability**: Clear boundaries between layers

### 3. API Design
- Use consistent endpoint naming conventions
- Implement proper HTTP status codes
- Include pagination for list endpoints
- Provide meaningful error messages

### 4. Authentication
- Implement automatic token refresh through abstract interfaces
- Handle authentication failures gracefully
- Store tokens securely using abstract storage interfaces
- Provide clear authentication state

### 5. Caching Strategy
- Cache GET requests through abstract cache interfaces
- Implement cache invalidation strategies
- Use appropriate cache TTL values
- Handle cache consistency

### 6. Error Handling
- Map network library errors to domain exceptions
- Provide user-friendly error messages
- Implement retry mechanisms at the data layer
- Log errors for debugging

### 7. Performance
- Use request/response compression
- Implement request deduplication
- Optimize payload sizes
- Monitor API performance

---

*Effective API integration ensures reliable data flow, robust error handling, and excellent user experience across all network conditions.*
