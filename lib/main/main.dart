//ignore_for_file: depend_on_referenced_packages
import 'package:domain/model/app_flavor.dart';
import 'package:domain/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/app/app.dart';
import 'package:domain/util/secret_manager.dart';

Future<void> appMain({required AppFlavor appFlavor}) async {
  final AppFlavor currentFlavor = appFlavor;

  WidgetsFlutterBinding.ensureInitialized();

  //Enable logging only in debug mode
  if (kDebugMode) {
    Logger.enableLogging();
  } else {
    Logger.disableLogging();
  }

  const requiredEnvVars = ['API_BASE_URL'];

  await SecretManager.loadEnvironment(appFlavor: appFlavor);
  Logger.debug('✅ Decrypted Environment Variables:');
  SecretManager.checkIfAllRequiredKeysExist(requiredEnvVars);
  Logger.debug(SecretManager.getSecret('API_BASE_URL')!);

  runApp(const MyApp());
}
