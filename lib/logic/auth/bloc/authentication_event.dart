part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationSignoutRequested extends AuthenticationEvent {
  const AuthenticationSignoutRequested();
}

final class _AuthenticationUserChanged extends AuthenticationEvent {
  final User user;

  const _AuthenticationUserChanged(this.user);
}
