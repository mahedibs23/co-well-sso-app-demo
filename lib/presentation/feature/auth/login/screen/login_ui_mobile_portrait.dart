import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_ui_state.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';
import 'package:hello_flutter/presentation/common/widget/primary_button.dart';
import 'package:hello_flutter/presentation/feature/auth/login/login_view_model.dart';
import 'package:hello_flutter/presentation/values/dimens.dart';

class LoginUiMobilePortrait extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginUiMobilePortrait({required this.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => LoginUiMobilePortraitState();
}

class LoginUiMobilePortraitState extends BaseUiState<LoginUiMobilePortrait> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F7),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.dimen_24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 5),
              _lockIcon(context),
              SizedBox(height: Dimens.dimen_32),
              _welcomeTitle(context),
              SizedBox(height: Dimens.dimen_40),
              _ssoButton(context),
              SizedBox(height: Dimens.dimen_32),
              _forgotPasswordButton(context),
              SizedBox(height: Dimens.dimen_16),
              _registerRow(context),
              const Spacer(flex: 7),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lockIcon(BuildContext context) {
    return Container(
      width: Dimens.dimen_60,
      height: Dimens.dimen_60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(Dimens.dimen_16),
      ),
      child: Icon(
        Icons.lock_outline,
        color: Theme.of(context).colorScheme.onPrimary,
        size: Dimens.dimen_30,
      ),
    );
  }

  Widget _welcomeTitle(BuildContext context) {
    return Text(
      context.localizations.login_new__welcome_title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
    );
  }

  Widget _ssoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        label: context.localizations.login_new__login_with_sso,
        onPressed: () => widget.viewModel.onLoginWithSsoButtonClicked(),
        minWidth: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Dimens.dimen_16),
        borderRadius: Dimens.dimen_12,
      ),
    );
  }

  Widget _forgotPasswordButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => widget.viewModel.onForgotPasswordButtonClicked(),
      child: Text(
        context.localizations.login_new__forgot_password_q,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
      ),
      onLongPress: () => widget.viewModel.onForgotPasswordButtonLongPressed(),
    );
  }

  Widget _registerRow(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: Dimens.dimen_6,
      children: [
        Text(
          context.localizations.login_new__new_here,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {},
          child: Text(
            context.localizations.login_new__register,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  decorationColor: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }
}
