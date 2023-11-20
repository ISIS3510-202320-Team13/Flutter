import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_check_event.dart';
part 'connectivity_check_state.dart';

class ConnectivityCheckBloc
    extends Bloc<ConnectivityCheckEvent, ConnectivityCheckState> {
  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityCheckBloc() : super(const ConnectivityCheckState.unknown()) {
    on<ConnectivityCheckStarted>(_onStarted);
    on<_ConnectivityCheckStatusChanged>(_onConnectivityChanged);
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((status) => add(_ConnectivityCheckStatusChanged(status)));
  }

  ConnectivityCheckState _mapConnectivityToState(ConnectivityResult status) {
    switch (status) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        return const ConnectivityCheckState.connected();
      case ConnectivityResult.none:
      default:
        return const ConnectivityCheckState.disconnected();
    }
  }

  void _onStarted(ConnectivityCheckStarted event,
      Emitter<ConnectivityCheckState> emit) async {
    final status = await Connectivity().checkConnectivity();
    emit(_mapConnectivityToState(status));
  }

  void _onConnectivityChanged(_ConnectivityCheckStatusChanged event,
      Emitter<ConnectivityCheckState> emit) {
    emit(_mapConnectivityToState(event.connectionStatus));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
