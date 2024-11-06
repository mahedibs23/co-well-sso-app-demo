import 'package:domain/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hello_flutter/main/flavors.dart';
import 'package:hello_flutter/presentation/app/app.dart';

void appMain({required AppFlavor appFlavor}) async {
  F.appFlavor = appFlavor;
  await F.loadEnvironment();

  const requiredEnvVars = ['API_BASE_URL', 'API_TOKEN'];

  bool hasEnv = dotenv.isEveryDefined(requiredEnvVars);

  if (!hasEnv) {
    throw Exception('Missing required environment variables: $requiredEnvVars');
  }

  //Enable logging only in debug mode
  if (kDebugMode) {
    Logger.enableLogging();
  } else {
    Logger.disableLogging();
  }

  Logger.info("*********************************************");
  Logger.info("App is running in ${F.appFlavor} mode");
  Logger.debug("API_BASE_URL:${dotenv.env['API_BASE_URL']}");
  Logger.debug("API_TOKEN:${dotenv.env['API_TOKEN']}");
  Logger.info("*********************************************");

  runApp(const MyApp());
}
