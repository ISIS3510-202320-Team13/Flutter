part of 'parking_reservation_bloc.dart';

sealed class ParkingReservationEvent extends Equatable {
  const ParkingReservationEvent();

  @override
  List<Object> get props => [];
}

final class ParkingReservationParkingSelected extends ParkingReservationEvent {
  final Parking parking;

  const ParkingReservationParkingSelected(this.parking);

  @override
  List<Object> get props => [parking];
}

final class ParkingReservationReservationDetailsSelected
    extends ParkingReservationEvent {
  final Reservation reservation;

  const ParkingReservationReservationDetailsSelected(this.reservation);

  @override
  List<Object> get props => [reservation];
}

final class ParkingReservationPaymentDetailsSelected
    extends ParkingReservationEvent {
  final Payment payment;

  const ParkingReservationPaymentDetailsSelected(this.payment);

  @override
  List<Object> get props => [payment];
}

final class ParkingReservationCheckoutSubmitted
    extends ParkingReservationEvent {}

final class ParkingReservationCancelRequested extends ParkingReservationEvent {}
