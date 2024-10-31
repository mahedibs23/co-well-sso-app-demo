import 'package:domain/exceptions/location_exceptions.dart';

class CurrentCountryNotFoundException extends LocationException {
  CurrentCountryNotFoundException(super.message);
}
