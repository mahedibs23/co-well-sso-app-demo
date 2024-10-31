import 'package:domain/exceptions/base_exception.dart';

class AuthenticationException extends BaseException {
  AuthenticationException(String message) : super(message);
}
