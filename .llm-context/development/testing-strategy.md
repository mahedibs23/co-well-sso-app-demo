# Flutter Boilerplate - Testing Strategy

## Testing Philosophy
Our testing strategy follows the Flutter testing pyramid approach with emphasis on unit tests, supported by widget tests, and topped with essential integration tests. We aim for comprehensive coverage while maintaining fast feedback loops and reliable test execution.

## Testing Pyramid

### Unit Tests (70% of total tests)
- **Scope**: ViewModels, repositories, utilities, and business logic
- **Tools**: Flutter Test, Mockito, Test package
- **Coverage Target**: 80%+ code coverage
- **Execution**: Fast (< 5 seconds total)

### Widget Tests (20% of total tests)
- **Scope**: Individual widgets, UI components, and user interactions
- **Tools**: Flutter Test, Widget Tester, Golden Tests
- **Coverage Target**: Critical UI components and user flows
- **Execution**: Medium speed (< 30 seconds total)

### Integration Tests (10% of total tests)
- **Scope**: Complete user journeys and app-wide functionality
- **Tools**: Flutter Driver, Integration Test package
- **Coverage Target**: Happy path and critical error scenarios
- **Execution**: Slower (< 5 minutes total)

## Unit Testing Standards

### Test Structure
```dart
// test/presentation/feature/home/home_view_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:hello_flutter/presentation/feature/home/home_view_model.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_argument.dart';

@GenerateMocks([AuthRepository])
import 'home_view_model_test.mocks.dart';

void main() {
  group('HomeViewModel', () {
    late MockAuthRepository mockAuthRepository;
    late HomeViewModel viewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      viewModel = HomeViewModel(authRepository: mockAuthRepository);
    });

    tearDown(() {
      viewModel.onDispose();
    });

    group('onViewReady', () {
      test('when onViewReady is called with argument, then userId is set', () {
        // Given
        const argument = HomeArgument(userId: 'test_user_123');
        
        // When
        viewModel.onViewReady(argument: argument);
        
        // Then
        expect(viewModel.userId.value, equals('test_user_123'));
      });

      test('when onViewReady is called, then user session is loaded', () async {
        // Given
        const mockUserSession = 'mock_session_data';
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => mockUserSession);
        
        // When
        viewModel.onViewReady();
        
        // Then
        verify(mockAuthRepository.getCurrentUser()).called(1);
      });
    });

    group('navigation', () {
      test('when onPageChanged is called, then currentPageIndex is updated', () {
        // Given
        const newIndex = 2;
        
        // When
        viewModel.onPageChanged(newIndex);
        
        // Then
        expect(viewModel.currentPageIndex.value, equals(newIndex));
      });

      test('when onNavigationItemClicked is called, then currentPageIndex is updated', () {
        // Given
        const selectedIndex = 1;
        
        // When
        viewModel.onNavigationItemClicked(selectedIndex);
        
        // Then
        expect(viewModel.currentPageIndex.value, equals(selectedIndex));
      });
    });
  });
}
```

### Mock Usage Guidelines
```dart
// Good: Use Mockito for Flutter testing
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AppRepository, AuthRepository])
import 'test_file.mocks.dart';

void main() {
  late MockAppRepository mockAppRepository;
  
  setUp(() {
    mockAppRepository = MockAppRepository();
  });

  test('repository returns expected data', () async {
    // Given
    const expectedLanguage = AppLanguage.english;
    when(mockAppRepository.getApplicationLocale())
        .thenAnswer((_) async => expectedLanguage);
    
    // When
    final result = await mockAppRepository.getApplicationLocale();
    
    // Then
    verify(mockAppRepository.getApplicationLocale()).called(1);
    expect(result, equals(expectedLanguage));
  });

  test('repository handles errors properly', () async {
    // Given
    when(mockAppRepository.getApplicationLocale())
        .thenThrow(Exception('Network error'));
    
    // When & Then
    expect(
      () => mockAppRepository.getApplicationLocale(),
      throwsA(isA<Exception>()),
    );
  });
}
```

### Test Data Builders
```dart
// Good: Test data builders for complex objects
class AppInfoTestBuilder {
  AppPlatform _platform = AppPlatform.android;
  String _name = 'Test App';
  String _packageName = 'com.test.app';
  String _version = '1.0.0';
  String _buildNumber = '1';
  
  AppInfoTestBuilder withPlatform(AppPlatform platform) {
    _platform = platform;
    return this;
  }
  
  AppInfoTestBuilder withName(String name) {
    _name = name;
    return this;
  }
  
  AppInfoTestBuilder withVersion(String version) {
    _version = version;
    return this;
  }
  
  AppInfo build() {
    return AppInfo(
      platform: _platform,
      name: _name,
      packageName: _packageName,
      version: _version,
      buildNumber: _buildNumber,
    );
  }
}

// Usage in tests
test('app info with custom data', () {
  final appInfo = AppInfoTestBuilder()
      .withName('Custom App')
      .withVersion('2.1.0')
      .withPlatform(AppPlatform.ios)
      .build();
  
  expect(appInfo.name, equals('Custom App'));
  expect(appInfo.version, equals('2.1.0'));
  expect(appInfo.platform, equals(AppPlatform.ios));
});
```

## Widget Testing

### Widget Test Structure
```dart
// test/presentation/feature/home/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:hello_flutter/presentation/feature/home/home_view_model.dart';
import 'package:hello_flutter/presentation/feature/home/screen/home_screen.dart';

import '../../../mocks.mocks.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late MockHomeViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockHomeViewModel();
      when(mockViewModel.currentPageIndex).thenReturn(ValueNotifier(0));
      when(mockViewModel.userId).thenReturn(ValueNotifier('test_user'));
    });

    testWidgets('displays bottom navigation with correct items', (tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(viewModel: mockViewModel),
        ),
      );

      // Then
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('tapping navigation item calls viewModel method', (tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(viewModel: mockViewModel),
        ),
      );

      // When
      await tester.tap(find.text('Search'));
      await tester.pump();

      // Then
      verify(mockViewModel.onNavigationItemClicked(1)).called(1);
    });
  });
}
        mockWebServer.start()
    }
    
    @After
    fun tearDown() {
        mockWebServer.shutdown()
        database.clearAllTables()
    }
    
    @Test
    fun `when API returns rides, then rides are cached locally`() = runTest {
        // Given
        val mockResponse = MockResponse()
            .setResponseCode(200)
            .setBody(ridesJsonResponse)
        mockWebServer.enqueue(mockResponse)
        
        // When
        val rides = repository.getRides()
        
        // Then
        assertEquals(2, rides.size)
        
        // Verify local cache
        val cachedRides = database.rideDao().getAllRides()
        assertEquals(2, cachedRides.size)
    }
}
```

### Database Testing
```kotlin
@RunWith(AndroidJUnit4::class)
class RideDaoTest {
    
    private lateinit var database: AppDatabase
    private lateinit var rideDao: RideDao
    
    @Before
    fun setup() {
        database = Room.inMemoryDatabaseBuilder(
            ApplicationProvider.getApplicationContext(),
            AppDatabase::class.java
        ).allowMainThreadQueries().build()
        
        rideDao = database.rideDao()
    }
    
    @After
    fun tearDown() {
        database.close()
    }
    
    @Test
    fun `when ride is inserted, then it can be retrieved`() = runTest {
        // Given
        val ride = RideTestDataBuilder().build()
        
        // When
        rideDao.insertRide(ride.toEntity())
        val retrievedRide = rideDao.getRideById(ride.id)
        
        // Then
        assertNotNull(retrievedRide)
        assertEquals(ride.id, retrievedRide?.id)
    }
}
```

## UI Testing

### Fragment Testing
```kotlin
@RunWith(AndroidJUnit4::class)
class RideBookingFragmentTest {
    
    @get:Rule
    val hiltRule = HiltAndroidRule(this)
    
    @MockK
    private lateinit var viewModel: RideBookingViewModel
    
    @Before
    fun setup() {
        hiltRule.inject()
        MockKAnnotations.init(this)
    }
    
    @Test
    fun `when fragment is displayed, then pickup and destination fields are shown`() {
        // Given
        every { viewModel.uiState } returns MutableLiveData(UiState.Loading)
        
        // When
        launchFragmentInHiltContainer<RideBookingFragment> {
            // Fragment is launched
        }
        
        // Then
        onView(withId(R.id.edit_pickup_location)).check(matches(isDisplayed()))
        onView(withId(R.id.edit_destination_location)).check(matches(isDisplayed()))
        onView(withId(R.id.button_book_ride)).check(matches(isDisplayed()))
    }
    
    @Test
    fun `when book ride button is clicked, then booking dialog is shown`() {
        // Given
        every { viewModel.uiState } returns MutableLiveData(UiState.Loading)
        every { viewModel.bookRide(any(), any()) } just Runs
        
        launchFragmentInHiltContainer<RideBookingFragment>()
        
        // When
        onView(withId(R.id.button_book_ride)).perform(click())
        
        // Then
        onView(withText(R.string.dialog_confirm_booking)).check(matches(isDisplayed()))
    }
}
```

### End-to-End Testing
```kotlin
@RunWith(AndroidJUnit4::class)
@LargeTest
class RideBookingE2ETest {
    
    @get:Rule
    val activityRule = ActivityScenarioRule(MainActivity::class.java)
    
    @Test
    fun `complete ride booking flow`() {
        // Navigate to ride booking
        onView(withId(R.id.tab_book_ride)).perform(click())
        
        // Enter pickup location
        onView(withId(R.id.edit_pickup_location))
            .perform(typeText("123 Main St"))
        
        // Enter destination
        onView(withId(R.id.edit_destination_location))
            .perform(typeText("456 Broadway"))
        
        // Select ride type
        onView(withId(R.id.spinner_ride_type)).perform(click())
        onView(withText("Economy")).perform(click())
        
        // Book ride
        onView(withId(R.id.button_book_ride)).perform(click())
        
        // Confirm booking
        onView(withText(R.string.button_confirm)).perform(click())
        
        // Verify ride status screen
        onView(withId(R.id.text_ride_status))
            .check(matches(withText(R.string.status_searching_driver)))
    }
}
```

## Test Configuration

### Test Dependencies
```kotlin
// build.gradle (app module)
dependencies {
    // Unit Testing
    testImplementation 'junit:junit:4.13.2'
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.2'
    testImplementation 'io.mockk:mockk:1.13.4'
    testImplementation 'org.jetbrains.kotlinx:kotlinx-coroutines-test:1.8.1'
    testImplementation 'androidx.arch.core:core-testing:2.2.0'
    testImplementation 'app.cash.turbine:turbine:0.12.1'
    
    // Integration Testing
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test:runner:1.5.2'
    androidTestImplementation 'androidx.test:rules:1.5.0'
    androidTestImplementation 'com.google.dagger:hilt-android-testing:2.48'
    androidTestImplementation 'androidx.room:room-testing:2.6.1'
    androidTestImplementation 'com.squareup.okhttp3:mockwebserver:4.12.0'
    
    // UI Testing
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
    androidTestImplementation 'androidx.test.espresso:espresso-contrib:3.5.1'
    androidTestImplementation 'androidx.test.espresso:espresso-intents:3.5.1'
    androidTestImplementation 'androidx.test.uiautomator:uiautomator:2.2.0'
    androidTestImplementation 'androidx.fragment:fragment-testing:1.7.1'
}
```

### Test Configuration Files
```kotlin
// TestApplication.kt
@HiltAndroidApp
class TestApplication : Application()

// Custom Test Runner
class CustomTestRunner : AndroidJUnitRunner() {
    override fun newApplication(cl: ClassLoader?, name: String?, context: Context?): Application {
        return super.newApplication(cl, TestApplication::class.java.name, context)
    }
}
```

## Test Data Management

### Test Fixtures
```kotlin
object TestFixtures {
    
    fun createUser(
        id: String = "test_user_123",
        name: String = "Test User",
        email: String = "test@example.com"
    ) = User(id = id, name = name, email = email)
    
    fun createRide(
        id: String = "test_ride_123",
        status: RideStatus = RideStatus.BOOKED,
        fare: Double = 10.0
    ) = Ride(
        id = id,
        status = status,
        pickup = Location(40.7128, -74.0060),
        destination = Location(40.7589, -73.9851),
        fare = fare
    )
    
    fun createLocation(
        latitude: Double = 40.7128,
        longitude: Double = -74.0060,
        address: String = "Test Address"
    ) = Location(latitude = latitude, longitude = longitude, address = address)
}
```

### Mock Data Providers
```kotlin
class MockDataProvider {
    
    companion object {
        fun getRidesJsonResponse(): String {
            return """
                {
                    "rides": [
                        {
                            "id": "ride_1",
                            "status": "completed",
                            "fare": 12.50,
                            "pickup": {"lat": 40.7128, "lng": -74.0060},
                            "destination": {"lat": 40.7589, "lng": -73.9851}
                        },
                        {
                            "id": "ride_2",
                            "status": "completed",
                            "fare": 8.75,
                            "pickup": {"lat": 40.7505, "lng": -73.9934},
                            "destination": {"lat": 40.7282, "lng": -73.7949}
                        }
                    ]
                }
            """.trimIndent()
        }
    }
}
```

## Continuous Integration

### GitHub Actions Test Configuration
```yaml
name: Android Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    - name: Run unit tests
      run: ./gradlew testDebugUnitTest
    - name: Generate test report
      run: ./gradlew jacocoTestReport
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      
  instrumented-tests:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    - name: Run instrumented tests
      uses: reactivecircus/android-emulator-runner@v2
      with:
        api-level: 29
        script: ./gradlew connectedDebugAndroidTest
```

## Test Reporting

### Coverage Reports
- **Tool**: JaCoCo for code coverage
- **Target**: 80% overall coverage
- **Critical Paths**: 90% coverage for business logic
- **Reports**: HTML and XML formats for CI integration

### Test Results
- **Format**: JUnit XML for CI integration
- **Storage**: Test results archived for 30 days
- **Notifications**: Slack notifications for test failures
- **Trends**: Track test execution time and flakiness

## Performance Testing

### Benchmark Tests
```kotlin
@RunWith(AndroidJUnit4::class)
class RideRepositoryBenchmark {
    
    @get:Rule
    val benchmarkRule = BenchmarkRule()
    
    @Test
    fun benchmarkGetRides() {
        benchmarkRule.measureRepeated {
            repository.getRides()
        }
    }
}
```

### Memory Testing
```kotlin
@Test
fun `repository does not leak memory`() {
    val memoryBefore = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()
    
    repeat(1000) {
        repository.getRides()
    }
    
    System.gc()
    Thread.sleep(100)
    
    val memoryAfter = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()
    val memoryIncrease = memoryAfter - memoryBefore
    
    assertTrue("Memory leak detected: ${memoryIncrease}bytes", memoryIncrease < 10_000_000)
}
```

## Test Maintenance

### Flaky Test Management
- **Identification**: Track test failure rates
- **Quarantine**: Temporarily disable flaky tests
- **Investigation**: Root cause analysis for failures
- **Resolution**: Fix or rewrite problematic tests

### Test Refactoring
- **Regular Review**: Monthly test code review
- **Duplication Removal**: Eliminate duplicate test logic
- **Helper Methods**: Extract common test utilities
- **Data Builders**: Use builders for complex test data

### Test Documentation
- **Test Plans**: Document testing approach for features
- **Coverage Reports**: Regular coverage analysis
- **Known Issues**: Document known test limitations
- **Best Practices**: Team testing guidelines
