import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/theme/app_theme.dart';
import 'package:hello_flutter/presentation/theme/color/app_colors.dart';
import 'package:hello_flutter/presentation/theme/color/dark_app_colors.dart';
import 'package:hello_flutter/presentation/theme/text_theme/text_theme.dart';

class DarkAppTheme extends AppTheme {
  @override
  AppColors appColors = DarkAppColors();

  @override
  Brightness brightness = Brightness.dark;

  @override
  AppBarTheme appBarTheme = AppBarTheme(
    titleTextStyle: AppTextTheme().titleLarge?.copyWith(
          color: DarkAppColors().onBackground,
        ),
  );
}
