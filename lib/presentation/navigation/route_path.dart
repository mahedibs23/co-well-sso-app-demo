import 'package:hello_flutter/presentation/feature/splash/route/splash_argument.dart';
import 'package:hello_flutter/presentation/feature/splash/route/splash_route.dart';
import 'package:hello_flutter/presentation/base/base_argument.dart';
import 'package:hello_flutter/presentation/base/base_route.dart';
import 'package:hello_flutter/presentation/feature/auth/login/route/login_argument.dart';
import 'package:hello_flutter/presentation/feature/auth/login/route/login_route.dart';
import 'package:hello_flutter/presentation/feature/home/movie_list/route/movie_list_argument.dart';
import 'package:hello_flutter/presentation/feature/home/movie_list/route/movie_list_route.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_argument.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_route.dart';
import 'package:hello_flutter/presentation/feature/movieDetails/route/movie_details_argument.dart';
import 'package:hello_flutter/presentation/feature/movieDetails/route/movie_details_route.dart';
import 'package:hello_flutter/presentation/feature/settings/route/settings_argument.dart';
import 'package:hello_flutter/presentation/feature/settings/route/settings_route.dart';
import 'package:hello_flutter/presentation/navigation/unknown_page_route.dart';

enum RoutePath {
  login,
  home,
  movieList,
  movieSearch,
  movieBookmark,
  setting,
  movieDetails,
  splash, 
  unknown;

  static RoutePath fromString(String? path) {
    switch (path) {
      case '/login':
        return RoutePath.login;
      case '/home':
        return RoutePath.home;
      case '/movieList':
        return RoutePath.movieList;
      case '/movieSearch':
        return RoutePath.movieSearch;
      case '/movieBookmark':
        return RoutePath.movieBookmark;
      case '/setting':
        return RoutePath.setting;
      case '/movieDetails':
        return RoutePath.movieDetails;
      case '/splash':
        return RoutePath.splash;
      default:
        return RoutePath.unknown;
    }
  }

  String get toPathString {
    switch (this) {
      case RoutePath.login:
        return '/login';
      case RoutePath.home:
        return '/home';
      case RoutePath.movieList:
        return '/movieList';
      case RoutePath.movieSearch:
        return '/movieSearch';
      case RoutePath.movieBookmark:
        return '/movieBookmark';
      case RoutePath.setting:
        return '/setting';
      case RoutePath.movieDetails:
        return '/movieDetails';
      case RoutePath.splash:
        return '/splash';
      default:
        return '';
    }
  }

  BaseRoute getAppRoute({BaseArgument? arguments}) {
    switch (this) {
      case RoutePath.login:
        return LoginRoute(
          arguments: arguments as LoginArgument?,
        );
      case RoutePath.home:
        if (arguments is! HomeArgument) {
          throw Exception('HomeArgument is required');
        }
        return HomeRoute(arguments: arguments);
      case RoutePath.movieList:
        if (arguments is! MovieListArgument) {
          throw Exception('MovieListArgument is required');
        }
        return MovieListRoute(arguments: arguments);
      case RoutePath.movieDetails:
        if (arguments is! MovieDetailsArgument) {
          throw Exception('MovieDetailsArgument is required');
        }
        return MovieDetailsRoute(arguments: arguments);
      case RoutePath.setting:
        if (arguments is! SettingsArgument) {
          throw Exception('SettingsArgument is required');
        }
        return SettingsRoute(arguments: arguments);
      case RoutePath.splash:
        if (arguments is! SplashArgument) {
          throw Exception('SplashArgument is required');
        }
        return SplashRoute(arguments: arguments);
      default:
        return UnknownRoute(arguments: arguments);
    }
  }
}
