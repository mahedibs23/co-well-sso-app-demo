import 'package:flutter/material.dart';

import 'app_colors.dart';

class LightAppColors extends AppColors {
  @override
  Color get primary => const Color(0xFF007BFF);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  @override
  Color get primaryContainer => const Color(0xFF1abbfb);

  @override
  Color get onPrimaryContainer => const Color(0xFF022542);

  @override
  Color get secondary => const Color(0xFF0062A1);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  @override
  Color get secondaryContainer => const Color(0xFFD0E4FF);

  @override
  Color get onSecondaryContainer => const Color(0xFF001D35);

  @override
  Color get tertiary => const Color(0xFF003E6B);

  @override
  Color get onTertiary => const Color(0xFFFFFFFF);

  @override
  Color get tertiaryContainer => const Color(0xFF71A0F7);

  @override
  Color get onTertiaryContainer => const Color(0xFF0B2000);

  @override
  Color get error => const Color(0xFFBA1A1A);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  @override
  Color get errorContainer => const Color(0xFFFFDAD6);

  @override
  Color get onErrorContainer => const Color(0xFF410002);

  @override
  //Color get background> = const Color(0xFFF2FFFE);
  Color get background => const Color(0xFFFFFFFF);

  @override
  Color get onBackground => const Color(0xFF00201F);

  @override
  //Color get surface> = const Color(0xFFF2FFFE);
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get onSurface => const Color(0xFF00201F);

  @override
  Color get surfaceVariant => const Color(0xFFDDE5DA);

  @override
  Color get onSurfaceVariant => const Color(0xFF414941);

  @override
  Color get outline => const Color(0xFF717970);

  @override
  Color get outlineVariant => const Color(0xFFC1C9BE);

  @override
  Brightness brightness = Brightness.light;

  @override
  Color get inversePrimary => const Color(0xFF779ADB);

  @override
  Color get inverseSurface => const Color(0xFF001E37);

  @override
  Color get onInverseSurface => const Color(0xFFAFDBFF);

  @override
  Color get scrim => const Color(0xFF000000);

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get surfaceTint => const Color(0xFF0596CB);

  @override
  Color get customSuccess => const Color(0xFF82C828);

  @override
  Color get customError => const Color(0xFFEB5F5F);

  @override
  Color get customWarning => const Color(0xFFC8C896);

  @override
  Color get customInfo => const Color(0xFFE6E6E6);

  @override
  Color get tripInfoChipIconColor => Colors.black;

  @override
  Color get neutralVariant95 => const Color(0xFFE8F2F3);
}
