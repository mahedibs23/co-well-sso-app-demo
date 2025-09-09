# IDE Setup Guide

This guide will help you configure Android Studio for optimal Flutter development with the boilerplate project.

## 🎯 Prerequisites

- ✅ Android Studio 2024.1.1+ installed
- ✅ Flutter Boilerplate project cloned
- ✅ FVM and Flutter 3.24.3 configured

## 🔧 Android Studio Configuration

### 1. Install Required Plugins

**Flutter Plugin:**
1. Open Android Studio
2. Go to `File > Settings > Plugins` (or `Android Studio > Preferences > Plugins` on macOS)
3. Search for "Flutter"
4. Install the Flutter plugin (this also installs the Dart plugin)
5. Restart Android Studio

**Additional Recommended Plugins:**
- **GitToolBox** - Enhanced Git integration
- **Rainbow Brackets** - Better code readability
- **Key Promoter X** - Learn keyboard shortcuts
- **String Manipulation** - Text transformation tools

### 2. Configure Flutter SDK Path

**Set Project-Specific Flutter SDK:**
1. Open the Flutter Boilerplate project
2. Go to `File > Settings > Languages & Frameworks > Flutter`
3. Set Flutter SDK path to: `<project-root>/.fvm/flutter_sdk`
4. Verify Dart SDK is automatically detected
5. Click `Apply` and `OK`

**Verify Configuration:**
- Check status bar shows "Flutter 3.24.3"
- Ensure no SDK-related warnings appear

### 3. Configure Run Configurations

The project includes pre-configured run configurations in `.idea/runConfigurations/`:

**Available Configurations:**
- `before_pull_request.xml` - Pre-PR checks
- `create_feature.xml` - Feature generation script
- `dev_android_aab.xml` - Development AAB build
- `flavor_dev.xml` - Development flavor
- `flavor_test.xml` - Test flavor
- `flavor_staging.xml` - Staging flavor
- `flavor_prod.xml` - Production flavor

**Verify Run Configurations:**
1. Check the run configuration dropdown (top-right)
2. Ensure all configurations are loaded
3. If missing, restart Android Studio

### 4. Configure Code Style and Formatting

**Import Flutter Code Style:**
1. Go to `File > Settings > Editor > Code Style > Dart`
2. Click the gear icon ⚙️ next to "Scheme"
3. Select "Import Scheme > IntelliJ IDEA code style XML"
4. Use Flutter's default formatting rules

**Enable Format on Save:**
1. Go to `File > Settings > Tools > Actions on Save`
2. Enable "Reformat code"
3. Enable "Optimize imports"
4. Enable "Rearrange code"

**Configure Line Length:**
1. Go to `File > Settings > Editor > Code Style > Dart`
2. Set "Hard wrap at" to 80 characters
3. Enable "Wrap on typing"

### 5. Set Up Debugging Configuration

**Configure Debugger:**
1. Go to `File > Settings > Build, Execution, Deployment > Debugger`
2. Enable "Show values inline"
3. Set "Data view" to "Tree"

**Flutter Inspector:**
1. Ensure Flutter Inspector is enabled in the Flutter plugin settings
2. Configure to open automatically when debugging

### 6. Configure Version Control Integration

**Git Configuration:**
1. Go to `File > Settings > Version Control > Git`
2. Verify Git executable path is correct
3. Enable "Use credential helper"

**GitHub Integration (Optional):**
1. Go to `File > Settings > Version Control > GitHub`
2. Add your GitHub account
3. Configure for easier pull request management

## 🎨 UI and Theme Configuration

### 1. Choose IDE Theme

**Recommended Themes:**
- **Darcula** - Dark theme (default)
- **IntelliJ Light** - Light theme
- **High Contrast** - For accessibility

**Configure Theme:**
1. Go to `File > Settings > Appearance & Behavior > Appearance`
2. Select your preferred theme
3. Adjust font size if needed

### 2. Configure Editor

**Font Configuration:**
1. Go to `File > Settings > Editor > Font`
2. Recommended fonts:
   - **JetBrains Mono** (default)
   - **Fira Code** (with ligatures)
   - **Source Code Pro**
3. Set size to 14-16px for optimal readability

**Color Scheme:**
1. Go to `File > Settings > Editor > Color Scheme`
2. Choose scheme that matches your theme
3. Customize Dart/Flutter-specific colors if needed

## 🔍 Essential IDE Features Setup

### 1. Live Templates

**Flutter Live Templates:**
The Flutter plugin includes useful live templates:
- `stless` - StatelessWidget
- `stful` - StatefulWidget
- `scaf` - Scaffold
- `container` - Container widget

**Custom Templates:**
Create project-specific templates for common patterns:
1. Go to `File > Settings > Editor > Live Templates`
2. Create new template group "Flutter Boilerplate"
3. Add templates for common project patterns

### 2. File and Code Templates

**Configure File Templates:**
1. Go to `File > Settings > Editor > File and Code Templates`
2. Customize Dart class template with project header
3. Add copyright notice if required

### 3. Inspections and Code Analysis

**Enable Flutter-Specific Inspections:**
1. Go to `File > Settings > Editor > Inspections`
2. Enable all Flutter and Dart inspections
3. Configure severity levels:
   - Errors: Red
   - Warnings: Yellow
   - Weak Warnings: Gray

**Recommended Inspection Settings:**
- Enable "Unused import" detection
- Enable "Missing return type" warnings
- Enable "Prefer const constructors"
- Enable "Avoid print calls in production code"

## 🚀 Performance Optimization

### 1. Memory Settings

**Increase IDE Memory:**
1. Go to `Help > Change Memory Settings`
2. Set Xmx to at least 4GB (4096 MB)
3. Set Xms to 1GB (1024 MB)
4. Restart Android Studio

### 2. Indexing Optimization

**Configure Indexing:**
1. Go to `File > Settings > Advanced Settings`
2. Enable "Shared project indexes"
3. Exclude unnecessary directories from indexing:
   - `.fvm/`
   - `build/`
   - `.dart_tool/`

### 3. Build Optimization

**Gradle Settings:**
1. Go to `File > Settings > Build, Execution, Deployment > Compiler`
2. Enable "Build project automatically"
3. Increase "User-local build process heap size" to 2048 MB

## 📱 Device and Emulator Setup

### 1. Android Emulator Configuration

**Create Development Emulator:**
1. Open AVD Manager (`Tools > AVD Manager`)
2. Create new virtual device
3. Recommended configuration:
   - Device: Pixel 7 Pro
   - System Image: API 34 (Android 14)
   - RAM: 4GB
   - Internal Storage: 8GB

### 2. iOS Simulator Setup (macOS only)

**Configure iOS Simulator:**
1. Ensure Xcode is installed
2. Open Simulator app
3. Create simulators for testing:
   - iPhone 15 Pro (iOS 17)
   - iPad Pro 12.9" (iOS 17)

### 3. Physical Device Setup

**Android Device:**
1. Enable Developer Options
2. Enable USB Debugging
3. Install device drivers if needed

**iOS Device (macOS only):**
1. Connect device via USB
2. Trust computer when prompted
3. Ensure device is registered for development

## ✅ Verification Checklist

After configuration, verify everything works:

- [ ] Flutter SDK path correctly set to FVM version
- [ ] All run configurations appear in dropdown
- [ ] Code formatting works (Ctrl+Alt+L / Cmd+Opt+L)
- [ ] Flutter Inspector opens during debug
- [ ] Hot reload works (Ctrl+\ / Cmd+\)
- [ ] Dart analysis shows no errors
- [ ] Git integration works
- [ ] Device/emulator detection works

## 🚨 Troubleshooting

### Common Issues

**Issue: Flutter plugin not working**
```
Solution:
1. Uninstall Flutter plugin
2. Restart Android Studio
3. Reinstall Flutter plugin
4. Restart again
```

**Issue: Run configurations missing**
```
Solution:
1. Close Android Studio
2. Delete .idea/workspace.xml
3. Reopen project
4. Configurations should reload
```

**Issue: Dart analysis errors**
```
Solution:
1. Run: fvm flutter clean
2. Run: fvm flutter pub get
3. Restart Dart Analysis Server (Tools > Flutter > Restart Dart Analysis Server)
```

**Issue: Hot reload not working**
```
Solution:
1. Ensure you're running in debug mode
2. Check that you're not in a const constructor
3. Try hot restart instead (Ctrl+Shift+\ / Cmd+Shift+\)
```

## 🎯 Productivity Tips

### Keyboard Shortcuts

**Essential Flutter Shortcuts:**
- `Ctrl+Space` - Code completion
- `Ctrl+Shift+Space` - Smart completion
- `Alt+Enter` - Quick fixes
- `Ctrl+Alt+L` - Format code
- `Ctrl+\` - Hot reload
- `Ctrl+Shift+\` - Hot restart
- `Shift+F6` - Rename refactoring

### Code Navigation

**Quick Navigation:**
- `Ctrl+N` - Go to class
- `Ctrl+Shift+N` - Go to file
- `Ctrl+Alt+Shift+N` - Go to symbol
- `Ctrl+B` - Go to declaration
- `Alt+F7` - Find usages

### Debugging Features

**Debug Shortcuts:**
- `F8` - Step over
- `F7` - Step into
- `Shift+F8` - Step out
- `F9` - Resume program
- `Ctrl+F8` - Toggle breakpoint

## 📚 Next Steps

With IDE setup complete:

1. **[Run First Build](first-run.md)** - Test your configuration
2. **[Project Structure](../architecture/folder-structure.md)** - Understand the codebase
3. **[Development Workflow](../development/coding-guidelines.md)** - Start coding with best practices

---

*IDE setup typically takes 10-15 minutes and significantly improves development productivity.*
