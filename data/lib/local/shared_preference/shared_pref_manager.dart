import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:domain/util/logger.dart';

class SharedPrefManager {
  SharedPrefManager._privateConstructor();

  static final SharedPrefManager _instance =
      SharedPrefManager._privateConstructor();

  factory SharedPrefManager() => _instance;

  late final Future<SharedPreferences> _sharedPreferencesFuture =
      SharedPreferences.getInstance();

  Future<void> saveValue<T>(
    String key,
    T value, {
    Map<String, dynamic> Function(T value)? modelToJsonConverter,
  }) async {
    final prefs = await _sharedPreferencesFuture;

    try {
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (modelToJsonConverter != null) {
        await prefs.setString(key, json.encode(modelToJsonConverter(value)));
      } else {
        throw ArgumentError("Unsupported type without converter: $T");
      }
      Logger.debug("Saved to shared preferences: $key - $value");
    } catch (e) {
      Logger.error("Error while saving value to shared preferences: $e");
    }
  }

  Future<T?> getValue<T>(
    String key,
    T? defaultValue, {
    T Function(dynamic json)? convertJsonToModel,
  }) async {
    final prefs = await _sharedPreferencesFuture;

    try {
      final value = prefs.get(key);
      if (value == null) {
        return defaultValue;
      }

      if (T == String || T == int || T == double || T == bool) {
        return value as T;
      } else if (value is String && convertJsonToModel != null) {
        return convertJsonToModel(json.decode(value));
      } else {
        throw ArgumentError("Unsupported type without converter: $T");
      }
    } catch (e) {
      Logger.error("Error while getting value from shared preferences: $e");
      return defaultValue;
    }
  }

  Future<bool> clear(String key) async {
    try {
      final prefs = await _sharedPreferencesFuture;
      await prefs.remove(key);
      return true;
    } catch (e) {
      Logger.error("Error while clearing shared preferences: $e");
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      final prefs = await _sharedPreferencesFuture;
      await prefs.clear();
      return true;
    } catch (e) {
      Logger.error("Error while clearing all shared preferences: $e");
      return false;
    }
  }
}
