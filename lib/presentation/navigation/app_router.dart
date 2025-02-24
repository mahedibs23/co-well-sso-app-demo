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

  static Future<void> navigateTo({
    required BuildContext context,
    required BaseRoute appRoute,
  }) {
    return Navigator.pushNamed(
      context,
      appRoute.routePath.toPathString,
      arguments: appRoute.arguments,
    );
  }

  static Future<void> navigateToAndClearStack({
    required BuildContext context,
    required BaseRoute appRoute,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      appRoute.routePath.toPathString,
      (route) => false,
      arguments: appRoute.arguments,
    );
  }

  static Future<void> pushReplacement({
    required BuildContext context,
    required BaseRoute appRoute,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      appRoute.routePath.toPathString,
      arguments: appRoute.arguments,
    );
  }

  static void popUntilAndThenNavigate({
    required BuildContext context,
    required RoutePath popUntilRoutePath, // Route to pop until
    required BaseRoute navigateToRoute, // Route to navigate to
  }) {
    _popUntil(
      context: context,
      routePath: popUntilRoutePath,
      onComplete: () {
        navigateTo(
          context: context,
          appRoute: navigateToRoute,
        );
      },
    );
  }

  static void navigateBack({
    required BuildContext context,
    VoidCallback? onComplete,
  }) {
    Navigator.maybePop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onComplete?.call();
    });
  }

  static void navigateBackUntil({
    required BuildContext context,
    required RoutePath routePath,
    VoidCallback? onComplete,
  }) {
    _popUntil(
      context: context,
      routePath: routePath,
      onComplete: onComplete,
    );
  }

  static void _popUntil({
    required BuildContext context,
    required RoutePath routePath,
    required VoidCallback? onComplete, // Callback when popUntil is done
  }) {
    Navigator.popUntil(context, (route) {
      return route.settings.name == routePath.toPathString;
    });

    // Ensure execution happens in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onComplete?.call();
    });
  }
}
