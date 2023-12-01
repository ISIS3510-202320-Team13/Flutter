part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

final class LocationStarted extends LocationEvent {
  const LocationStarted();
}

final class LocationUpdated extends LocationEvent {
  final Position position;

  const LocationUpdated(this.position);

  @override
  List<Object> get props => [position];
}
