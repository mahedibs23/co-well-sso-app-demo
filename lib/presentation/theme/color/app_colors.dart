import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/theme/color/dark_app_colors.dart';
import 'package:hello_flutter/presentation/theme/color/light_app_colors.dart';

abstract class AppColors {
  Brightness get brightness;

  Color get primary;

  Color get onPrimary;

  Color get primaryContainer;

  Color get onPrimaryContainer;

  Color get secondary;

  Color get onSecondary;

  Color get secondaryContainer;

  Color get onSecondaryContainer;

  Color get tertiary;

  Color get onTertiary;

  Color get tertiaryContainer;

  Color get onTertiaryContainer;

  Color get error;

  Color get onError;

  Color get errorContainer;

  Color get onErrorContainer;

  Color get background;

  Color get onBackground;

  Color get surface;

  Color get onSurface;

  Color get surfaceVariant;

  Color get onSurfaceVariant;

  Color get outline;

  Color get outlineVariant;

  Color get shadow;

  Color get scrim;

  Color get inverseSurface;

  Color get onInverseSurface;

  Color get inversePrimary;

  Color get surfaceTint;

  Color get customSuccess;

  Color get customError;

  Color get customWarning;

  Color get customInfo;

  Color get tripInfoChipIconColor;

  Color get neutralVariant95;

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? LightAppColors()
        : DarkAppColors();
  }
}
