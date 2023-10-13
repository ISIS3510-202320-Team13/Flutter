import 'package:formz/formz.dart';

enum DurationValidationError { empty, notNumber, notPositive }

class DurationReservation extends FormzInput<String, DurationValidationError> {
  const DurationReservation.pure() : super.pure('');
  const DurationReservation.dirty([String value = '']) : super.dirty(value);

  @override
  DurationValidationError? validator(String value) {
    if (value.isEmpty) return DurationValidationError.empty;
    if (int.tryParse(value) == null) {
      return DurationValidationError.notNumber;
    }
    if (int.tryParse(value)! <= 0) {
      return DurationValidationError.notPositive;
    }

    return null;
  }
}
