import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/theme/color/app_colors.dart';
import 'package:hello_flutter/presentation/theme/text_theme/text_theme.dart';

abstract class AppTheme {
  abstract final AppColors appColors;
  final TextTheme textTheme = AppTextTheme();
  abstract final Brightness brightness;
  abstract final AppBarTheme appBarTheme;

  ThemeData getThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: appColors.primary,
        onPrimary: appColors.onPrimary,
        primaryContainer: appColors.primaryContainer,
        onPrimaryContainer: appColors.onPrimaryContainer,
        secondary: appColors.secondary,
        onSecondary: appColors.onSecondary,
        secondaryContainer: appColors.secondaryContainer,
        onSecondaryContainer: appColors.onSecondaryContainer,
        tertiary: appColors.tertiary,
        onTertiary: appColors.onTertiary,
        tertiaryContainer: appColors.tertiaryContainer,
        onTertiaryContainer: appColors.onTertiaryContainer,
        error: appColors.error,
        onError: appColors.onError,
        errorContainer: appColors.errorContainer,
        onErrorContainer: appColors.onErrorContainer,
        surface: appColors.background,
        onSurface: appColors.onBackground,
        surfaceContainerHighest: appColors.surfaceVariant,
        onSurfaceVariant: appColors.onSurfaceVariant,
        outline: appColors.outline,
        outlineVariant: appColors.outlineVariant,
        shadow: appColors.shadow,
        scrim: appColors.scrim,
        inverseSurface: appColors.inverseSurface,
        onInverseSurface: appColors.onInverseSurface,
        inversePrimary: appColors.inversePrimary,
        surfaceTint: appColors.surfaceTint,
      ),
      textTheme: textTheme,
      appBarTheme: appBarTheme,
    );
  }
}