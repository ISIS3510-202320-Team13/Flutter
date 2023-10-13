import 'package:formz/formz.dart';

enum DateTimeReservationValidationError { empty, wrongFormat, invalidDate }

class DateTimeReservation
    extends FormzInput<String, DateTimeReservationValidationError> {
  const DateTimeReservation.pure() : super.pure('');
  const DateTimeReservation.dirty([String value = '']) : super.dirty(value);

  @override
  DateTimeReservationValidationError? validator(String value) {
    if (value.isEmpty) return DateTimeReservationValidationError.empty;
    if (DateTime.tryParse(value) == null) {
      return DateTimeReservationValidationError.wrongFormat;
    }
    if (DateTime.tryParse(value)!.isBefore(DateTime.now())) {
      return DateTimeReservationValidationError.invalidDate;
    }

    return null;
  }
}
