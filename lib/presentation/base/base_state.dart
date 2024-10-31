import 'package:domain/exceptions/base_exception.dart';
import 'package:hello_flutter/presentation/base/base_route.dart';
import 'package:hello_flutter/presentation/localization/ui_text.dart';

class BaseState {}

class ShowLoadingDialogBaseState extends BaseState {}

class DismissLoadingDialogBaseState extends BaseState {}

class NavigateBaseState extends BaseState {
  final BaseRoute destination;
  final bool isReplacement;
  final bool isClearBackStack;
  void Function()? onPop;

  NavigateBaseState({
    required this.destination,
    required this.isReplacement,
    this.isClearBackStack = false,
    this.onPop,
  });
}

class ShowToastBaseState extends BaseState {
  final UiText uiText;

  ShowToastBaseState({required this.uiText});
}

class HandleErrorBaseState extends BaseState {
  final BaseException baseError;
  final bool shouldShowToast;

  HandleErrorBaseState({
    required this.baseError,
    this.shouldShowToast = true,
  });
}

class NavigateBackBaseState extends BaseState {}
