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
import 'package:hello_flutter/presentation/common/widget/app_loading_indicator.dart';
import 'package:hello_flutter/presentation/localization/ui_text.dart';
import 'package:hello_flutter/presentation/model/toast_type.dart';
import 'package:hello_flutter/presentation/navigation/app_router.dart';
import 'package:hello_flutter/presentation/navigation/route_path.dart';
import 'package:hello_flutter/presentation/theme/color/app_colors.dart';
import 'package:hello_flutter/presentation/values/dimens.dart';

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
        popUntilRoutePath: baseState.popUntilRoutePath,
        onPop: baseState.onPop,
      );
    }
    if (baseState is ShowToastBaseState) {
      _showToast(
        uiText: baseState.uiText,
        toastType: baseState.toastType,
        toastDuration: baseState.toastDuration,
      );
    }
    if (baseState is HandleErrorBaseState) {
      _handleError(
        error: baseState.baseError,
        context: context,
        shouldShowToast: baseState.shouldShowToast,
      );
    }
    if (baseState is NavigateBackBaseState) {
      _navigateBack(
        baseState.popUntilRoutePath,
        baseState.onComplete,
      );
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: AppLoadingIndicator(
          color: AppColors.of(context).background,
        ),
      ),
    );
  }

  void _showToast({
    required UiText uiText,
    required ToastType toastType,
    Duration? toastDuration,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.dimen_20, vertical: Dimens.dimen_10),
      decoration: BoxDecoration(
        color: toastType.getColor(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              uiText.extract(localizations: context.localizations),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.of(context).onPrimary,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () => fToast.removeCustomToast(),
            child: Icon(
              Icons.close,
              size: Dimens.dimen_14,
              color: AppColors.of(context).onPrimary,
            ),
          )
        ],
      ),
    );

    // If any active toast present remove the toast.
    // otherwise, it will show multiple toast fading out
    // if we don't remove the previous toast
    fToast.removeCustomToast();

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: toastDuration ?? const Duration(seconds: 2),
      fadeDuration: const Duration(milliseconds: 500),
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
    RoutePath? popUntilRoutePath,
    void Function()? onPop,
  }) async {
    if (isClearBackStack) {
      await AppRouter.navigateToAndClearStack(
        context: context,
        appRoute: destination,
      );
    } else if (popUntilRoutePath != null) {
      AppRouter.popUntilAndThenNavigate(
        context: context,
        popUntilRoutePath: popUntilRoutePath,
        navigateToRoute: destination,
      );
    } else if (isReplacement) {
      await AppRouter.pushReplacement(
        context: context,
        appRoute: destination,
      );
    } else {
      await AppRouter.navigateTo(
        context: context,
        appRoute: destination,
      );
    }
    onPop?.call();
  }

  void _navigateBack(
    RoutePath? popUntilRoutePath,
    VoidCallback? onComplete,
  ) {
    if (popUntilRoutePath != null) {
      AppRouter.navigateBackUntil(
        context: context,
        routePath: popUntilRoutePath,
        onComplete: onComplete,
      );
    } else {
      AppRouter.navigateBack(
        context: context,
        onComplete: onComplete,
      );
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
        toastType: ToastType.error,
      );
    }
  }
}
