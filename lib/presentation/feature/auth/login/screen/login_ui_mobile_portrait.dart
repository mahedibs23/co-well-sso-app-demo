import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_ui_state.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';
import 'package:hello_flutter/presentation/common/widget/overflow_scroll_view.dart';
import 'package:hello_flutter/presentation/common/widget/primary_button.dart';
import 'package:hello_flutter/presentation/feature/auth/login/login_view_model.dart';
import 'package:hello_flutter/presentation/feature/auth/login/widgets/login_email_text_field.dart';
import 'package:hello_flutter/presentation/feature/auth/login/widgets/login_password_text_field.dart';
import 'package:hello_flutter/presentation/localization/extension/email_validation_error_ext.dart';
import 'package:hello_flutter/presentation/localization/extension/password_validation_error_ext.dart';
import 'package:hello_flutter/presentation/values/app_assets.dart';
import 'package:hello_flutter/presentation/values/dimens.dart';

class LoginUiMobilePortrait extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginUiMobilePortrait({required this.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => LoginUiMobilePortraitState();
}

class LoginUiMobilePortraitState extends BaseUiState<LoginUiMobilePortrait> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: widget.viewModel.email.value,
    );
    passwordController = TextEditingController(
      text: widget.viewModel.password.value,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.login__title_text),
      ),
      body: overflowScrollView(
        child: loginForm(context),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.dimen_40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          logoView(context),
          SizedBox(height: Dimens.dimen_40),
          emailAndPasswordFields(context),
          SizedBox(height: Dimens.dimen_20),
          loginButton(context),
          forgotPasswordButton(context),
          SizedBox(height: Dimens.dimen_100),
        ],
      ),
    );
  }

  Widget logoView(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.appLogo,
          width: Dimens.dimen_100,
          height: Dimens.dimen_100,
        ),
        SizedBox(height: Dimens.dimen_10),
        Text(
          context.localizations.app_name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        )
      ],
    );
  }

  Widget emailAndPasswordFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        emailField(context),
        SizedBox(height: Dimens.dimen_10),
        passwordField(context),
      ],
    );
  }

  Widget emailField(BuildContext context) {
    return valueListenableBuilder(
      listenable: widget.viewModel.email,
      builder: (context, value) => LoginEmailTextField(
        textEditingController: emailController,
        onChanged: widget.viewModel.onEmailChanged,
        errorText: widget.viewModel.emailValidationError?.getLocalizedMessage(
          context.localizations,
        ),
      ),
    );
  }

  Widget passwordField(BuildContext context) {
    return valueListenableBuilder(
      listenable: widget.viewModel.password,
      builder: (context, value) => LoginPasswordTextField(
        textEditingController: passwordController,
        onChanged: widget.viewModel.onPasswordChanged,
        errorText:
            widget.viewModel.passwordValidationError?.getLocalizedMessage(
          context.localizations,
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return PrimaryButton(
      label: context.localizations.login__login_btn_text,
      onPressed: () => widget.viewModel.onLoginButtonClicked(),
    );
  }

  Widget forgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () => widget.viewModel.onForgotPasswordButtonClicked(),
      child: Text(
        context.localizations.login__forgot_password_text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      onLongPress: () => widget.viewModel.onForgotPasswordButtonLongPressed(),
    );
  }
}
