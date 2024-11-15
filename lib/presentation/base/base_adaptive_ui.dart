import 'package:domain/exceptions/base_exception.dart';
import 'package:domain/exceptions/location_exceptions.dart';
import 'package:domain/exceptions/network_exceptions.dart';
import 'package:domain/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_flutter/presentation/base/adaptive_util/adaptive_screen_builder.dart';
import 'package:hello_flutter/presentation/base/base_argument.dart';
import 'package:hello_flutter/presentation/base/base_binding.dart';
import 'package:hello_flutter/presentation/base/base_route.dart';
import 'package:hello_flutter/presentation/base/base_state.dart';
import 'package:hello_flutter/presentation/base/base_ui_state.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';
import 'package:hello_flutter/presentation/localization/ui_text.dart';
import 'package:hello_flutter/presentation/navigation/app_router.dart';

abstract class BaseAdaptiveUi<A extends BaseArgument, R extends BaseRoute<A>>
    extends StatefulWidget {
  final A? argument;

  const BaseAdaptiveUi({this.argument, super.key});
}

abstract class BaseAdaptiveUiState<
    A extends BaseArgument,
    R extends BaseRoute<A>,
    W extends BaseAdaptiveUi<A, R>,
    V extends BaseViewModel<A>,
    B extends BaseBinding> extends BaseUiState<W> {
  abstract B binding;

  late V viewModel;
  bool _isDependencyInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  Future<void> _initializeDependencies() async {
    await binding.addDependencies();

    viewModel = await binding.diModule.resolve<V>();
    _isDependencyInitialized = true;
    viewModel.baseState.addListener(_baseStateListener);
    setState(() {});
    _addPostFrameCallback();
  }

  void _addPostFrameCallback() {
    //This is used to call the onViewReady method once the widget is fully rendered
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        onViewReady(argument: widget.argument);
      },
    );
  }

  @protected
  void onViewReady({A? argument}) {
    if (!_isDependencyInitialized) return;
    viewModel.onViewReady(argument: argument);
  }

  @override
  void dispose() {
    if (!_isDependencyInitialized) return;
    viewModel.baseState.removeListener(_baseStateListener);
    binding.removeDependencies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDependencyInitialized) {
      return const SizedBox.shrink();
    }
    return AdaptiveScreenBuilder(
      mobilePortraitContentBuilder: mobilePortraitContents,
      mobileLandscapeContentBuilder: mobileLandscapeContents,
      tabPortraitContentBuilder: tabPortraitContents,
      tabLandscapeContentBuilder: tabLandscapeContents,
      largeScreenPortraitContentBuilder: largeScreenPortraitContents,
      largeScreenLandscapeContentBuilder: largeScreenLandscapeContents,
    );
  }

  StatefulWidget mobilePortraitContents(
    BuildContext context,
  );

  StatefulWidget mobileLandscapeContents(
    BuildContext context,
  ) {
    return mobilePortraitContents(context);
  }

  StatefulWidget tabPortraitContents(
    BuildContext context,
  ) {
    return mobileLandscapeContents(context);
  }

  StatefulWidget tabLandscapeContents(
    BuildContext context,
  ) {
    return mobileLandscapeContents(context);
  }

  StatefulWidget largeScreenPortraitContents(
    BuildContext context,
  ) {
    return tabPortraitContents(context);
  }

  StatefulWidget largeScreenLandscapeContents(
    BuildContext context,
  ) {
    return tabLandscapeContents(context);
  }

  //This is to prevent multiple dialog showing at the same time
  //As in HomeScreen we are using multiple viewModels and all of them can show loading dialog using their own baseViewModel
  bool get isShowingLoadingDialog => ModalRoute.of(context)?.isCurrent != true;

  /// This listener is used to listen to the base state changes of baseViewModel and perform the UI action accordingly
  void _baseStateListener() {
    if (!mounted) {
      return; //This is used to check if the widget is still mounted or not
    }
    BaseState baseState = viewModel.baseState.value;
    if (baseState is ShowLoadingDialogBaseState) {
      if (isShowingLoadingDialog) return;
      _showLoadingDialog(context);
    }
    if (baseState is DismissLoadingDialogBaseState) {
      if (isShowingLoadingDialog) {
        _dismissLoadingDialog(context);
      }
    }
    if (baseState is NavigateBaseState) {
      _navigate(
        context: context,
        destination: baseState.destination,
        isReplacement: baseState.isReplacement,
        isClearBackStack: baseState.isClearBackStack,
        onPop: baseState.onPop,
      );
    }
    if (baseState is ShowToastBaseState) {
      _showToast(uiText: baseState.uiText);
    }
    if (baseState is HandleErrorBaseState) {
      _handleError(
        error: baseState.baseError,
        context: context,
        shouldShowToast: baseState.shouldShowToast,
      );
    }
    if (baseState is NavigateBackBaseState) {
      _navigateBack();
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showToast({required UiText uiText}) {
    Fluttertoast.showToast(
      msg: uiText.extract(localizations: context.localizations),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _dismissLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _navigate({
    required BuildContext context,
    required BaseRoute destination,
    bool isReplacement = false,
    bool isClearBackStack = false,
    void Function()? onPop,
  }) async {
    if (isClearBackStack) {
      await AppRouter.navigateToAndClearStack(context, destination);
    } else if (isReplacement) {
      await AppRouter.pushReplacement(context, destination);
    } else {
      await AppRouter.navigateTo(context, destination);
    }
    onPop?.call();
  }

  void _navigateBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _handleError({
    required BaseException error,
    required BuildContext context,
    required bool shouldShowToast,
  }) {
    String msg =
        "${context.localizations.error_massage__an_error_occurred_please_try_again_later} \n ${error.message}";
    if (error is NetworkException) {
      msg = context.localizations.error__network_error_with_error_and_message(
          error.code!, error.message);
    }
    if (error is LocationException) {
      msg = context.localizations.location_error__something_went_wrong;
    }
    //TODO: Add more error handling based on different Exceptions
    Logger.error(msg);
    Logger.error(
      error.toString(),
      error: error,
      stackTrace: error.stackTrace,
    );
    if (shouldShowToast) {
      _showToast(
        uiText: FixedUiText(
          text: msg,
        ),
      );
    }
  }
}
