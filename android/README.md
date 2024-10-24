# Android

---

# Keystore Management with `generateKeystores.gradle`

This document provides instructions on how to run the `generateKeystores.gradle` script to generate
keystores for your Android project. The script automates the creation of keystores, generating
passwords, and updating the necessary configuration files.

## Prerequisites

- Android Studio installed
- Gradle configured in your project
- Java Development Kit (JDK) installed on your system

## Running the Keystore Generation Script

1. **Open Your Project**:

- Open your existing Android project where the `generateKeystores.gradle` script is already set up.

2. Open the `generateKeystores.gradle` file in your project and Change the values of these
   attributes to suit your organization.
   ```groovy
   // Parameterized DName attributes
   def commonName = "John Doe"
   def organizationalUnit = "Dev"
   def organizationName = "MyOrg"
   def localityName = "CityX"
   def stateName = "StateX"
   def countryCode = "US"
   ```

3. **Run the Keystore Generation Task**:

- Open a terminal window in your project directory.
- Execute the following command to generate the keystores:

   ```bash
   ./gradlew generateKeystores
   ```

4. **Output Structure**:

- After running the command, the following will occur:
    - A `keystore` directory will be created in your project. This directory will contain:
        - **Keystore Files**: The generated keystore files for each build flavor.
        - **`credentials.txt`**: A text file containing the generated credentials (keystore names,
          aliases, and passwords).

5. **Updated Configuration**:

- The script will automatically update your `local.properties` file with the necessary properties
  required for the `signingConfigs` block in your app-level `build.gradle` file. You do not need to
  manually enter any passwords; they will be generated automatically.

## Important Notes

- **Security**: The generated passwords will be stored in the `local.properties` file. Ensure that
  this file is kept secure and not shared publicly.
- **Re-running the Script**: If you need to regenerate the keystores, simply delete the existing
  keystore files in the `keystore` directory and also remove existing password
  from `local.properties` file and then rerun the `generateKeystores` task.