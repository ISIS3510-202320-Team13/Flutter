part of 'connectivity_check_bloc.dart';

enum ConnectivityStatus { unknown, connected, disconnected }

class ConnectivityCheckState extends Equatable {
  final ConnectivityStatus status;

  const ConnectivityCheckState._({this.status = ConnectivityStatus.unknown});

  const ConnectivityCheckState.unknown() : this._();

  const ConnectivityCheckState.connected()
      : this._(status: ConnectivityStatus.connected);

  const ConnectivityCheckState.disconnected()
      : this._(status: ConnectivityStatus.disconnected);

  @override
  List<Object> get props => [status];
}
