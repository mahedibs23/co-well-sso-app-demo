# Flutter Boilerplate - Troubleshooting Guide

## Common Build Issues

### Flutter Build Failures

#### Flutter Doctor Issues
**Symptoms**: Flutter doctor shows errors or warnings
**Causes**: Missing dependencies, outdated SDK, configuration issues
**Solutions**:
```bash
# Run Flutter doctor to identify issues
flutter doctor -v

# Update Flutter SDK
flutter upgrade

# Accept Android licenses
flutter doctor --android-licenses

# Clear Flutter cache
flutter clean
flutter pub get

# Reset Flutter configuration
flutter config --clear-features
```

#### Pub Get Failures
**Symptoms**: `pub get` fails with dependency resolution errors
**Causes**: Version conflicts, network issues, corrupted pub cache
**Solutions**:
```bash
# Clear pub cache
flutter pub cache clean
flutter pub cache repair

# Update dependencies
flutter pub upgrade

# Check for version conflicts in pubspec.yaml
flutter pub deps

# Force dependency resolution
flutter pub get --verbose

# Check pubspec.lock for conflicts
cat pubspec.lock | grep -A 5 -B 5 "conflicting_package"
```

#### Build Runner Issues
**Symptoms**: Code generation fails, missing generated files
**Causes**: Outdated generated files, build runner conflicts
**Solutions**:
```bash
# Clean and regenerate all files
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter packages pub run build_runner watch

# Force rebuild with conflicts resolution
flutter packages pub run build_runner build --delete-conflicting-outputs --verbose
```

### Signing Issues

#### Keystore Not Found
**Symptoms**: "Keystore file not found" error
**Causes**: Missing keystore file, incorrect path
**Solutions**:
```bash
# Verify keystore exists
ls -la obhaiCustomer.jks

# Check local.properties
cat local.properties

# Regenerate keystore if lost (NOT recommended for production)
keytool -genkey -v -keystore obhaiCustomer.jks -keyalg RSA -keysize 2048 -validity 10000 -alias obhaiCustomer
```

#### Wrong Password
**Symptoms**: "Keystore was tampered with, or password was incorrect"
**Causes**: Incorrect keystore or key password
**Solutions**:
```bash
# Verify keystore integrity
keytool -list -v -keystore obhaiCustomer.jks

# Check passwords in local.properties
# Ensure storePass and keyPass are correct
```

## Runtime Issues

### App Crashes

#### Startup Crashes
**Symptoms**: App crashes immediately on launch
**Common Causes**:
- Missing permissions in manifest
- Dagger/Hilt configuration issues
- ProGuard/R8 obfuscation problems
- Missing native libraries

**Debugging Steps**:
```bash
# Check crash logs
adb logcat | grep -E "(AndroidRuntime|FATAL)"

# Disable ProGuard temporarily
android {
    buildTypes {
        debug {
            minifyEnabled false
        }
    }
}

# Check Hilt setup
@HiltAndroidApp
class ObhaiApplication : Application()

# Verify manifest permissions
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

#### Memory Leaks
**Symptoms**: App becomes slow, eventually crashes with OOM
**Common Causes**:
- Activity/Fragment context leaks
- Static references to views
- Unclosed resources (streams, cursors)
- Listener not unregistered

**Solutions**:
```kotlin
// Use WeakReference for callbacks
class LocationTracker(private val callback: WeakReference<LocationCallback>) {
    fun onLocationUpdate(location: Location) {
        callback.get()?.onLocationReceived(location)
    }
}

// Proper lifecycle management
override fun onDestroy() {
    super.onDestroy()
    locationManager?.removeUpdates(locationListener)
    disposables.clear()
}

// Use LeakCanary for detection
debugImplementation 'com.squareup.leakcanary:leakcanary-android:2.12'
```

### Network Issues

#### API Connection Failures
**Symptoms**: Network requests fail, timeout errors
**Common Causes**:
- Network connectivity issues
- Certificate problems
- Incorrect base URLs
- API key issues

**Debugging Steps**:
```kotlin
// Add network logging
val logging = HttpLoggingInterceptor()
logging.setLevel(HttpLoggingInterceptor.Level.BODY)

val client = OkHttpClient.Builder()
    .addInterceptor(logging)
    .connectTimeout(30, TimeUnit.SECONDS)
    .readTimeout(30, TimeUnit.SECONDS)
    .build()

// Check network state
private fun isNetworkAvailable(): Boolean {
    val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    val network = connectivityManager.activeNetwork
    val networkCapabilities = connectivityManager.getNetworkCapabilities(network)
    return networkCapabilities?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
}

// Handle SSL issues (development only)
val trustAllCerts = arrayOf<TrustManager>(object : X509TrustManager {
    override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {}
    override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {}
    override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
})
```

#### Certificate Pinning Issues
**Symptoms**: SSL handshake failures in production
**Causes**: Certificate changes, incorrect pin configuration
**Solutions**:
```kotlin
// Update certificate pins
val certificatePinner = CertificatePinner.Builder()
    .add("api.obhai.com", "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")
    .add("api.obhai.com", "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=") // Backup pin
    .build()

// Implement pin failure recovery
val client = OkHttpClient.Builder()
    .certificatePinner(certificatePinner)
    .addInterceptor { chain ->
        try {
            chain.proceed(chain.request())
        } catch (e: SSLPeerUnverifiedException) {
            // Log and potentially retry without pinning
            Timber.e(e, "Certificate pinning failed")
            throw e
        }
    }
    .build()
```

### Location Services Issues

#### Location Not Available
**Symptoms**: GPS location not updating, location services unavailable
**Common Causes**:
- Missing permissions
- Location services disabled
- GPS hardware issues
- Indoor location accuracy

**Solutions**:
```kotlin
// Check and request permissions
private fun checkLocationPermissions(): Boolean {
    return ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
}

// Check if location services are enabled
private fun isLocationEnabled(): Boolean {
    val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
    return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
           locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
}

// Use FusedLocationProviderClient
private fun requestLocationUpdates() {
    val locationRequest = LocationRequest.create().apply {
        interval = 10000
        fastestInterval = 5000
        priority = LocationRequest.PRIORITY_HIGH_ACCURACY
    }
    
    fusedLocationClient.requestLocationUpdates(
        locationRequest,
        locationCallback,
        Looper.getMainLooper()
    )
}
```

### Firebase Issues

#### FCM Token Issues
**Symptoms**: Push notifications not received
**Causes**: Token not generated, token not sent to server
**Solutions**:
```kotlin
// Get FCM token
FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
    if (!task.isSuccessful) {
        Timber.w(task.exception, "Fetching FCM registration token failed")
        return@addOnCompleteListener
    }
    
    val token = task.result
    Timber.d("FCM Registration Token: $token")
    sendTokenToServer(token)
}

// Handle token refresh
class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Timber.d("Refreshed token: $token")
        sendTokenToServer(token)
    }
}
```

#### Crashlytics Not Working
**Symptoms**: Crashes not appearing in Firebase console
**Causes**: Crashlytics not initialized, debug builds
**Solutions**:
```kotlin
// Initialize Crashlytics
class ObhaiApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Enable Crashlytics for release builds only
        if (!BuildConfig.DEBUG) {
            FirebaseCrashlytics.getInstance().setCrashlyticsCollectionEnabled(true)
        }
    }
}

// Test crash reporting
FirebaseCrashlytics.getInstance().log("Test crash")
throw RuntimeException("Test crash for Crashlytics")
```

## Performance Issues

### Slow App Startup

#### Cold Start Optimization
**Symptoms**: App takes long time to start
**Causes**: Heavy initialization, blocking main thread
**Solutions**:
```kotlin
// Use Application.onCreate() wisely
class ObhaiApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize critical components only
        initializeCriticalComponents()
        
        // Defer non-critical initialization
        GlobalScope.launch {
            initializeNonCriticalComponents()
        }
    }
}

// Lazy initialization
val expensiveObject by lazy {
    ExpensiveObject()
}

// Use content providers for library initialization
class InitializationProvider : ContentProvider() {
    override fun onCreate(): Boolean {
        // Initialize libraries here
        return true
    }
}
```

### Memory Issues

#### High Memory Usage
**Symptoms**: App uses excessive memory, gets killed by system
**Causes**: Large bitmaps, memory leaks, inefficient data structures
**Solutions**:
```kotlin
// Optimize bitmap loading
val options = BitmapFactory.Options().apply {
    inJustDecodeBounds = true
    inSampleSize = calculateInSampleSize(this, reqWidth, reqHeight)
    inJustDecodeBounds = false
}

// Use Picasso for image loading
Picasso.get()
    .load(imageUrl)
    .resize(width, height)
    .centerCrop()
    .into(imageView)

// Monitor memory usage
val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
val memoryInfo = ActivityManager.MemoryInfo()
activityManager.getMemoryInfo(memoryInfo)
Timber.d("Available memory: ${memoryInfo.availMem / 1024 / 1024} MB")
```

### UI Performance Issues

#### Janky Animations
**Symptoms**: Stuttering animations, dropped frames
**Causes**: Main thread blocking, complex layouts
**Solutions**:
```kotlin
// Use background threads for heavy operations
viewModelScope.launch(Dispatchers.IO) {
    val data = heavyOperation()
    withContext(Dispatchers.Main) {
        updateUI(data)
    }
}

// Optimize RecyclerView
recyclerView.apply {
    setHasFixedSize(true)
    setItemViewCacheSize(20)
    setDrawingCacheEnabled(true)
    setDrawingCacheQuality(View.DRAWING_CACHE_QUALITY_HIGH)
}

// Use ViewStub for conditional layouts
<ViewStub
    android:id="@+id/stub_optional_content"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout="@layout/optional_content" />
```

## Database Issues

### Room Database Problems

#### Migration Failures
**Symptoms**: App crashes after database schema changes
**Causes**: Missing migrations, incorrect migration logic
**Solutions**:
```kotlin
// Define migrations
val MIGRATION_1_2 = object : Migration(1, 2) {
    override fun migrate(database: SupportSQLiteDatabase) {
        database.execSQL("ALTER TABLE User ADD COLUMN email TEXT")
    }
}

// Add migrations to database builder
Room.databaseBuilder(context, AppDatabase::class.java, "obhai-database")
    .addMigrations(MIGRATION_1_2)
    .build()

// Fallback strategy (development only)
Room.databaseBuilder(context, AppDatabase::class.java, "obhai-database")
    .fallbackToDestructiveMigration()
    .build()
```

#### Query Performance Issues
**Symptoms**: Slow database operations, ANR errors
**Causes**: Missing indexes, inefficient queries
**Solutions**:
```kotlin
// Add indexes
@Entity(
    tableName = "rides",
    indices = [
        Index(value = ["user_id"]),
        Index(value = ["status", "created_at"])
    ]
)
data class RideEntity(...)

// Use LIMIT for large datasets
@Query("SELECT * FROM rides WHERE user_id = :userId ORDER BY created_at DESC LIMIT :limit")
suspend fun getRecentRides(userId: String, limit: Int): List<RideEntity>

// Use background threads
@Dao
interface RideDao {
    @Query("SELECT * FROM rides")
    suspend fun getAllRides(): List<RideEntity> // Automatically runs on background thread
}
```

## Testing Issues

### Test Failures

#### Flaky Tests
**Symptoms**: Tests pass sometimes, fail other times
**Causes**: Timing issues, shared state, external dependencies
**Solutions**:
```kotlin
// Use proper test scheduling
@Test
fun testAsyncOperation() = runTest {
    // Use runTest for coroutine testing
    val result = repository.getData()
    assertEquals(expected, result)
}

// Mock external dependencies
@MockK
private lateinit var apiService: ApiService

@Test
fun testWithMocks() {
    every { apiService.getData() } returns mockData
    
    val result = repository.getData()
    
    verify { apiService.getData() }
    assertEquals(mockData, result)
}

// Use TestRule for consistent setup
@get:Rule
val instantTaskExecutorRule = InstantTaskExecutorRule()
```

#### UI Test Failures
**Symptoms**: Espresso tests fail intermittently
**Causes**: Timing issues, animations, network calls
**Solutions**:
```kotlin
// Disable animations for testing
@BeforeClass
fun disableAnimations() {
    InstrumentationRegistry.getInstrumentation().uiAutomation.executeShellCommand(
        "settings put global window_animation_scale 0"
    )
    InstrumentationRegistry.getInstrumentation().uiAutomation.executeShellCommand(
        "settings put global transition_animation_scale 0"
    )
    InstrumentationRegistry.getInstrumentation().uiAutomation.executeShellCommand(
        "settings put global animator_duration_scale 0"
    )
}

// Use IdlingResource for async operations
@get:Rule
val activityRule = ActivityScenarioRule(MainActivity::class.java)

@Test
fun testAsyncUI() {
    IdlingRegistry.getInstance().register(myIdlingResource)
    
    onView(withId(R.id.button)).perform(click())
    onView(withId(R.id.result)).check(matches(withText("Expected")))
    
    IdlingRegistry.getInstance().unregister(myIdlingResource)
}
```

## Deployment Issues

### Play Store Rejections

#### Policy Violations
**Symptoms**: App rejected during review
**Common Issues**:
- Missing privacy policy
- Inappropriate permissions
- Misleading app description
- Security vulnerabilities

**Solutions**:
```xml
<!-- Remove unnecessary permissions -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<!-- Don't request WRITE_EXTERNAL_STORAGE unless absolutely necessary -->

<!-- Add privacy policy link -->
<application android:label="@string/app_name">
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
</application>
```

#### APK/AAB Issues
**Symptoms**: Upload fails, size warnings
**Causes**: Large APK size, missing native libraries
**Solutions**:
```kotlin
// Enable APK splitting
android {
    splits {
        abi {
            enable true
            reset()
            include "x86", "x86_64", "arm64-v8a", "armeabi-v7a"
            universalApk false
        }
        density {
            enable true
            reset()
            include "ldpi", "mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"
        }
    }
}

// Enable bundle optimization
android {
    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }
}
```

## Monitoring and Debugging Tools

### Logging
```kotlin
// Use Timber for structured logging
if (BuildConfig.DEBUG) {
    Timber.plant(Timber.DebugTree())
} else {
    Timber.plant(CrashReportingTree())
}

// Log levels
Timber.v("Verbose message")
Timber.d("Debug message")
Timber.i("Info message")
Timber.w("Warning message")
Timber.e("Error message")
```

### Profiling
```bash
# Memory profiling
adb shell am start -n com.obhai/.MainActivity --enable-debugger
# Then use Android Studio Memory Profiler

# CPU profiling
adb shell am profile start com.obhai /data/local/tmp/profile.trace
# Perform actions
adb shell am profile stop com.obhai
adb pull /data/local/tmp/profile.trace
```

### Network Debugging
```kotlin
// Use Chuck for network debugging (debug builds only)
debugImplementation 'com.github.chuckerteam.chucker:library:3.5.2'
releaseImplementation 'com.github.chuckerteam.chucker:library-no-op:3.5.2'

val client = OkHttpClient.Builder()
    .addInterceptor(ChuckerInterceptor.Builder(context).build())
    .build()
```

## Emergency Procedures

### Production Hotfixes
Follow the complete hotfix workflow in [Git Branching](../workflow/git-branching.md#hotfix-workflow) for critical production issues.
6. **Deploy**: Emergency deployment to production
7. **Monitor**: Close monitoring after deployment

### Rollback Procedures
1. **Play Store**: Halt staged rollout, promote previous version
2. **Firebase**: Revert remote config changes
3. **API**: Coordinate with backend team for API rollbacks
4. **Communication**: Notify stakeholders and users if necessary

### Incident Response
1. **Assess Impact**: Determine severity and user impact
2. **Communicate**: Notify team and stakeholders
3. **Investigate**: Identify root cause
4. **Fix**: Implement and test solution
5. **Deploy**: Release fix to production
6. **Post-Mortem**: Document incident and prevention measures
