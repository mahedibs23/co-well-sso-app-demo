import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/feature/home/movie_list/movie_list_adaptive_ui.dart';
import 'package:hello_flutter/presentation/feature/settings/settings_adaptive_ui.dart';
import 'package:hello_flutter/presentation/localization/generated/app_localizations.dart';

enum NavigationItemType {
  movieList,
  movieSearch,
  movieBookmark,
  settings;

  IconData get icon {
    switch (this) {
      case NavigationItemType.movieList:
        return Icons.movie_outlined;
      case NavigationItemType.movieSearch:
        return Icons.search_outlined;
      case NavigationItemType.movieBookmark:
        return Icons.bookmark_outline;
      case NavigationItemType.settings:
        return Icons.settings_outlined;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case NavigationItemType.movieList:
        return Icons.movie;
      case NavigationItemType.movieSearch:
        return Icons.search;
      case NavigationItemType.movieBookmark:
        return Icons.bookmark;
      case NavigationItemType.settings:
        return Icons.settings;
    }
  }

  Widget get page {
    switch (this) {
      case NavigationItemType.movieList:
        return const MovieListAdaptiveUi();
      case NavigationItemType.movieSearch:
        return const Center(child: Text('Search'));
      case NavigationItemType.movieBookmark:
        return const Center(child: Text('Bookmark'));
      case NavigationItemType.settings:
        return const SettingsAdaptiveUi();
    }
  }

  String getLocalizedName(AppLocalizations localizations) {
    switch (this) {
      case NavigationItemType.movieList:
        return localizations.navigation_item__home;
      case NavigationItemType.movieSearch:
        return localizations.navigation_item__search;
      case NavigationItemType.movieBookmark:
        return localizations.navigation_item__bookmark;
      case NavigationItemType.settings:
        return localizations.navigation_item__settings;
    }
  }
}
