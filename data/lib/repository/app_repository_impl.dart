import 'dart:io';

import 'package:data/local/shared_preference/shared_pref_manager.dart';
import 'package:domain/model/app_language.dart';
import 'package:domain/model/app_theme_mode.dart';
import 'package:domain/repository/app_repository.dart';

class AppRepositoryImpl implements AppRepository {
  final String deviceSettingsLocaleName = Platform.localeName;
  final String deviceSettingsThemeMode = 'system';

  final SharedPrefManager sharedPrefManager;

  AppRepositoryImpl({required this.sharedPrefManager});

  @override
  Future<AppLanguage> getApplicationLocale() async {
    String? savedAppLanguageLocaleString =
        await sharedPrefManager.getValue<String?>('language', null);
    if (savedAppLanguageLocaleString == null) {
      return AppLanguage.fromString(deviceSettingsLocaleName);
    }
    return AppLanguage.fromString(savedAppLanguageLocaleString);
  }

  @override
  Future<AppThemeMode> getApplicationThemeMode() async {
    String? savedAppThemeModeString =
        await sharedPrefManager.getValue<String?>('theme', null);
    if (savedAppThemeModeString == null) {
      return AppThemeMode.fromString(deviceSettingsThemeMode);
    }
    return AppThemeMode.fromString(savedAppThemeModeString);
  }

  @override
  Future<void> saveApplicationLocale(AppLanguage appLanguage) {
    return sharedPrefManager.saveValue(
      'language',
      appLanguage.toString(),
    );
  }

  @override
  Future<void> saveApplicationThemeMode(AppThemeMode themeMode) {
    return sharedPrefManager.saveValue(
      'theme',
      themeMode.toString(),
    );
  }
}
