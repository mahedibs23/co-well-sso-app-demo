import 'package:domain/model/app_info.dart';
import 'package:domain/model/app_language.dart';
import 'package:domain/model/app_theme_mode.dart';

abstract class AppRepository {
  Future<AppLanguage> getApplicationLocale();

  Future<AppThemeMode> getApplicationThemeMode();

  Future<void> saveApplicationLocale(AppLanguage appLanguage);

  Future<void> saveApplicationThemeMode(AppThemeMode themeMode);

  Future<AppInfo> getAppInfo();
}
