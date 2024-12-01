import 'package:hello_flutter/presentation/feature/auth/validator/password_validator.dart';
import 'package:hello_flutter/presentation/localization/generated/app_localizations.dart';

extension PasswordValidationErrorExt on PasswordValidationError {
  String getLocalizedMessage(AppLocalizations localizations) {
    switch (this) {
      case PasswordValidationError.empty:
        return localizations.login__login_form__password_field_empty;
      case PasswordValidationError.containsSpace:
        return localizations
            .login__login_form__password_field_invalid_password_must_not_contain_any_whitespace;
      case PasswordValidationError.noDigit:
        return localizations
            .login__login_form__password_field_invalid_password_must_contain_atleast_one_digit;
      case PasswordValidationError.noUppercase:
        return localizations
            .login__login_form__password_field_invalid_password_must_contain_atleast_one_uppercase_letter;
      case PasswordValidationError.noLowercase:
        return localizations
            .login__login_form__password_field_invalid_password_must_contain_atleast_one_lowercase_letter;
      case PasswordValidationError.noSpecialChar:
        return localizations
            .login__login_form__password_field_invalid_password_must_contain_atleast_one_special_character;
      case PasswordValidationError.tooShort:
        return localizations
            .login__login_form__password_field_invalid_password_must_be_atleast_eight_char_long;
    }
  }
}
