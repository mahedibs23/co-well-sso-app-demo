# Flutter Development Best Practices

> **Cross-Reference:** This document is part of the comprehensive development workflow. See also:
> - [Development Overview](./README.md)
> - [Coding Standards](../../.llm-context/development/coding-standards.md)
> - [Testing Strategy](../../.llm-context/development/testing-strategy.md)

## Overview

This guide outlines essential best practices for Flutter application development to ensure code quality, maintainability, and scalability in our boilerplate project.

## 🎯 Objectives

- Understand key Flutter development practices
- Apply practices to enhance code quality and project management
- Maintain consistency across the development team
- Ensure long-term project maintainability

## 📋 Table of Contents

1. [Dart Coding Guidelines](#dart-coding-guidelines)
2. [Project Structure](#project-structure)
3. [Architecture Patterns](#architecture-patterns)
4. [Design Principles](#design-principles)
5. [Code Quality](#code-quality)
6. [Testing Practices](#testing-practices)
7. [Security Considerations](#security-considerations)
8. [Version Control](#version-control)
9. [Automation](#automation)

## 🎨 Dart Coding Guidelines

### Code Formatting
- **Automatic Formatting:** Use `dart format` to maintain consistent code style
- **Style Guide:** Adhere to the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- **IDE Integration:** Configure your IDE to format on save

### Naming Conventions
```dart
// ✅ Good - Function names (camelCase)
void calculateTotalAmount() {}
void processUserData() {}

// ✅ Good - Variable names (camelCase)
final String userName = 'john_doe';
final int userAge = 25;

// ✅ Good - Class names (PascalCase)
class UserRepository {}
class AuthenticationService {}

// ✅ Good - Constants (camelCase with const/final)
const String apiBaseUrl = 'https://api.example.com';
final DateTime appStartTime = DateTime.now();
```

### Constants Management
```dart
// ✅ Centralized constants
class AppConstants {
  static const String appName = 'Flutter Boilerplate';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
}

// ✅ Environment-specific constants
class ApiConstants {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');
  static const String apiKey = String.fromEnvironment('API_KEY');
}
```

## 🏗 Project Structure

### Feature-Based Organization
Our project follows a feature-based structure as documented in [Folder Structure](../architecture/folder-structure.md):

```
lib/
├── presentation/           # UI layer
│   ├── features/          # Feature-specific UI
│   ├── common/            # Shared UI components
│   └── base/              # Base classes
├── domain/                # Business logic layer
└── data/                  # Data access layer
```

### Benefits
- **Modularity:** Clear separation of concerns
- **Scalability:** Easy to add new features
- **Navigation:** Intuitive project structure
- **Team Collaboration:** Parallel development support

## 🏛 Architecture Patterns

### MVVM Implementation
Following our [Architecture Overview](../architecture/README.md):

```dart
// ✅ ViewModel example
class UserViewModel extends ChangeNotifier {
  final UserRepository _repository;
  
  UserViewModel(this._repository);
  
  User? _user;
  User? get user => _user;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  Future<void> loadUser(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await _repository.getUser(userId);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### Repository Pattern
```dart
// ✅ Abstract repository
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getUsers();
  Future<void> saveUser(User user);
}

// ✅ Concrete implementation
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  
  UserRepositoryImpl(this._remoteDataSource, this._localDataSource);
  
  @override
  Future<User> getUser(String id) async {
    try {
      final user = await _remoteDataSource.getUser(id);
      await _localDataSource.cacheUser(user);
      return user;
    } catch (e) {
      return await _localDataSource.getUser(id);
    }
  }
}
```

## 🎯 Design Principles

### SOLID Principles

#### Single Responsibility Principle (SRP)
```dart
// ✅ Good - Single responsibility
class UserValidator {
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class UserService {
  Future<void> createUser(User user) async {
    // Only handles user creation logic
  }
}
```

#### Open/Closed Principle (OCP)
```dart
// ✅ Open for extension, closed for modification
abstract class PaymentProcessor {
  Future<PaymentResult> processPayment(Payment payment);
}

class CreditCardProcessor extends PaymentProcessor {
  @override
  Future<PaymentResult> processPayment(Payment payment) async {
    // Credit card specific implementation
  }
}

class PayPalProcessor extends PaymentProcessor {
  @override
  Future<PaymentResult> processPayment(Payment payment) async {
    // PayPal specific implementation
  }
}
```

### KISS Principle (Keep It Simple, Stupid)
```dart
// ✅ Simple and clear
String formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

// ❌ Over-engineered
class CurrencyFormatterFactory {
  static CurrencyFormatter createFormatter(CurrencyType type) {
    // Unnecessary complexity for simple formatting
  }
}
```

### DRY Principle (Don't Repeat Yourself)
```dart
// ✅ Reusable widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? const CircularProgressIndicator()
        : Text(text),
    );
  }
}
```

## 🔍 Code Quality

### Custom Linting
Configure `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - prefer_final_locals
    - unnecessary_null_checks
```

### Clean Code Practices
```dart
// ✅ Clean, readable code
class AuthenticationService {
  static const int _maxLoginAttempts = 3;
  
  final ApiClient _apiClient;
  final SecureStorage _storage;
  
  AuthenticationService(this._apiClient, this._storage);
  
  Future<AuthResult> login(String email, String password) async {
    if (!_isValidEmail(email)) {
      return AuthResult.invalidEmail();
    }
    
    try {
      final response = await _apiClient.login(email, password);
      await _storage.saveToken(response.token);
      return AuthResult.success(response.user);
    } on NetworkException {
      return AuthResult.networkError();
    } catch (e) {
      return AuthResult.unknownError();
    }
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

## 🧪 Testing Practices

### Test-Driven Development (TDD)
1. **Write Test:** Create failing test first
2. **Implement Code:** Write minimal code to pass
3. **Refactor:** Improve code while keeping tests green

```dart
// ✅ Unit test example
void main() {
  group('UserValidator', () {
    late UserValidator validator;
    
    setUp(() {
      validator = UserValidator();
    });
    
    test('should return true for valid email', () {
      // Arrange
      const email = 'test@example.com';
      
      // Act
      final result = validator.isValidEmail(email);
      
      // Assert
      expect(result, isTrue);
    });
    
    test('should return false for invalid email', () {
      // Arrange
      const email = 'invalid-email';
      
      // Act
      final result = validator.isValidEmail(email);
      
      // Assert
      expect(result, isFalse);
    });
  });
}
```

### Code Coverage
```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔒 Security Considerations

Key security practices (detailed in [Security Guide](./security.md)):

- **Code Obfuscation:** Enable for release builds
- **Secure Storage:** Use `flutter_secure_storage` for sensitive data
- **API Security:** Implement proper authentication and encryption
- **Certificate Pinning:** Prevent MITM attacks

## 🌿 Version Control

### Git Flow Strategy
Follow our [Git Workflow](../workflow/git-branching.md) for the complete 4-environment branching strategy and deployment process.

### Commit Message Format
Follow the standards defined in [Commits](../workflow/commits.md) for consistent commit message formatting.

## 🤖 Automation

### Code Generation
```bash
# Generate code for models, repositories, etc.
dart run build_runner build

# Watch for changes during development
dart run build_runner watch
```

### Static Analysis
```bash
# Run static analysis
dart analyze

# Fix auto-fixable issues
dart fix --apply
```

## 📊 Metrics and Monitoring

### Performance Monitoring
- Use Flutter DevTools for performance analysis
- Monitor app size and build times
- Track widget rebuild frequency

### Code Quality Metrics
- Maintain high test coverage (>80%)
- Monitor cyclomatic complexity
- Track technical debt

## 🎓 Learning Resources

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

## 🤝 Team Collaboration

### Code Review Checklist
- [ ] Follows coding standards
- [ ] Includes appropriate tests
- [ ] Documentation updated
- [ ] No hardcoded values
- [ ] Error handling implemented
- [ ] Performance considerations addressed

### Knowledge Sharing
- Regular code review sessions
- Architecture decision documentation
- Best practices workshops
- Pair programming sessions

---

## 📝 Summary

Following these best practices ensures:
- **Quality:** Maintainable and reliable code
- **Consistency:** Uniform development approach
- **Scalability:** Easy project growth
- **Team Efficiency:** Smooth collaboration
- **Security:** Protected application and data

For implementation details and examples, refer to the specific documentation sections linked throughout this guide.
