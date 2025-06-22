import 'dart:convert';

import 'package:domain/model/app_flavor.dart';
import 'package:domain/util/logger.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart' show rootBundle;

class SecretManager {
  static const String _keyString = 'etLjQVU8qRSDRMI2bfEL0LIQ8p3a6wR1';
  static final encrypt.Key _key = encrypt.Key.fromUtf8(_keyString);

  static final Map<String, dynamic> _secrets = {};

  /// Loads and decrypts the environment file from Flutter assets.
  static Future<void> loadEnvironment({
    required AppFlavor appFlavor,
  }) async {
    try {
      final assetPath = 'env-encrypted/.env.${appFlavor.name}.json.enc';

      String encryptedContent;
      try {
        encryptedContent = await rootBundle.loadString(assetPath);
        Logger.debug('✅ Loaded encrypted file from assets: $assetPath');
      } catch (e) {
        throw Exception('🔴 Failed to load encrypted asset: $assetPath');
      }

      final Map<String, dynamic> encryptedJson = jsonDecode(encryptedContent);

      final encrypt.IV iv = encrypt.IV.fromBase64(encryptedJson["iv"]);
      final encryptedData = encryptedJson["data"];

      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final decryptedContent = encrypter.decrypt64(encryptedData, iv: iv);

      Map<String, dynamic> secrets = jsonDecode(decryptedContent);
      _secrets.clear();
      _secrets.addAll(secrets);
    } catch (e) {
      throw Exception('❌ Failed to decrypt environment file: $e');
    }
  }

  /// Retrieves a secret by key.
  static dynamic getSecret(String key) => _secrets[key];

  /// Checks if all required keys exist in the loaded secrets.
  static Future<void> checkIfAllRequiredKeysExist(
    List<String> requiredKeys,
  ) async {
    for (var key in requiredKeys) {
      if (!_secrets.containsKey(key)) {
        throw Exception('❌ Missing required key: $key');
      }
    }
  }
}
