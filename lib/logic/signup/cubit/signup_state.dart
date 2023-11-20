part of 'signup_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignupState extends Equatable {
  final Email email;
  final Username name;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const SignupState({
    this.email = const Email.pure(),
    this.name = const Username.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [email, name, password, confirmedPassword, status, isValid, errorMessage];

  SignupState copyWith({
    Email? email,
    Username? name,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return SignupState(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
