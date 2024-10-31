import 'package:domain/model/country.dart';
import 'package:domain/model/location.dart';

abstract class LocationRepository {
  Future<Location> getCurrentLocation();

  Future<Location?> getLastKnownLocation();

  Future<Country> getCurrentCountry();

  Future<Country?> getLastKnownCountry();

  Future<Stream<Location>> getLocationUpdates();
}
