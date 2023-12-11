part of 'connectivity_check_bloc.dart';

sealed class ConnectivityCheckEvent extends Equatable {
  const ConnectivityCheckEvent();

  @override
  List<Object> get props => [];
}

final class ConnectivityCheckStarted extends ConnectivityCheckEvent {
  const ConnectivityCheckStarted();
}

final class _ConnectivityCheckStatusChanged extends ConnectivityCheckEvent {
  final ConnectivityResult connectionStatus;

  const _ConnectivityCheckStatusChanged(this.connectionStatus);
}
