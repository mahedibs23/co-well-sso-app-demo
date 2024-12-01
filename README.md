# Flutter Boilerplate

A starter template for Flutter projects designed to streamline the development process and ensure a
scalable, maintainable codebase.

## Features

- **Dynamic Layouts**: Adjusts based on device type (Mobile/Tablet) and orientation (
  Portrait/Landscape).
- **MVVM Architecture**: Preconfigured with a base setup for scalable code structure.
- **State Management**: Utilizes `ValueNotifier` for efficient and simple state management.
- **Base classes**: Utilized Base classes for reduce developer effort for common functionalities.
- **Network Calls**: Integrated with the `http` package for making network requests.
- **Navigation**: Employs Navigator 2.0 with support for passing arguments between screens.
- **Localizations**: Built-in support for multiple languages. In app language change support.
- **Material Theme**: Customizable dark and light themes. In-app theme change support.
- **Environment Configuration**: Managed using `DotEnv` for different environments.
- **Build Flavors**: Supports multiple build flavors including Dev, Test, Staging, and Prod.
- **Dependency Injection**: Created our own Dependency container so that it doesn't depends on third
  party library.
- **Modular approach**: Data, Domain layer is separated by making them individual flutter package
- **Code Generation**: When we need to add a new feature we can run script to generate all the
  necessary code to start with following our architecture.

## TODO

- **Local Database setup**: Local SQL database setup & integration
- **Dummy/Mock Data**: Mocking API response
- **Unit Testing**: Set up a comprehensive unit testing framework.
- **CI/CD**: Configure Continuous Integration and Continuous Deployment pipelines.
- **Unit Testing**: Set up a comprehensive unit testing framework.
- **Code Quality**: Integrate code coverage tools like SonarQube.
- **CI/CD**: Configure Continuous Integration and Continuous Deployment pipelines.
- **Method Channel**: Implement platform-specific code using method channels.
- **Analytics**: Integrate analytics tools like Firebase Analytics.
- **Crash Reporting**: Integrate crash reporting tools like Firebase Crashlytics/Sentry.
- **Push Notifications**: Implement push notifications using Firebase Cloud Messaging.
- **Deep Linking**: Implement deep linking for navigation within the app.
- **App Lifecycle**: Handle app lifecycle events like onResume, onPause, etc.
- **Accessibility**: Implement accessibility features for users with disabilities.
- **Animations**: Add animations to enhance the user experience.
- **Splash screen + Native Splash**: Implement a splash screen with native splash screen support.
- **Custom Colors**: Add custom colors to the theme for consistent branding.

## Target Devices

### Android

- **Minimum SDK**: 26 (Android 8.0) (Oreo)
- **Target SDK**: 34 (Android 14) (Upside Down Cake)

### iOS

- **Minimum iOS Version**: 12.0

## Getting Started

### Prerequisites

- Android Studio: [Install Android Studio](https://developer.android.com/studio)
    - Version: 2024.1.1
- FVM: [Install FVM](https://fvm.app/documentation/getting-started/installation)
    - Version: 2.4.1
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
    - Version: 3.24.3
- Dart SDK: Included with Flutter
    - Version: 3.5.3
- Git: [Install Git](https://git-scm.com/downloads)
    - Version: 2.33.0

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd <repo-name>
   ```
1. **Set up Flutter version using FVM**:
   ```bash
   fvm install 3.24.3
   fvm use 3.24.3
   ```
1. **Setup Flutter SDK in Android Studio**:
    - Open Android Studio
    - Go to `File > Settings > Languages & Frameworks > Flutter`
    - Set the FVM Flutter SDK path to the location of your Flutter SDK
    - Click `Apply` and then `OK`
1. **Install dependencies**:
   ```bash
   fvm flutter pub get
   ```
1. **Set up environment variables**:
   See [Environment setup guide](env/README.md) for more information.

### Running the App

To run the app with a specific build flavor:

- In the Android Studio, you can choose runConfigurations from the top right corner and select the
  desired flavor to run the app.
    - These run configurations are already set up for each flavor at `.idea/runConfigurations` which
      is tracked by git.
- Or else if you want to run the app from the terminal, you can use the following commands:

```bash
flutter run --flavor flavor_dev -t lib/main/main_flavor_dev.dart
flutter run --flavor flavor_test -t lib/main/main_flavor_test.dart
flutter run --flavor flavor_staging -t lib/main/main_flavor_staging.dart
flutter run --flavor flavor_prod -t lib/main/main_flavor_prod.dart
```

### Generate boilerplate code for new feature

Either you can use the `create_feature` run configuration to run the script then input the feature
name in the run console
orElse,

```bash
cd lib/presentation/feature
dart create_feature.dart feature_name
```

## Change App Name and Application ID

## Flutter

In AndroidStudio Go to Edit > Find > Replace in Files (Ctrl + Shift + R) and replace the following

- `Hello Flutter` with `Your App Name`
- `hello_flutter` with `your_app_name`
- `hello-flutter` with `your-app-name`
- `com.mahfuznow` with `com.yourdomain`

### Android

- Open `app/build.gradle` file and change the applicationId to your desired app name.

```bash
android {
    namespace "com.mahfuznow.hello_flutter"
    
    defaultConfig {
        applicationId "com.mahfuznow.hello_flutter"
    }
    
    productFlavors {
    flavor_dev {
        dimension "env"
        applicationIdSuffix ".dev"
        resValue "string", "app_name", "Hello Flutter Dev"
    }
    flavor_test {
        dimension "env"
        applicationIdSuffix ".test"
        resValue "string", "app_name", "Hello Flutter Test"
    }
    flavor_staging {
        dimension "env"
        applicationIdSuffix ".staging"
        resValue "string", "app_name", "Hello Flutter Staging"
    }
    flavor_prod {
        dimension "env"
        resValue "string", "app_name", "Hello Flutter"
    }
}
}
```

- Rename the `android/app/src/main/kotlin/com/mahfuznow/hello_flutter` folder to your desired
  package name.
- Update the package declaration in the `MainActivity.kt` file to match the new folder name.
    - For example, if the folder is renamed to `com/mahfuznow/hello_flutter`, the package
      declaration
      should be `package com.mahfuznow.hello_flutter`.

### iOS

- open `ios/Flutter/flavor_devDebug.xcconfig` and change the `BUNDLE_NAME` and `BUNDLE_DISPLAY_NAME`
  to your desired app name.
- open `ios/Flutter/flavor_testDebug.xcconfig` and change the `BUNDLE_NAME`
  and `BUNDLE_DISPLAY_NAME` to your desired app name.
- open `ios/Flutter/flavor_stagingDebug.xcconfig` and change the `BUNDLE_NAME`
  and `BUNDLE_DISPLAY_NAME` to your desired app name.
- open `ios/Flutter/flavor_prodDebug.xcconfig` and change the `BUNDLE_NAME`
  and `BUNDLE_DISPLAY_NAME` to your desired app name.
- open `ios/Flutter/flavor_devRelease.xcconfig` and change the `BUNDLE_NAME`
  and `BUNDLE_DISPLAY_NAME` to your desired app name.
- open `ios/Flutter/flavor_testRelease.xcconfig` and change the `BUNDLE_NAME`
  and `BUNDLE_DISPLAY_NAME` to your desired app name.
- open `ios/Flutter/flavor_stagingRelease.xcconfig` and change the `BUNDLE_NAME`
  and `BUNDLE_DISPLAY_NAME` to your desired app name.
- open `ios/Flutter/flavor_prodRelease.xcconfig` and change the `BUNDLE_NAME`
  and `BUNDLE_DISPLAY_NAME` to your desired app name.

To change the bundle identifier, open the `ios/Runner.xcodeproj` file in Xcode and update manually
using Xcode UI for each build type.

## Change App Icon

### Generate different app icons for different flavors

- Using [Icon Kitchen](https://icon.kitchen/) we can generate different app icons (Badge) for
  different flavors.
- This website will provide the necessary files for both Android and iOS.
- For Android, copy the contents of the `android` folder of the downloaded folder to the respective
  flavor folders in
  `android/app/src`. Example: for `dev` paste into `android/app/src/flavor_dev/`.
- For iOS, copy the `ios/AppIcon~ios-marketing.png` file from the downloaded folder to the
  corresponding flavor folder in `ios/Runner/Assets.xcassets`. Example: for `dev` paste
  into `ios/Runner/Assets.xcassets/flavor_devAppIcon.appiconset`.

### Flutter

Replace `assets/images/app_logo.png` with your desired icon for the app.

### Android

- Replace the `android/app/src/flavor_dev/res` folder with your desired icon for Dev app.
- Replace the `android/app/src/flavor_test/res` folder with your desired icon for Test app.
- Replace the `android/app/src/flavor_staging/res` folder with your desired icon for Staging app.
- Replace the `android/app/src/main/res` folder with your desired icon for Prod app.

### iOS

- Replace the `ios/Runner/Assets.xcassets/flavor_devAppIcon.appiconset` folder with your desired
  icon for Dev app.
- Replace the `ios/Runner/Assets.xcassets/flavor_testAppIcon.appiconset` folder with your desired
  icon for Test app.
- Replace the `ios/Runner/Assets.xcassets/flavor_stagingAppIcon.appiconset` folder with your desired
  icon for Staging app.
- Replace the `ios/Runner/Assets.xcassets/AppIcon.appiconset` folder with your desired icon for Prod
  app.

### Flutter App Best Practices

See [Flutter App Best Practices](doc/best_practices.md) for more information on general best
practices for any Flutter app.
app.

### Flutter App Security Measures

See [Flutter App Security Measures](doc/security.md) for more information on securing your Flutter
app.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss your ideas.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or suggestions, feel free to reach out
to [mahfuzur.rahman@brainstation-23.com](mailto:mahfuzur.rahman@brainstation-23.com).

---

This boilerplate is intended to provide a strong foundation for Flutter applications. By adhering to
best practices and a structured architecture, it aims to help developers create robust and scalable
applications efficiently. Happy coding!
