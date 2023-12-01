part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoadInProgress extends LocationState {}

final class LocationLoadSuccess extends LocationState {
  final Position position;

  const LocationLoadSuccess(this.position);

  @override
  List<Object> get props => [position];
}
