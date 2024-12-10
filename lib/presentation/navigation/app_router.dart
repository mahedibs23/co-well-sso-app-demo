import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_argument.dart';
import 'package:hello_flutter/presentation/base/base_route.dart';
import 'package:hello_flutter/presentation/feature/splash/route/splash_argument.dart';
import 'package:hello_flutter/presentation/navigation/route_path.dart';

class AppRouter {
  static final initialRoute = RoutePath.splash.toPathString;

  static BaseArgument initialArguments = SplashArgument();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argObj = settings.arguments;

    BaseArgument? arguments;
    if (argObj == null) {
      arguments = initialArguments;
    }
    if (argObj is BaseArgument) {
      arguments = argObj;
    }
    if (settings.name == null) {
      throw Exception('Route name is null');
    }
    final String routeName = (settings.name == Navigator.defaultRouteName)
        ? initialRoute
        : settings.name!;
    final RoutePath routePath = RoutePath.fromString(routeName);
    final BaseRoute appRoute = routePath.getAppRoute(arguments: arguments);
    return appRoute.toMaterialPageRoute();
  }

  static Future<void> navigateTo(BuildContext context, BaseRoute appRoute) {
    return Navigator.pushNamed(
      context,
      appRoute.routePath.toPathString,
      arguments: appRoute.arguments,
    );
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<void> navigateToAndClearStack(
      BuildContext context, BaseRoute appRoute) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      appRoute.routePath.toPathString,
      (route) => false,
      arguments: appRoute.arguments,
    );
  }

  static Future<void> pushReplacement(
      BuildContext context, BaseRoute appRoute) {
    return Navigator.pushReplacementNamed(
      context,
      appRoute.routePath.toPathString,
      arguments: appRoute.arguments,
    );
  }
}
