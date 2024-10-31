import 'package:data/local/shared_preference/entity/shared_pref_entity.dart';
import 'package:data/model/mappable.dart';
import 'package:domain/model/country.dart';

class CountrySharedPrefEntity extends SharedPrefEntity {
  final String name;
  final String code;

  CountrySharedPrefEntity({
    required this.name,
    required this.code,
  });

  @override
  String sharedPrefKey = 'country';

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    return CountrySharedPrefEntity(
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }

  static CountrySharedPrefEntity example = CountrySharedPrefEntity(
    name: '',
    code: '',
  );

  Country toDomainCountry() {
    return Country(
      name: name,
      code: code,
    );
  }

  bool isValid() {
    return name != example.name && code != example.code;
  }
}
