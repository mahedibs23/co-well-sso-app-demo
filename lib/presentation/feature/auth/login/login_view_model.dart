import 'package:domain/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';
import 'package:hello_flutter/presentation/common/extension/context_ext.dart';
import 'package:hello_flutter/presentation/feature/auth/login/route/login_argument.dart';
import 'package:hello_flutter/presentation/feature/auth/validator/email_validator.dart';
import 'package:hello_flutter/presentation/feature/auth/validator/password_validator.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_argument.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_route.dart';
import 'package:hello_flutter/presentation/localization/text_id.dart';
import 'package:hello_flutter/presentation/localization/ui_text.dart';

class LoginViewModel extends BaseViewModel<LoginArgument> {
  final AuthRepository authRepository;

  LoginViewModel({required this.authRepository});

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  String? getEmailError(BuildContext context) {
    if (emailTextEditingController.selection.baseOffset == -1) return null;
    EmailValidationError? emailError =
        EmailValidator.getValidationError(emailTextEditingController.text);
    if (emailError == null) return null;

    if (emailError == EmailValidationError.empty) {
      return context.localizations.login__login_form__email_field_empty;
    }
    if (emailError == EmailValidationError.invalid) {
      return context
          .localizations.login__login_form__email_field_invalid_email_text;
    }
    return null;
  }

  String? getPasswordError(BuildContext context) {
    if (passwordTextEditingController.selection.baseOffset == -1) return null;
    PasswordValidationError? passwordError =
        PasswordValidator.getValidationError(
            passwordTextEditingController.text);
    if (passwordError == null) return null;

    if (passwordError == PasswordValidationError.empty) {
      return context.localizations.login__login_form__password_field_empty;
    }
    if (passwordError == PasswordValidationError.containsSpace) {
      return context.localizations
          .login__login_form__password_field_invalid_password_must_not_contain_any_whitespace;
    }
    if (passwordError == PasswordValidationError.noDigit) {
      return context.localizations
          .login__login_form__password_field_invalid_password_must_contain_atleast_one_digit;
    }
    if (passwordError == PasswordValidationError.noUppercase) {
      return context.localizations
          .login__login_form__password_field_invalid_password_must_contain_atleast_one_uppercase_letter;
    }
    if (passwordError == PasswordValidationError.noLowercase) {
      return context.localizations
          .login__login_form__password_field_invalid_password_must_contain_atleast_one_lowercase_letter;
    }
    if (passwordError == PasswordValidationError.noSpecialChar) {
      return context.localizations
          .login__login_form__password_field_invalid_password_must_contain_atleast_one_special_character;
    }
    if (passwordError == PasswordValidationError.tooShort) {
      return context.localizations
          .login__login_form__password_field_invalid_password_must_be_atleast_eight_char_long;
    }
    return null;
  }

  Future<void> onLoginButtonClicked() async {
    if (!EmailValidator.isValid(emailTextEditingController.text) ||
        !PasswordValidator.isValid(passwordTextEditingController.text)) {
      showToast(
        uiText: DynamicUiText(
          textId: PleaseFillUpAllTheRequiredFieldsTextId(),
          fallbackText: "Please fill up all fields",
        ),
      );
      return;
    }

    final userSession = await loadData(authRepository.login(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    ));

    navigateToScreen(
      destination: HomeRoute(arguments: HomeArgument(userId: '123')),
      isClearBackStack: true,
    );
  }

  @override
  void onDispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.onDispose();
  }

  onForgotPasswordButtonClicked() {}

  onForgotPasswordButtonLongPressed() {}
}
