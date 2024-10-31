import 'package:domain/exceptions/location_exceptions.dart';

class PermissionDeniedLocationException extends LocationException {
  PermissionDeniedLocationException(super.message);
}