import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationerror { invalid }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationerror> {
  final String password;

  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmedPasswordValidationerror? validator(String? value) {
    return password == value ? null : ConfirmedPasswordValidationerror.invalid;
  }
}
