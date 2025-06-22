// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:args/args.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('env', abbr: 'e', help: 'The environment (dev, prod, etc.)')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show usage information');

  final argResults = parser.parse(arguments);

  if (argResults['help'] as bool) {
    stdout.writeln('Usage: encrypt_env.dart --env=<environment> [options]');
    stdout.writeln(parser.usage);
    return;
  }

  final List<String> flavors = [
    'dev',
    'test',
    'staging',
    'prod'
  ];

  final environments =
      argResults.wasParsed('env') ? [argResults['env'] as String] : flavors;

  final key = encrypt.Key.fromUtf8(
      'etLjQVU8qRSDRMI2bfEL0LIQ8p3a6wR1'); // 32 bytes AES-256
  final iv = encrypt.IV.fromLength(16);

  for (final flavor in environments) {
    final envFile = File('env/.env.$flavor.json');
    if (!await envFile.exists()) {
      stdout.writeln('Error: Environment file not found: ${envFile.path}');
      continue;
    }

    final envContent = await envFile.readAsString();

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encryptedContent = encrypter.encrypt(envContent, iv: iv).base64;

    final encryptedJson = jsonEncode({
      "iv": iv.base64, // Store IV for proper decryption
      "data": encryptedContent,
    });

    final secureEnvDir = Directory('env-encrypted');
    if (!await secureEnvDir.exists()) {
      await secureEnvDir.create();
    }

    final encryptedEnvFile = File('env-encrypted/.env.$flavor.json.enc');
    await encryptedEnvFile.writeAsString(encryptedJson);

    stdout.writeln(
        '✅ Encryption completed for $flavor -> env-encrypted/.env.$flavor.json.enc');
  }
}
