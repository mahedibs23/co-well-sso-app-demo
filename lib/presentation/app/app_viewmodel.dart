import 'package:domain/model/app_language.dart';
import 'package:domain/model/app_theme_mode.dart';
import 'package:domain/repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';

class AppViewModel extends BaseViewModel {
  final AppRepository appRepository;
  final ValueNotifier<AppThemeMode> selectedThemeMode =
      ValueNotifier(AppThemeMode.system);

  final ValueNotifier<AppLanguage> selectedLanguage =
      ValueNotifier(AppLanguage.ja);

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
    selectedThemeMode.value = await loadData(
      appRepository.getApplicationThemeMode(),
    );
  }

  Future<void> _loadLanguageInfo() async {
    selectedLanguage.value = await loadData(
      appRepository.getApplicationLocale(),
    );
  }

  Future<void> onThemeChangeRequest(AppThemeMode appThemeMode) async {
    await appRepository.saveApplicationThemeMode(appThemeMode);
    selectedThemeMode.value = appThemeMode;
  }

  Future<void> onLanguageChangeRequest(AppLanguage language) async {
    await appRepository.saveApplicationLocale(language);
    selectedLanguage.value = language;
  }
}
