# Architecture Overview

The Flutter Boilerplate follows **MVVM (Model-View-ViewModel) Clean Architecture** principles to ensure scalability, maintainability, and testability.

## 🏗 Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)
- **Views**: Flutter widgets and screens
- **ViewModels**: Business logic and state management
- **Navigation**: Route management and deep linking

### 2. Domain Layer (`domain/`)
- **Use Cases**: Business rules and application logic
- **Entities**: Core business models
- **Repository Interfaces**: Data access contracts

### 3. Data Layer (`data/`)
- **Repositories**: Data access implementations
- **Data Sources**: API clients and local storage
- **Models**: Data transfer objects and serialization

## 📁 Project Structure

```
flutter-boilerplate/
├── lib/                           # Main application code
│   ├── main/                      # Entry points for different flavors
│   └── presentation/              # UI layer (Views, ViewModels, Widgets)
├── domain/                        # Business logic layer (separate package)
├── data/                          # Data access layer (separate package)
├── assets/                        # Static assets (images, fonts, etc.)
├── android/                       # Android-specific code
├── ios/                          # iOS-specific code
└── docs/                         # Developer documentation
```

## 🔄 Data Flow

```
View → ViewModel → Use Case → Repository → Data Source
  ↑                                              ↓
  └──────────── State Updates ←──────────────────┘
```

## 🎯 Key Design Principles

### 1. **Separation of Concerns**
- Each layer has a single responsibility
- Clear boundaries between UI, business logic, and data

### 2. **Dependency Inversion**
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- **Network libraries** (Dio, http) are wrapped in abstract interfaces in domain layer
- **External dependencies** (databases, APIs, storage) are abstracted behind interfaces

### 3. **Modular Architecture**
- Domain and Data layers are separate Flutter packages
- **Domain package** contains only abstract interfaces and business entities
- **Data package** implements domain interfaces with concrete dependencies
- Easy to test and maintain independently

### 4. **State Management**
- Uses `ValueNotifier` for reactive state management
- Predictable state updates and UI rebuilds

## 📚 Detailed Guides

### Core Architecture
- **[Folder Structure](folder-structure.md)** - Complete project organization
- **[Data Flow](data-flow.md)** - How data moves through layers
- **[State Management](state-management.md)** - MVVM implementation with ValueNotifier

### Advanced Topics
- **[Dependency Injection](dependency-injection.md)** - Custom DI container usage
- **[Navigation](navigation.md)** - Route management and deep linking
- **[Error Handling](error-handling.md)** - Exception management across layers

## 🔧 Implementation Examples

### Creating a New Feature

1. **Define Entity** (Domain Layer)
```dart
// domain/lib/model/user.dart
class User {
  final String id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
}
```

2. **Create Use Case** (Domain Layer)
```dart
// domain/lib/use_case/get_user_use_case.dart
class GetUserUseCase {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  Future<User> execute(String userId) => repository.getUser(userId);
}
```

3. **Define Abstract DataSource** (Domain Layer)
```dart
// domain/lib/datasource/user_datasource.dart
abstract class UserDataSource {
  Future<User> getUser(String userId);
  Future<List<User>> getUsers();
  Future<User> createUser(User user);
}
```

4. **Implement Repository** (Data Layer)
```dart
// data/lib/repository/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserDataSource _remoteDataSource;
  final UserDataSource _localDataSource;
  
  UserRepositoryImpl(this._remoteDataSource, this._localDataSource);
  
  @override
  Future<User> getUser(String userId) async {
    try {
      // Try remote first
      final user = await _remoteDataSource.getUser(userId);
      // Cache locally
      await _localDataSource.createUser(user);
      return user;
    } catch (e) {
      // Fallback to local cache
      return await _localDataSource.getUser(userId);
    }
  }
}
```

5. **Create ViewModel** (Presentation Layer)
```dart
// lib/presentation/user/user_view_model.dart
class UserViewModel extends BaseViewModel {
  final GetUserUseCase getUserUseCase;
  
  final ValueNotifier<User?> user = ValueNotifier(null);
  
  UserViewModel(this.getUserUseCase);
  
  Future<void> loadUser(String userId) async {
    try {
      setLoading(true);
      final userData = await getUserUseCase.execute(userId);
      user.value = userData;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
```

6. **Build View** (Presentation Layer)
```dart
// lib/presentation/user/user_screen.dart
class UserScreen extends StatelessWidget {
  final UserViewModel viewModel;
  
  UserScreen({required this.viewModel});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<User?>(
        valueListenable: viewModel.user,
        builder: (context, user, child) {
          if (user == null) return CircularProgressIndicator();
          return Text('Hello, ${user.name}!');
        },
      ),
    );
  }
}
```

## 🎨 Architecture Benefits

### ✅ Advantages

1. **Testability**
   - Each layer can be tested independently
   - Easy to mock dependencies
   - Clear separation of concerns

2. **Maintainability**
   - Changes in one layer don't affect others
   - Easy to locate and fix bugs
   - Consistent code organization

3. **Scalability**
   - Easy to add new features
   - Modular structure supports team development
   - Clear patterns for implementation

4. **Flexibility**
   - **Easy dependency migration**: Change HTTP clients, databases, or storage without affecting business logic
   - **UI independence**: UI can be modified without affecting business logic
   - **Platform support**: Abstract interfaces work across all platforms
   - **Testing flexibility**: Mock any external dependency through interfaces

### ⚠️ Considerations

1. **Initial Complexity**
   - More files and structure than simple approaches
   - Learning curve for new developers
   - Setup overhead for small features

2. **Boilerplate Code**
   - More interfaces and implementations
   - Additional abstraction layers
   - Code generation helps mitigate this

## 🚀 Getting Started

### For New Developers
1. Read [Folder Structure](folder-structure.md) to understand organization
2. Follow [Data Flow](data-flow.md) to see how components interact
3. Study [State Management](state-management.md) for UI patterns
4. Use the feature generation script for consistent implementation

### For Experienced Developers
1. Review [Dependency Injection](dependency-injection.md) for DI patterns
2. Understand [Navigation](navigation.md) for routing strategies
3. Check [Error Handling](error-handling.md) for exception management
4. Explore existing features as implementation examples

## 📖 Additional Resources

- **[Clean Architecture by Robert Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)**
- **[Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)**
- **[MVVM Pattern in Flutter](https://flutter.dev/docs/development/data-and-backend/state-mgmt)**

---

*This architecture provides a solid foundation for building scalable Flutter applications while maintaining code quality and developer productivity.*
