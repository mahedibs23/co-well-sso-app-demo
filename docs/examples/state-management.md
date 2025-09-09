# State Management Guide

This guide explains how the Flutter Boilerplate implements state management using the MVVM pattern with `ValueNotifier` for reactive UI updates.

## 🎯 State Management Overview

### Architecture Pattern: MVVM
- **Model**: Domain entities and business data
- **View**: Flutter widgets and UI components  
- **ViewModel**: State management and business logic coordination

### State Management Tool: ValueNotifier
- Lightweight reactive state management
- Built into Flutter framework
- Minimal boilerplate code
- Easy to test and debug

## 🏗 MVVM Implementation

### Base ViewModel Structure

```dart
// lib/presentation/base/base_view_model.dart
abstract class BaseViewModel {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<String?> _error = ValueNotifier(null);
  final ValueNotifier<bool> _isDisposed = ValueNotifier(false);

  // Public getters
  ValueListenable<bool> get isLoading => _isLoading;
  ValueListenable<String?> get error => _error;
  ValueListenable<bool> get isDisposed => _isDisposed;

  // State management methods
  void setLoading(bool loading) {
    if (!_isDisposed.value) {
      _isLoading.value = loading;
    }
  }

  void setError(String? error) {
    if (!_isDisposed.value) {
      _error.value = error;
    }
  }

  void clearError() => setError(null);

  // Lifecycle management
  void dispose() {
    _isDisposed.value = true;
    _isLoading.dispose();
    _error.dispose();
    _isDisposed.dispose();
  }
}
```

### Feature-Specific ViewModel

```dart
// Example: UserProfileViewModel
class UserProfileViewModel extends BaseViewModel {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  // State properties
  final ValueNotifier<User?> _user = ValueNotifier(null);
  final ValueNotifier<bool> _isEditing = ValueNotifier(false);
  final ValueNotifier<UserFormData> _formData = ValueNotifier(UserFormData.empty());

  // Public state accessors
  ValueListenable<User?> get user => _user;
  ValueListenable<bool> get isEditing => _isEditing;
  ValueListenable<UserFormData> get formData => _formData;

  UserProfileViewModel(this._getUserUseCase, this._updateUserUseCase);

  // Actions
  Future<void> loadUser(String userId) async {
    try {
      setLoading(true);
      clearError();
      
      final userData = await _getUserUseCase.execute(userId);
      _user.value = userData;
      _formData.value = UserFormData.fromUser(userData);
    } catch (e) {
      setError('Failed to load user: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  void startEditing() {
    _isEditing.value = true;
  }

  void cancelEditing() {
    _isEditing.value = false;
    // Reset form data to original user data
    if (_user.value != null) {
      _formData.value = UserFormData.fromUser(_user.value!);
    }
  }

  void updateFormField(String field, dynamic value) {
    _formData.value = _formData.value.copyWith(field, value);
  }

  Future<void> saveUser() async {
    try {
      setLoading(true);
      clearError();

      final updatedUser = await _updateUserUseCase.execute(
        _user.value!.id,
        _formData.value,
      );
      
      _user.value = updatedUser;
      _isEditing.value = false;
    } catch (e) {
      setError('Failed to save user: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    _user.dispose();
    _isEditing.dispose();
    _formData.dispose();
    super.dispose();
  }
}
```

## 🎨 UI Integration Patterns

### Basic ValueListenableBuilder Usage

```dart
class UserProfileScreen extends StatefulWidget {
  final UserProfileViewModel viewModel;
  
  const UserProfileScreen({required this.viewModel});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadUser(widget.userId);
    });
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: widget.viewModel.isEditing,
            builder: (context, isEditing, child) {
              return IconButton(
                icon: Icon(isEditing ? Icons.save : Icons.edit),
                onPressed: isEditing 
                  ? widget.viewModel.saveUser
                  : widget.viewModel.startEditing,
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.viewModel.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          return ValueListenableBuilder<String?>(
            valueListenable: widget.viewModel.error,
            builder: (context, error, child) {
              if (error != null) {
                return ErrorWidget(
                  error: error,
                  onRetry: () => widget.viewModel.loadUser(widget.userId),
                );
              }
              
              return ValueListenableBuilder<User?>(
                valueListenable: widget.viewModel.user,
                builder: (context, user, child) {
                  if (user == null) {
                    return Center(child: Text('No user data'));
                  }
                  
                  return UserProfileContent(
                    user: user,
                    viewModel: widget.viewModel,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

### Multi-State Listening with Custom Builder

```dart
// Custom widget for listening to multiple ValueNotifiers
class MultiValueListenableBuilder2<T1, T2> extends StatelessWidget {
  final ValueListenable<T1> first;
  final ValueListenable<T2> second;
  final Widget Function(BuildContext context, T1 value1, T2 value2, Widget? child) builder;
  final Widget? child;

  const MultiValueListenableBuilder2({
    Key? key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T1>(
      valueListenable: first,
      builder: (context, value1, child) {
        return ValueListenableBuilder<T2>(
          valueListenable: second,
          builder: (context, value2, _) {
            return builder(context, value1, value2, child);
          },
        );
      },
      child: child,
    );
  }
}

// Usage example
MultiValueListenableBuilder2<User?, bool>(
  first: viewModel.user,
  second: viewModel.isEditing,
  builder: (context, user, isEditing, child) {
    return UserForm(
      user: user,
      isEditing: isEditing,
      onFieldChanged: viewModel.updateFormField,
    );
  },
)
```

## 📊 Complex State Management Patterns

### List State Management

```dart
class ProductListViewModel extends BaseViewModel {
  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;

  // State
  final ValueNotifier<List<Product>> _products = ValueNotifier([]);
  final ValueNotifier<String> _searchQuery = ValueNotifier('');
  final ValueNotifier<ProductFilter> _filter = ValueNotifier(ProductFilter.all);
  final ValueNotifier<bool> _hasMore = ValueNotifier(true);

  // Computed state
  late final ValueNotifier<List<Product>> _filteredProducts;

  ProductListViewModel(this._getProductsUseCase, this._searchProductsUseCase) {
    _filteredProducts = ValueNotifier(_computeFilteredProducts());
    
    // Listen to changes and update computed state
    _products.addListener(_updateFilteredProducts);
    _searchQuery.addListener(_updateFilteredProducts);
    _filter.addListener(_updateFilteredProducts);
  }

  // Getters
  ValueListenable<List<Product>> get products => _products;
  ValueListenable<List<Product>> get filteredProducts => _filteredProducts;
  ValueListenable<String> get searchQuery => _searchQuery;
  ValueListenable<ProductFilter> get filter => _filter;
  ValueListenable<bool> get hasMore => _hasMore;

  // Actions
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _products.value = [];
      _hasMore.value = true;
    }

    if (!_hasMore.value) return;

    try {
      setLoading(true);
      clearError();

      final result = await _getProductsUseCase.execute(
        offset: _products.value.length,
        limit: 20,
      );

      _products.value = [..._products.value, ...result.items];
      _hasMore.value = result.hasMore;
    } catch (e) {
      setError('Failed to load products: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    _debounceSearch();
  }

  void updateFilter(ProductFilter filter) {
    _filter.value = filter;
  }

  Timer? _searchTimer;
  void _debounceSearch() {
    _searchTimer?.cancel();
    _searchTimer = Timer(Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    if (_searchQuery.value.isEmpty) {
      await loadProducts(refresh: true);
      return;
    }

    try {
      setLoading(true);
      clearError();

      final results = await _searchProductsUseCase.execute(_searchQuery.value);
      _products.value = results;
      _hasMore.value = false; // Search results are complete
    } catch (e) {
      setError('Search failed: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  void _updateFilteredProducts() {
    _filteredProducts.value = _computeFilteredProducts();
  }

  List<Product> _computeFilteredProducts() {
    return _products.value.where((product) {
      final matchesFilter = _filter.value == ProductFilter.all ||
          product.category == _filter.value.category;
      return matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _products.dispose();
    _searchQuery.dispose();
    _filter.dispose();
    _filteredProducts.dispose();
    _hasMore.dispose();
    super.dispose();
  }
}
```

### Form State Management

```dart
class UserFormViewModel extends BaseViewModel {
  final ValidateUserUseCase _validateUserUseCase;

  // Form fields
  final ValueNotifier<String> _name = ValueNotifier('');
  final ValueNotifier<String> _email = ValueNotifier('');
  final ValueNotifier<String> _phone = ValueNotifier('');

  // Validation state
  final ValueNotifier<String?> _nameError = ValueNotifier(null);
  final ValueNotifier<String?> _emailError = ValueNotifier(null);
  final ValueNotifier<String?> _phoneError = ValueNotifier(null);

  // Form state
  late final ValueNotifier<bool> _isValid;

  UserFormViewModel(this._validateUserUseCase) {
    _isValid = ValueNotifier(_computeIsValid());
    
    // Listen to field changes for validation
    _name.addListener(_validateName);
    _email.addListener(_validateEmail);
    _phone.addListener(_validatePhone);
    
    // Update form validity
    _nameError.addListener(_updateFormValidity);
    _emailError.addListener(_updateFormValidity);
    _phoneError.addListener(_updateFormValidity);
  }

  // Getters
  ValueListenable<String> get name => _name;
  ValueListenable<String> get email => _email;
  ValueListenable<String> get phone => _phone;
  ValueListenable<String?> get nameError => _nameError;
  ValueListenable<String?> get emailError => _emailError;
  ValueListenable<String?> get phoneError => _phoneError;
  ValueListenable<bool> get isValid => _isValid;

  // Field updates
  void updateName(String value) => _name.value = value;
  void updateEmail(String value) => _email.value = value;
  void updatePhone(String value) => _phone.value = value;

  // Validation
  void _validateName() {
    if (_name.value.isEmpty) {
      _nameError.value = 'Name is required';
    } else if (_name.value.length < 2) {
      _nameError.value = 'Name must be at least 2 characters';
    } else {
      _nameError.value = null;
    }
  }

  void _validateEmail() {
    if (_email.value.isEmpty) {
      _emailError.value = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email.value)) {
      _emailError.value = 'Invalid email format';
    } else {
      _emailError.value = null;
    }
  }

  void _validatePhone() {
    if (_phone.value.isEmpty) {
      _phoneError.value = 'Phone is required';
    } else if (!RegExp(r'^\+?[\d\s-()]+$').hasMatch(_phone.value)) {
      _phoneError.value = 'Invalid phone format';
    } else {
      _phoneError.value = null;
    }
  }

  void _updateFormValidity() {
    _isValid.value = _computeIsValid();
  }

  bool _computeIsValid() {
    return _nameError.value == null &&
           _emailError.value == null &&
           _phoneError.value == null &&
           _name.value.isNotEmpty &&
           _email.value.isNotEmpty &&
           _phone.value.isNotEmpty;
  }

  // Form submission
  Future<User> submitForm() async {
    if (!_isValid.value) {
      throw ValidationException('Form is not valid');
    }

    try {
      setLoading(true);
      clearError();

      final userData = UserFormData(
        name: _name.value,
        email: _email.value,
        phone: _phone.value,
      );

      return await _validateUserUseCase.execute(userData);
    } catch (e) {
      setError('Failed to submit form: ${e.toString()}');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _nameError.dispose();
    _emailError.dispose();
    _phoneError.dispose();
    _isValid.dispose();
    super.dispose();
  }
}
```

## 🔄 State Synchronization Patterns

### Cross-ViewModel Communication

```dart
// Event bus for cross-ViewModel communication
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final StreamController<AppEvent> _controller = StreamController.broadcast();
  
  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }
  
  void emit(AppEvent event) {
    _controller.add(event);
  }
}

// Example events
abstract class AppEvent {}

class UserUpdatedEvent extends AppEvent {
  final User user;
  UserUpdatedEvent(this.user);
}

class UserDeletedEvent extends AppEvent {
  final String userId;
  UserDeletedEvent(this.userId);
}

// ViewModel listening to events
class UserListViewModel extends BaseViewModel {
  late StreamSubscription _userUpdatedSubscription;
  late StreamSubscription _userDeletedSubscription;

  UserListViewModel() {
    _userUpdatedSubscription = EventBus().on<UserUpdatedEvent>().listen(_onUserUpdated);
    _userDeletedSubscription = EventBus().on<UserDeletedEvent>().listen(_onUserDeleted);
  }

  void _onUserUpdated(UserUpdatedEvent event) {
    final currentUsers = _users.value;
    final updatedUsers = currentUsers.map((user) {
      return user.id == event.user.id ? event.user : user;
    }).toList();
    _users.value = updatedUsers;
  }

  void _onUserDeleted(UserDeletedEvent event) {
    final currentUsers = _users.value;
    final filteredUsers = currentUsers.where((user) => user.id != event.userId).toList();
    _users.value = filteredUsers;
  }

  @override
  void dispose() {
    _userUpdatedSubscription.cancel();
    _userDeletedSubscription.cancel();
    super.dispose();
  }
}
```

### Global State Management

```dart
// App-level state manager
class AppStateManager {
  static final AppStateManager _instance = AppStateManager._internal();
  factory AppStateManager() => _instance;
  AppStateManager._internal();

  // Global state
  final ValueNotifier<User?> currentUser = ValueNotifier(null);
  final ValueNotifier<AppTheme> theme = ValueNotifier(AppTheme.light);
  final ValueNotifier<Locale> locale = ValueNotifier(Locale('en'));
  final ValueNotifier<bool> isOnline = ValueNotifier(true);

  // Authentication state
  bool get isAuthenticated => currentUser.value != null;

  void setCurrentUser(User? user) {
    currentUser.value = user;
    if (user != null) {
      EventBus().emit(UserLoggedInEvent(user));
    } else {
      EventBus().emit(UserLoggedOutEvent());
    }
  }

  void setTheme(AppTheme newTheme) {
    theme.value = newTheme;
    // Persist theme preference
    _persistTheme(newTheme);
  }

  void setLocale(Locale newLocale) {
    locale.value = newLocale;
    // Persist locale preference
    _persistLocale(newLocale);
  }

  void setOnlineStatus(bool online) {
    isOnline.value = online;
    EventBus().emit(ConnectivityChangedEvent(online));
  }

  Future<void> _persistTheme(AppTheme theme) async {
    // Save to shared preferences
  }

  Future<void> _persistLocale(Locale locale) async {
    // Save to shared preferences
  }
}
```

## 🧪 Testing State Management

### ViewModel Testing

```dart
// test/unit/view_model/user_profile_view_model_test.dart
class MockGetUserUseCase extends Mock implements GetUserUseCase {}
class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}

void main() {
  group('UserProfileViewModel', () {
    late UserProfileViewModel viewModel;
    late MockGetUserUseCase mockGetUserUseCase;
    late MockUpdateUserUseCase mockUpdateUserUseCase;

    setUp(() {
      mockGetUserUseCase = MockGetUserUseCase();
      mockUpdateUserUseCase = MockUpdateUserUseCase();
      viewModel = UserProfileViewModel(mockGetUserUseCase, mockUpdateUserUseCase);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('should load user successfully', () async {
      // Arrange
      final user = User(id: '1', name: 'John Doe', email: 'john@example.com');
      when(mockGetUserUseCase.execute('1')).thenAnswer((_) async => user);

      // Act
      await viewModel.loadUser('1');

      // Assert
      expect(viewModel.user.value, equals(user));
      expect(viewModel.isLoading.value, isFalse);
      expect(viewModel.error.value, isNull);
    });

    test('should handle load user error', () async {
      // Arrange
      when(mockGetUserUseCase.execute('1')).thenThrow(Exception('Network error'));

      // Act
      await viewModel.loadUser('1');

      // Assert
      expect(viewModel.user.value, isNull);
      expect(viewModel.isLoading.value, isFalse);
      expect(viewModel.error.value, contains('Failed to load user'));
    });

    test('should update form field', () {
      // Arrange
      final initialFormData = UserFormData.empty();
      viewModel.formData.value = initialFormData;

      // Act
      viewModel.updateFormField('name', 'John Doe');

      // Assert
      expect(viewModel.formData.value.name, equals('John Doe'));
    });
  });
}
```

### Widget Testing with State

```dart
// test/widget/user_profile_screen_test.dart
void main() {
  group('UserProfileScreen', () {
    late MockUserProfileViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockUserProfileViewModel();
    });

    testWidgets('should display loading indicator when loading', (tester) async {
      // Arrange
      when(mockViewModel.isLoading).thenReturn(ValueNotifier(true));
      when(mockViewModel.error).thenReturn(ValueNotifier(null));
      when(mockViewModel.user).thenReturn(ValueNotifier(null));

      // Act
      await tester.pumpWidget(MaterialApp(
        home: UserProfileScreen(viewModel: mockViewModel),
      ));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display user data when loaded', (tester) async {
      // Arrange
      final user = User(id: '1', name: 'John Doe', email: 'john@example.com');
      when(mockViewModel.isLoading).thenReturn(ValueNotifier(false));
      when(mockViewModel.error).thenReturn(ValueNotifier(null));
      when(mockViewModel.user).thenReturn(ValueNotifier(user));
      when(mockViewModel.isEditing).thenReturn(ValueNotifier(false));

      // Act
      await tester.pumpWidget(MaterialApp(
        home: UserProfileScreen(viewModel: mockViewModel),
      ));

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });
  });
}
```

## 🚀 Performance Optimization

### Efficient State Updates

```dart
// Batch state updates to minimize rebuilds
class OptimizedViewModel extends BaseViewModel {
  final ValueNotifier<ViewState> _state = ValueNotifier(ViewState.initial());

  ValueListenable<ViewState> get state => _state;

  void updateMultipleFields({
    String? name,
    String? email,
    bool? isActive,
  }) {
    _state.value = _state.value.copyWith(
      name: name,
      email: email,
      isActive: isActive,
    );
  }
}

// Immutable state class
class ViewState {
  final String name;
  final String email;
  final bool isActive;
  final bool isLoading;

  const ViewState({
    required this.name,
    required this.email,
    required this.isActive,
    required this.isLoading,
  });

  factory ViewState.initial() => ViewState(
    name: '',
    email: '',
    isActive: false,
    isLoading: false,
  );

  ViewState copyWith({
    String? name,
    String? email,
    bool? isActive,
    bool? isLoading,
  }) {
    return ViewState(
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
```

### Selective Rebuilds

```dart
// Use specific ValueListenableBuilders for targeted updates
class OptimizedUserForm extends StatelessWidget {
  final UserFormViewModel viewModel;

  const OptimizedUserForm({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only rebuilds when name changes
        ValueListenableBuilder<String>(
          valueListenable: viewModel.name,
          builder: (context, name, child) {
            return TextFormField(
              initialValue: name,
              onChanged: viewModel.updateName,
              decoration: InputDecoration(labelText: 'Name'),
            );
          },
        ),
        
        // Only rebuilds when email changes
        ValueListenableBuilder<String>(
          valueListenable: viewModel.email,
          builder: (context, email, child) {
            return TextFormField(
              initialValue: email,
              onChanged: viewModel.updateEmail,
              decoration: InputDecoration(labelText: 'Email'),
            );
          },
        ),
        
        // Only rebuilds when form validity changes
        ValueListenableBuilder<bool>(
          valueListenable: viewModel.isValid,
          builder: (context, isValid, child) {
            return ElevatedButton(
              onPressed: isValid ? viewModel.submitForm : null,
              child: Text('Submit'),
            );
          },
        ),
      ],
    );
  }
}
```

## 📚 Best Practices

### 1. State Organization
- Keep ViewModels focused on single responsibilities
- Use computed properties for derived state
- Implement proper disposal to prevent memory leaks

### 2. UI Integration
- Use ValueListenableBuilder for reactive updates
- Minimize rebuild scope with targeted listeners
- Handle loading and error states consistently

### 3. Testing
- Test ViewModels independently of UI
- Mock dependencies for isolated testing
- Verify state changes and side effects

### 4. Performance
- Batch related state updates
- Use immutable state objects
- Implement efficient equality checks

---

*Effective state management with MVVM and ValueNotifier provides a clean, testable, and performant foundation for Flutter applications.*
