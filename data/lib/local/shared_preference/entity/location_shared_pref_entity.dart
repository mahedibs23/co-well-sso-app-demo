import 'package:data/local/shared_preference/entity/shared_pref_entity.dart';
import 'package:data/model/mappable.dart';
import 'package:domain/model/location.dart';

class LocationSharedPrefEntity extends SharedPrefEntity {
  final double latitude;
  final double longitude;

  LocationSharedPrefEntity({
    required this.latitude,
    required this.longitude,
  });

  @override
  String sharedPrefKey = 'last_location';

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    return LocationSharedPrefEntity(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static LocationSharedPrefEntity example = LocationSharedPrefEntity(
    latitude: 0.0,
    longitude: 0.0,
  );

  bool isValid() {
    return latitude != example.latitude && longitude != example.longitude;
  }

  Location toDomainLocation() {
    return Location(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
