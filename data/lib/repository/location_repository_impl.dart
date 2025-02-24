import 'dart:async';

import 'package:data/exceptions/location/current_country_not_found_exception.dart';
import 'package:data/exceptions/location/permission_denied_forever_location_exception.dart';
import 'package:data/exceptions/location/permission_denied_location_exception.dart';
import 'package:data/exceptions/location/service_disabled_location_exception.dart';
import 'package:data/local/shared_preference/entity/country_shared_pref_entity.dart';
import 'package:data/local/shared_preference/entity/location_shared_pref_entity.dart';
import 'package:domain/model/country.dart';
import 'package:domain/model/location.dart';
import 'package:domain/repository/location_repository.dart';
import 'package:domain/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

class LocationRepositoryImpl extends LocationRepository {
  final String tag = 'LocationRepositoryImpl';

  @override
  Future<Location> getCurrentLocation() async {
    await _ensureLocationPermission();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    Logger.debug('$tag: ${position.latitude}, ${position.longitude}');
    final LocationSharedPrefEntity locationSharedPrefEntity =
        LocationSharedPrefEntity(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    locationSharedPrefEntity
        .saveToSharedPref(); // Save the last location to shared preferences

    return locationSharedPrefEntity.toDomainLocation();
  }

  @override
  Future<Location?> getLastKnownLocation() async {
    final LocationSharedPrefEntity locationSharedPrefEntity =
        await LocationSharedPrefEntity.example.getFromSharedPref()
            as LocationSharedPrefEntity;
    if (locationSharedPrefEntity.isValid()) {
      return locationSharedPrefEntity.toDomainLocation();
    }
    return null;
  }

  @override
  Future<Country> getCurrentCountry() async {
    try {
      Location location = await getCurrentLocation();
      final List<geocoding.Placemark> placeMarks = await geocoding
          .placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          )
          .timeout(const Duration(seconds: 15));
      geocoding.Placemark placeMark = placeMarks.first;
      if (placeMark.country == null || placeMark.isoCountryCode == null) {
        throw CurrentCountryNotFoundException("Could not find current country");
      }
      final CountrySharedPrefEntity countrySharedPrefEntity =
          CountrySharedPrefEntity(
        name: placeMark.country!,
        code: placeMark.isoCountryCode!,
      );

      countrySharedPrefEntity
          .saveToSharedPref(); // Save the last country to shared preferences

      return countrySharedPrefEntity.toDomainCountry();
    } catch (e) {
      throw CurrentCountryNotFoundException(
        "Could not find current country $e",
      );
    }
  }

  @override
  Future<Country?> getLastKnownCountry() async {
    final CountrySharedPrefEntity countrySharedPrefEntity =
        await CountrySharedPrefEntity.example.getFromSharedPref()
            as CountrySharedPrefEntity;
    if (countrySharedPrefEntity.isValid()) {
      return countrySharedPrefEntity.toDomainCountry();
    }
    return null;
  }

  @override
  Future<Stream<Location>> getLocationUpdates() async {
    await _ensureLocationPermission();

    late LocationSettings locationSettings;

    const int distanceFilter = 1;
    const int intervalDuration = 10;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: intervalDuration),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "The app will continue to receive your location even when you aren't using it",
          notificationTitle: "Updating location",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: distanceFilter,
        allowBackgroundLocationUpdates: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      );
    }
    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (event) => Location(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );
  }

  Future<void> _ensureLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Logger.error('$tag: Location services are disabled');
      throw ServiceDisabledLocationException('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Logger.error('$tag: Location permissions are denied');

        throw PermissionDeniedLocationException(
            'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Logger.error('$tag: Location permissions are permanently denied');

      throw PermissionDeniedForeverLocationException(
          'Location permissions are permanently denied');
    }
  }
}
