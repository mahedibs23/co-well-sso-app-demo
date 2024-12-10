import 'dart:io';

import 'package:data/local/shared_preference/shared_pref_manager.dart';
import 'package:domain/model/app_info.dart';
import 'package:domain/model/app_language.dart';
import 'package:domain/model/app_theme_mode.dart';
import 'package:domain/repository/app_repository.dart';
import 'package:domain/util/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  @override
  Future<AppInfo> getAppInfo() async {
    AppPlatform platform =
        Platform.isAndroid ? AppPlatform.android : AppPlatform.ios;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    Logger.info(
        'App Info: ${platform.toString()} $appName, $packageName, $version, $buildNumber');

    return AppInfo(
      platform: platform,
      name: appName,
      packageName: packageName,
      version: version,
      buildNumber: buildNumber,
    );
  }
}
