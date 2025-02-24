import 'package:domain/exceptions/base_exception.dart';
import 'package:hello_flutter/presentation/base/base_route.dart';
import 'package:hello_flutter/presentation/localization/ui_text.dart';
import 'package:hello_flutter/presentation/model/toast_type.dart';
import 'package:hello_flutter/presentation/navigation/route_path.dart';

class BaseState {}

class ShowLoadingDialogBaseState extends BaseState {}

class DismissLoadingDialogBaseState extends BaseState {}

class NavigateBaseState extends BaseState {
  final BaseRoute destination;
  final bool isReplacement;
  final bool isClearBackStack;
  final RoutePath? popUntilRoutePath;
  void Function()? onPop;

  NavigateBaseState({
    required this.destination,
    required this.isReplacement,
    this.isClearBackStack = false,
    this.popUntilRoutePath,
    this.onPop,
  });
}

class ShowToastBaseState extends BaseState {
  final UiText uiText;
  final ToastType toastType;
  final Duration? toastDuration;

  ShowToastBaseState({
    required this.uiText,
    this.toastType = ToastType.info,
    this.toastDuration,
  });
}

class HandleErrorBaseState extends BaseState {
  final BaseException baseError;
  final bool shouldShowToast;

  HandleErrorBaseState({
    required this.baseError,
    this.shouldShowToast = true,
  });
}

class NavigateBackBaseState extends BaseState {
  final RoutePath? popUntilRoutePath;
  void Function()? onComplete;

  NavigateBackBaseState({
    this.popUntilRoutePath,
    this.onComplete,
  });
}

class StartShowCaseBaseState extends BaseState {}
