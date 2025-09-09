# Environment Setup Guide

This guide will walk you through setting up environment variables and configuration for the Flutter Boilerplate project across different build flavors.

## 🎯 Overview

The Flutter Boilerplate uses environment-specific configuration to manage:
- API endpoints and base URLs
- Authentication keys and secrets
- Feature flags and toggles
- Database connections
- Third-party service configurations

## 📁 Environment File Structure

```
env/
├── .env.dev.json                  # Development environment (JSON format)
├── .env.test.json                 # Test environment (JSON format)
├── .env.staging.json              # Staging environment (JSON format)
├── .env.prod.json                 # Production environment (JSON format)
└── README.md                      # Environment documentation
```

## 🚀 Quick Setup

### 1. Create Environment Files

```bash
# Navigate to project root
cd flutter-boilerplate

# Create environment files for each environment
touch env/.env.dev.json
touch env/.env.test.json
touch env/.env.staging.json
touch env/.env.prod.json
```

### 2. Configure Development Environment

Edit `env/.env.dev.json`:
```json
{
  "API_BASE_URL": "https://api-dev.yourapp.com",
  "API_VERSION": "v1",
  "API_TIMEOUT": "30000",
  "AUTH_CLIENT_ID": "your_dev_client_id",
  "AUTH_CLIENT_SECRET": "your_dev_client_secret",
  "JWT_SECRET": "your_dev_jwt_secret",
  "DATABASE_URL": "https://dev-database.yourapp.com",
  "DATABASE_NAME": "yourapp_dev",
  "ENABLE_DEBUG_LOGGING": "true",
  "ENABLE_ANALYTICS": "false",
  "ENABLE_CRASH_REPORTING": "false",
  "ENABLE_PERFORMANCE_MONITORING": "false",
  "FIREBASE_PROJECT_ID": "yourapp-dev",
  "GOOGLE_MAPS_API_KEY": "your_dev_maps_key",
  "STRIPE_PUBLISHABLE_KEY": "pk_test_your_dev_stripe_key",
  "APP_NAME": "Your App Dev",
  "APP_VERSION": "1.0.0-dev",
  "BUILD_NUMBER": "1"
}
```

### 3. Configure Other Environments

**Test Environment** (`env/.env.test.json`):
```json
{
  "API_BASE_URL": "https://api-test.yourapp.com",
  "AUTH_CLIENT_ID": "your_test_client_id",
  "ENABLE_DEBUG_LOGGING": "true",
  "ENABLE_ANALYTICS": "false",
  "APP_NAME": "Your App Test"
}
```

**Staging Environment** (`env/.env.staging.json`):
```json
{
  "API_BASE_URL": "https://api-staging.yourapp.com",
  "AUTH_CLIENT_ID": "your_staging_client_id",
  "ENABLE_DEBUG_LOGGING": "false",
  "ENABLE_ANALYTICS": "true",
  "ENABLE_CRASH_REPORTING": "true",
  "APP_NAME": "Your App Staging"
}
```

**Production Environment** (`env/.env.prod.json`):
```json
{
  "API_BASE_URL": "https://api.yourapp.com",
  "AUTH_CLIENT_ID": "your_prod_client_id",
  "ENABLE_DEBUG_LOGGING": "false",
  "ENABLE_ANALYTICS": "true",
  "ENABLE_CRASH_REPORTING": "true",
  "ENABLE_PERFORMANCE_MONITORING": "true",
  "APP_NAME": "Your App"
}
```

## ⚙️ Environment Variable Categories

### 1. API Configuration
```json
{
  "API_BASE_URL": "https://api.yourapp.com",
  "API_VERSION": "v1",
  "API_TIMEOUT": "30000",
  "API_RETRY_COUNT": "3",
  "AUTH_LOGIN_ENDPOINT": "/auth/login",
  "AUTH_REFRESH_ENDPOINT": "/auth/refresh",
  "AUTH_LOGOUT_ENDPOINT": "/auth/logout"
}
```

### 2. Authentication & Security
```json
{
  "AUTH_CLIENT_ID": "your_client_id",
  "AUTH_CLIENT_SECRET": "your_client_secret",
  "AUTH_REDIRECT_URI": "yourapp://auth/callback",
  "JWT_SECRET": "your_jwt_secret",
  "JWT_EXPIRY": "3600",
  "ENCRYPTION_KEY": "your_encryption_key",
  "SALT": "your_salt_value"
}
```

### 3. Database Configuration
```json
{
  "DATABASE_URL": "https://database.yourapp.com",
  "DATABASE_NAME": "yourapp_db",
  "DATABASE_USER": "db_user",
  "DATABASE_PASSWORD": "db_password",
  "REDIS_URL": "redis://cache.yourapp.com:6379",
  "CACHE_TTL": "3600"
}
```

### 4. Feature Flags
```json
{
  "ENABLE_DEBUG_LOGGING": "true",
  "ENABLE_DEBUG_OVERLAY": "true",
  "ENABLE_NETWORK_LOGGING": "true",
  "ENABLE_ANALYTICS": "true",
  "ENABLE_CRASH_REPORTING": "true",
  "ENABLE_PERFORMANCE_MONITORING": "true",
  "ENABLE_USER_TRACKING": "true",
  "ENABLE_DARK_MODE": "true",
  "ENABLE_BIOMETRIC_AUTH": "true",
  "ENABLE_PUSH_NOTIFICATIONS": "true",
  "ENABLE_OFFLINE_MODE": "true"
}
```

### 5. Third-Party Services
```json
{
  "FIREBASE_PROJECT_ID": "your-firebase-project",
  "FIREBASE_API_KEY": "your_firebase_api_key",
  "FIREBASE_APP_ID": "your_firebase_app_id",
  "GOOGLE_MAPS_API_KEY": "your_google_maps_key",
  "GOOGLE_ANALYTICS_ID": "GA-XXXXXXXXX",
  "STRIPE_PUBLISHABLE_KEY": "pk_live_or_test_key",
  "PAYPAL_CLIENT_ID": "your_paypal_client_id",
  "GOOGLE_CLIENT_ID": "your_google_oauth_client_id",
  "FACEBOOK_APP_ID": "your_facebook_app_id",
  "APPLE_CLIENT_ID": "your_apple_client_id"
}
```

### 6. App Metadata
```json
{
  "APP_NAME": "Your App Name",
  "APP_VERSION": "1.0.0",
  "BUILD_NUMBER": "1",
  "BUNDLE_ID": "com.yourcompany.yourapp",
  "APP_STORE_ID": "123456789",
  "PLAY_STORE_ID": "com.yourcompany.yourapp"
}
```

## 🔧 Using Environment Variables in Code

### 1. App Configuration Class

The project uses `AppConfig` class to access environment variables:

```dart
// lib/presentation/app/app_config.dart
class AppConfig {
  static String get apiBaseUrl => _getEnvVar('API_BASE_URL');
  static String get apiVersion => _getEnvVar('API_VERSION');
  static int get apiTimeout => int.parse(_getEnvVar('API_TIMEOUT'));
  
  static String get authClientId => _getEnvVar('AUTH_CLIENT_ID');
  static String get authClientSecret => _getEnvVar('AUTH_CLIENT_SECRET');
  
  static bool get enableDebugLogging => 
      _getEnvVar('ENABLE_DEBUG_LOGGING').toLowerCase() == 'true';
  static bool get enableAnalytics => 
      _getEnvVar('ENABLE_ANALYTICS').toLowerCase() == 'true';
  
  static String _getEnvVar(String key) {
    return const String.fromEnvironment(key, defaultValue: '');
  }
}
```

### 2. Using Configuration in Code

```dart
// Example: API client configuration
class ApiClient {
  static final String baseUrl = AppConfig.apiBaseUrl;
  static final Duration timeout = Duration(milliseconds: AppConfig.apiTimeout);
  
  static Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: '$baseUrl/${AppConfig.apiVersion}',
      connectTimeout: timeout,
      receiveTimeout: timeout,
    ));
    
    if (AppConfig.enableDebugLogging) {
      dio.interceptors.add(LogInterceptor());
    }
    
    return dio;
  }
}
```

### 3. Feature Flag Usage

```dart
// Example: Conditional feature rendering
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Always visible content
          MainContent(),
          
          // Conditionally visible based on feature flag
          if (AppConfig.enableAnalytics)
            AnalyticsWidget(),
          
          // Debug-only content
          if (AppConfig.enableDebugLogging && kDebugMode)
            DebugPanel(),
        ],
      ),
    );
  }
}
```

## 🏗 Build Integration

### 1. Flutter Build Arguments

Environment variables are passed during build using JSON files:

```bash
# Development build
flutter build apk \
  --flavor flavor_dev \
  -t lib/main/main_flavor_dev.dart \
  --dart-define-from-file=env/.env.dev.json

# Production build
flutter build apk \
  --flavor flavor_prod \
  -t lib/main/main_flavor_prod.dart \
  --dart-define-from-file=env/.env.prod.json
```

### 2. IDE Run Configuration

The project includes pre-configured run configurations that automatically load the correct environment:

- `flavor_dev` → loads `env/.env.dev.json`
- `flavor_test` → loads `env/.env.test.json`
- `flavor_staging` → loads `env/.env.staging.json`
- `flavor_prod` → loads `env/.env.prod.json`

## 🔐 Security Best Practices

### 1. Environment File Security

**DO:**
- ✅ Use different secrets for each environment
- ✅ Rotate secrets regularly
- ✅ Use strong, unique passwords and keys
- ✅ Encrypt sensitive environment files
- ✅ Use environment-specific service accounts

**DON'T:**
- ❌ Commit real secrets to version control
- ❌ Use production secrets in development
- ❌ Share secrets via insecure channels
- ❌ Use weak or default passwords
- ❌ Hardcode secrets in source code

### 2. Encrypted Environment Files

For sensitive production environments, the project includes an encryption system:

```bash
# Encrypt environment files using the project's encrypt-env script
# In Android Studio: Run the 'encrypt-env' run configuration
# Or manually run the encryption script

# This will encrypt your .env.*.json files for secure storage
```

**Environment File Encryption Process:**
1. Create your environment JSON files (e.g., `.env.prod.json`)
2. Run the `encrypt-env` configuration in Android Studio
3. The encrypted files will be generated for secure storage
4. The original JSON files should not be committed to version control

### 3. CI/CD Integration

Store secrets in your CI/CD platform's secret management:

**GitHub Actions:**
```yaml
# .github/workflows/build.yml
env:
  API_BASE_URL: ${{ secrets.API_BASE_URL }}
  AUTH_CLIENT_ID: ${{ secrets.AUTH_CLIENT_ID }}
  AUTH_CLIENT_SECRET: ${{ secrets.AUTH_CLIENT_SECRET }}
```

**GitLab CI:**
```yaml
# .gitlab-ci.yml
variables:
  API_BASE_URL: $API_BASE_URL
  AUTH_CLIENT_ID: $AUTH_CLIENT_ID
  AUTH_CLIENT_SECRET: $AUTH_CLIENT_SECRET
```

## ✅ Verification Steps

### 1. Test Environment Loading

```dart
// Add to your app's debug screen
class EnvironmentDebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Environment Debug')),
      body: ListView(
        children: [
          ListTile(
            title: Text('API Base URL'),
            subtitle: Text(AppConfig.apiBaseUrl),
          ),
          ListTile(
            title: Text('Environment'),
            subtitle: Text(AppConfig.environment),
          ),
          ListTile(
            title: Text('Debug Logging'),
            subtitle: Text(AppConfig.enableDebugLogging.toString()),
          ),
          // Add more configuration items
        ],
      ),
    );
  }
}
```

### 2. Test API Connectivity

```bash
# Test development API
curl -X GET "${API_BASE_URL}/health" \
  -H "Authorization: Bearer ${AUTH_CLIENT_ID}"

# Verify response
echo "API Status: $?"
```

### 3. Validate Build Configuration

```bash
# Build and inspect APK
flutter build apk --flavor flavor_dev -t lib/main/main_flavor_dev.dart
aapt dump badging build/app/outputs/flutter-apk/app-flavor_dev-debug.apk

# Check app name and package
grep -E "(application-label|package)" build_output.txt
```

## 🚨 Troubleshooting

### Common Issues

**Issue: Environment variables not loading**
```bash
# Check file exists and has correct syntax
ls -la env/.env.dev
cat env/.env.dev | grep -E "^[A-Z_]+=.*"

# Verify no syntax errors
flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart --verbose
```

**Issue: Wrong environment loaded**
```bash
# Check run configuration
cat .idea/runConfigurations/flavor_dev.xml | grep "dart-define-from-file"

# Verify flavor selection
flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart --verbose | grep "flavor"
```

**Issue: API calls failing**
```bash
# Test API endpoint
curl -v "${API_BASE_URL}/health"

# Check network connectivity
ping api-dev.yourapp.com

# Verify SSL certificates
openssl s_client -connect api-dev.yourapp.com:443
```

### Debug Environment Loading

Add debug logging to verify environment loading:

```dart
// In main.dart
void main() {
  // Debug environment variables
  if (kDebugMode) {
    print('Environment Debug:');
    print('API_BASE_URL: ${AppConfig.apiBaseUrl}');
    print('ENABLE_DEBUG_LOGGING: ${AppConfig.enableDebugLogging}');
    print('APP_NAME: ${AppConfig.appName}');
  }
  
  runApp(MyApp());
}
```

## 📚 Next Steps

After setting up environment configuration:

1. **[Build Flavors](build-flavors.md)** - Understand how flavors use environments
2. **[Secrets Management](secrets-management.md)** - Advanced security practices
3. **[Firebase Setup](firebase-setup.md)** - Configure Firebase services
4. **[Development Workflow](../development/coding-guidelines.md)** - Start development

## 🆘 Getting Help

For environment setup issues:
1. Check syntax of environment files
2. Verify file paths and permissions
3. Test with minimal configuration
4. Review build logs for errors
5. Create an issue with environment details (without secrets)

---

*Proper environment setup is crucial for seamless development across different stages of your application lifecycle.*
