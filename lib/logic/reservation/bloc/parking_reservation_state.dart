part of 'parking_reservation_bloc.dart';

enum ReservationStep {
  parking,
  reservation,
  payment,
  checkout,
  confirmation,
  cancelled
}

class ParkingReservationState extends Equatable {
  final ReservationStep step;
  final Parking parking;
  final Reservation reservation;
  final Payment payment;

  const ParkingReservationState._({
    this.step = ReservationStep.parking,
    this.parking = Parking.empty,
    this.reservation = Reservation.empty,
    this.payment = Payment.empty,
  });

  const ParkingReservationState.parkingDetails()
      : this._(step: ReservationStep.parking);

  const ParkingReservationState.reservationDetails(Parking parking)
      : this._(step: ReservationStep.reservation, parking: parking);

  const ParkingReservationState.paymentDetails(Reservation reservation)
      : this._(step: ReservationStep.payment, reservation: reservation);

  const ParkingReservationState.checkout(Payment payment)
      : this._(step: ReservationStep.checkout, payment: payment);

  const ParkingReservationState.confirmation()
      : this._(step: ReservationStep.confirmation);

  const ParkingReservationState.cancelled()
      : this._(step: ReservationStep.cancelled);

  @override
  List<Object> get props => [step, parking, reservation, payment];
}
