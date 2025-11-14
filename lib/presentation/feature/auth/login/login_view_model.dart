import 'package:domain/repository/auth_repository.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:hello_flutter/presentation/base/base_viewmodel.dart';
import 'package:hello_flutter/presentation/feature/auth/login/route/login_argument.dart';
import 'package:hello_flutter/presentation/feature/auth/validator/email_validator.dart';
import 'package:hello_flutter/presentation/feature/auth/validator/password_validator.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_argument.dart';
import 'package:hello_flutter/presentation/feature/home/route/home_route.dart';
import 'package:hello_flutter/presentation/localization/text_id.dart';
import 'package:hello_flutter/presentation/localization/ui_text.dart';
// 🔽 Added for proper Keycloak login
import 'package:flutter_appauth/flutter_appauth.dart';

class LoginViewModel extends BaseViewModel<LoginArgument> {
  final AuthRepository authRepository;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  LoginViewModel({required this.authRepository});

  final ValueNotifier<String?> _email = ValueNotifier(null);
  ValueListenable<String?> get email => _email;

  final ValueNotifier<String?> _password = ValueNotifier(null);
  ValueListenable<String?> get password => _password;

  EmailValidationError? get emailValidationError =>
      EmailValidator.getValidationError(email.value);

  PasswordValidationError? get passwordValidationError =>
      PasswordValidator.getValidationError(password.value);

  void onEmailChanged(String value) => _email.value = value;
  void onPasswordChanged(String value) => _password.value = value;

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


  static const String _pcLocalIp = "172.16.214.125";
  static const String _realm = "master";
  static const String _clientId = "mobile_app_client";
  static const String _redirectUri =
      "com.mahfuznow.flutterapp.app://oauth2redirect";

  Future<void> onLoginWithSsoButtonClicked() async {
    const authorizationEndpoint =
        "http://$_pcLocalIp:8080/realms/$_realm/protocol/openid-connect/auth";
    const tokenEndpoint =
        "http://$_pcLocalIp:8080/realms/$_realm/protocol/openid-connect/token";
    const logoutEndpoint =
        "http://$_pcLocalIp:8080/realms/$_realm/protocol/openid-connect/logout";

    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          issuer: "http://172.16.214.125:8080/realms/master",
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint,
            endSessionEndpoint: logoutEndpoint,
          ),
          scopes: ['openid', 'profile', 'email'],
          promptValues: ['login'],
          allowInsecureConnections: true,
        ),
      );
    } catch (e) {
      print('Auth error: $e');
      showToast(uiText: FixedUiText(text: "SSO Login failed: ${e.toString()}"));
    }

  }


  void onRegisterButtonClicked() {}
}
