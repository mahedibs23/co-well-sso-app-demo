//ignore_for_file: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hello_flutter/presentation/localization/generated/app_localizations.dart';

enum AppFlavor {
  dev,
  test,
  staging,
  prod;

  @override
  toString() {
    switch (this) {
      case AppFlavor.dev:
        return 'Dev';
      case AppFlavor.test:
        return 'Test';
      case AppFlavor.staging:
        return 'Staging';
      case AppFlavor.prod:
        return 'Prod';
    }
  }
}

class F {
  static AppFlavor? appFlavor;

  static String get name => appFlavor?.toString() ?? '';

  static String getLocalizedAppTitleWithFlavor(AppLocalizations localizations) {
    return "${localizations.app_name} $appFlavor";
  }

  static loadEnvironment() async {
    String fileName = 'env/';
    switch (appFlavor) {
      case AppFlavor.dev:
        fileName += '.env.dev';
        break;
      case AppFlavor.test:
        fileName += '.env.test';
        break;
      case AppFlavor.staging:
        fileName += '.env.staging';
        break;
      case AppFlavor.prod:
        fileName += '.env.prod';
        break;
      default:
        fileName += '.env';
    }
    return await dotenv.load(fileName: fileName);
  }
}
