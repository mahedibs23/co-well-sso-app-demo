import 'package:domain/repository/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';
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

  final ValueNotifier<String?> _email = ValueNotifier(null);

  ValueListenable<String?> get email => _email;

  final ValueNotifier<String?> _password = ValueNotifier(null);

  ValueListenable<String?> get password => _password;

  EmailValidationError? get emailValidationError =>
      EmailValidator.getValidationError(email.value);

  PasswordValidationError? get passwordValidationError =>
      PasswordValidator.getValidationError(password.value);

  void onEmailChanged(String value) {
    _email.value = value;
  }

  void onPasswordChanged(String value) {
    _password.value = value;
  }

  Future<void> onLoginButtonClicked() async {
    if (email.value == null || password.value == null) {
      showToast(
        uiText: DynamicUiText(
          textId: PleaseFillUpAllTheRequiredFieldsTextId(),
          fallbackText: "Please fill up all fields",
        ),
      );
      return;
    }

    if (!EmailValidator.isValid(email.value) ||
        !PasswordValidator.isValid(password.value)) {
      showToast(
        uiText: DynamicUiText(
          textId: PleaseFillUpAllTheRequiredFieldsTextId(),
          fallbackText: "Please fill up all fields",
        ),
      );
      return;
    }

    await loadData(authRepository.login(
      email: email.value!,
      password: password.value!,
    ));

    navigateToScreen(
      destination: HomeRoute(arguments: HomeArgument(userId: '123')),
      isClearBackStack: true,
    );
  }

  onForgotPasswordButtonClicked() {}

  onForgotPasswordButtonLongPressed() {}
}
