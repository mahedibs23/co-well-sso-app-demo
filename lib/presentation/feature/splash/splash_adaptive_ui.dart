import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_adaptive_ui.dart';
import 'package:hello_flutter/presentation/feature/splash/binding/splash_binding.dart';
import 'package:hello_flutter/presentation/feature/splash/route/splash_argument.dart';
import 'package:hello_flutter/presentation/feature/splash/splash_view_model.dart';
import 'package:hello_flutter/presentation/feature/splash/route/splash_route.dart';
import 'package:hello_flutter/presentation/feature/splash/screen/splash_mobile_portrait.dart';
import 'package:hello_flutter/presentation/feature/splash/screen/splash_mobile_landscape.dart';

class SplashAdaptiveUi extends BaseAdaptiveUi<SplashArgument, SplashRoute> {
  const SplashAdaptiveUi({super.argument, super.key});

  @override
  State<StatefulWidget> createState() => SplashAdaptiveUiState();
}

class SplashAdaptiveUiState extends BaseAdaptiveUiState<SplashArgument, SplashRoute, SplashAdaptiveUi, SplashViewModel, SplashBinding> {
  @override
  SplashBinding binding = SplashBinding();

  @override
  StatefulWidget mobilePortraitContents(BuildContext context) {
    return SplashMobilePortrait(viewModel: viewModel);
  }

  @override
  StatefulWidget mobileLandscapeContents(BuildContext context) {
    return SplashMobileLandscape(viewModel: viewModel);
  }
}
