import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hello_flutter/presentation/base/adaptive_util/platform_utils.dart';
import 'package:hello_flutter/presentation/values/dimens.dart';

class ScreenUtilBuilder extends StatelessWidget {
  final Widget? child;

  const ScreenUtilBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      PlatformUtils platformUtils = PlatformUtils(mediaQueryData);
      return ScreenUtilInit(
        designSize: _getLayoutSize(platformUtils),
        minTextAdapt: true,
        builder: (BuildContext context, Widget? child) {
          return this.child ?? const SizedBox.shrink();
        },
      );
    });
  }

  Size _getLayoutSize(PlatformUtils platformUtils) {
    if (platformUtils.screenType == AdaptiveScreenType.mobile &&
        platformUtils.screenOrientation == ScreenOrientation.portrait) {
      return const Size(
        Dimens.defaultMobileLayoutWidth,
        Dimens.defaultMobileLayoutHeight,
      );
    } else if (platformUtils.screenType == AdaptiveScreenType.mobile &&
        platformUtils.screenOrientation == ScreenOrientation.landscape) {
      return const Size(
        Dimens.defaultMobileLayoutHeight,
        Dimens.defaultMobileLayoutWidth,
      );
    } else if (platformUtils.screenType == AdaptiveScreenType.tablet &&
        platformUtils.screenOrientation == ScreenOrientation.landscape) {
      return const Size(
        Dimens.defaultTabletLayoutHeight,
        Dimens.defaultTabletLayoutWidth,
      );
    } else if (platformUtils.screenType == AdaptiveScreenType.tablet &&
        platformUtils.screenOrientation == ScreenOrientation.portrait) {
      return const Size(
        Dimens.defaultTabletLayoutWidth,
        Dimens.defaultTabletLayoutHeight,
      );
    } else {
      return const Size(
        Dimens.defaultMobileLayoutWidth,
        Dimens.defaultMobileLayoutHeight,
      );
    }
  }
}
