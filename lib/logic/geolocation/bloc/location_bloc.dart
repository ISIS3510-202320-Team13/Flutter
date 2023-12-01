import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  late final StreamSubscription _locationSubscription;

  LocationBloc() : super(LocationInitial()) {
    on<LocationStarted>(_onStarted);
    on<LocationUpdated>(_onLocationUpdated);
    _locationSubscription = Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.medium))
        .listen(
      (position) => add(LocationUpdated(position)),
    );
  }

  void _onStarted(LocationStarted event, Emitter<LocationState> emit) async {
    emit(LocationLoadInProgress());
    final position = await Geolocator.getCurrentPosition();
    emit(LocationLoadSuccess(position));
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    emit(LocationLoadSuccess(event.position));
    print("Location updated: ${event.position}");
  }

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }
}
