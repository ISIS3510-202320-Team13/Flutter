import 'package:formz/formz.dart';

enum UsernameValidatorError { empty }

class Username extends FormzInput<String, UsernameValidatorError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidatorError? validator(String value) {
    if (value.isEmpty) return UsernameValidatorError.empty;
    return null;
  }
}
