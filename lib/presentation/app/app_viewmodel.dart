import 'package:domain/model/app_language.dart';
import 'package:domain/model/app_theme_mode.dart';
import 'package:domain/repository/app_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';

class AppViewModel extends BaseViewModel {
  final AppRepository appRepository;
  final ValueNotifier<AppThemeMode> _selectedThemeMode =
      ValueNotifier(AppThemeMode.system);

  ValueListenable<AppThemeMode> get selectedThemeMode => _selectedThemeMode;

  final ValueNotifier<AppLanguage> _selectedLanguage =
      ValueNotifier(AppLanguage.ja);

  ValueListenable<AppLanguage> get selectedLanguage => _selectedLanguage;

  AppViewModel({
    required this.appRepository,
  }) {
    _initializeData();
  }

  void _initializeData() async {
    await _loadThemeInfo();
    await _loadLanguageInfo();
  }

  Future<void> _loadThemeInfo() async {
    _selectedThemeMode.value = await loadData(
      appRepository.getApplicationThemeMode(),
    );
  }

  Future<void> _loadLanguageInfo() async {
    _selectedLanguage.value = await loadData(
      appRepository.getApplicationLocale(),
    );
  }

  Future<void> onThemeChangeRequest(AppThemeMode appThemeMode) async {
    await appRepository.saveApplicationThemeMode(appThemeMode);
    _selectedThemeMode.value = appThemeMode;
  }

  Future<void> onLanguageChangeRequest(AppLanguage language) async {
    await appRepository.saveApplicationLocale(language);
    _selectedLanguage.value = language;
  }
}
