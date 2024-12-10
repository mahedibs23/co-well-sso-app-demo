import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/feature/splash/screen/splash_mobile_portrait.dart';

class SplashMobileLandscape extends SplashMobilePortrait {
  const SplashMobileLandscape({required super.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => SplashMobileLandscapeState();
}

class SplashMobileLandscapeState extends SplashMobilePortraitState {}
