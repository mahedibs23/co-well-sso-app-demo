import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/feature/auth/login/screen/login_ui_mobile_portrait.dart';

class LoginUiMobileLandscape extends LoginUiMobilePortrait {
  const LoginUiMobileLandscape({required super.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => LoginUiMobileLandscapeState();
}

class LoginUiMobileLandscapeState extends LoginUiMobilePortraitState {}
