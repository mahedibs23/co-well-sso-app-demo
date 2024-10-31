import 'package:data/local/shared_preference/entity/shared_pref_entity.dart';
import 'package:data/model/mappable.dart';
import 'package:domain/model/app_language.dart';

class AppLanguageSharedPrefEntity extends SharedPrefEntity {
  AppLanguage appLanguage;

  AppLanguageSharedPrefEntity({
    required this.appLanguage,
  });

  factory AppLanguageSharedPrefEntity.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('appLanguage')) {
      throw ArgumentError('Missing required keys in JSON');
    }
    return AppLanguageSharedPrefEntity(
      appLanguage: AppLanguage.fromString(json['appLanguage']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'appLanguage': appLanguage.toString(),
    };
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    return AppLanguageSharedPrefEntity.fromJson(json);
  }

  @override
  String sharedPrefKey = 'app_language';

  static AppLanguageSharedPrefEntity example = AppLanguageSharedPrefEntity(
    appLanguage: AppLanguage.en,
  );
}
