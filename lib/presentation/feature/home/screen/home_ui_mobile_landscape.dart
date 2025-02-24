import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/feature/home/screen/home_ui_mobile_potrait.dart';

class HomeUiMobileLandscape extends HomeUiMobilePortrait {
  const HomeUiMobileLandscape({required super.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => HomeUiMobileLandscapeState();
}

class HomeUiMobileLandscapeState extends HomeUiMobilePortraitState {
}
