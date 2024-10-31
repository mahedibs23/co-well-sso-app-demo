import 'package:domain/exceptions/authentication_exception.dart';

class EmailAlreadyExistException extends AuthenticationException {
  EmailAlreadyExistException(String message) : super(message);
}
