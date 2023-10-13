part of 'signin_cubit.dart';

final class SigninState extends Equatable {
  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final String? errorMessage;
  final bool isValid;

  const SigninState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.errorMessage,
    this.isValid = false,
  });

  SigninState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    String? errorMessage,
    bool? isValid,
  }) {
    return SigninState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, email, password];
}
