import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parkez/data/models/user.dart';
import 'package:parkez/data/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authRepository;
  late final StreamSubscription<User> _userSubscription;

  AuthenticationBloc({
    required AuthenticationRepository authRepository,
  })  : _authRepository = authRepository,
        super(authRepository.currentUser.isNotEmpty
            ? AuthenticationState.authenticated(authRepository.currentUser)
            : const AuthenticationState.unauthenticated()) {
    on<_AuthenticationUserChanged>(_onUserChanged);
    on<AuthenticationSignoutRequested>(_onSignoutRequested);
    _userSubscription = _authRepository.user.listen(
      (user) => add(_AuthenticationUserChanged(user)),
    );
  }

  void _onUserChanged(
      _AuthenticationUserChanged event, Emitter<AuthenticationState> emit) {
    emit(
      event.user.isNotEmpty
          ? AuthenticationState.authenticated(event.user)
          : const AuthenticationState.unauthenticated(),
    );
  }

  void _onSignoutRequested(
      AuthenticationSignoutRequested event, Emitter<AuthenticationState> emit) {
    unawaited(_authRepository.signOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
