import 'package:data/local/shared_preference/entity/shared_pref_entity.dart';
import 'package:data/model/mappable.dart';
import 'package:domain/model/app_theme_mode.dart';

class AppThemeModeSharedPrefEntity extends SharedPrefEntity {
  AppThemeMode themeMode;

  AppThemeModeSharedPrefEntity({
    required this.themeMode,
  });

  factory AppThemeModeSharedPrefEntity.fromJson(
      Map<String, dynamic> json) {
    if (!json.containsKey('themeMode')) {
      throw ArgumentError('Missing required keys in JSON');
    }
    return AppThemeModeSharedPrefEntity(
      themeMode: AppThemeMode.fromString(json['themeMode']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.toString(),
    };
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    return AppThemeModeSharedPrefEntity.fromJson(json);
  }

  @override
  String sharedPrefKey = 'app_theme_mode';

  static AppThemeModeSharedPrefEntity example =
      AppThemeModeSharedPrefEntity(
    themeMode: AppThemeMode.system,
  );
}
