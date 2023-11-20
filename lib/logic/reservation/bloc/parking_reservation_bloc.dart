import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:parkez/logic/reservation/reservation_controller.dart';

part 'parking_reservation_event.dart';
part 'parking_reservation_state.dart';

class ParkingReservationBloc
    extends Bloc<ParkingReservationEvent, ParkingReservationState> {
  final ReservationController _reservationController;
  final reservationTrace =
      FirebasePerformance.instance.newTrace('_reservation_time');

  ParkingReservationBloc({
    required ReservationController reservationController,
  })  : _reservationController = reservationController,
        super(const ParkingReservationState.parkingDetails()) {
    reservationTrace.start();
    on<ParkingReservationParkingSelected>(_onParkingSelected);
    on<ParkingReservationReservationDetailsSelected>(
        _onReservationDetailsSelected);
    on<ParkingReservationPaymentDetailsSelected>(_onPaymentDetailsSelected);
    on<ParkingReservationCheckoutSubmitted>(_onCheckoutSubmitted);
    on<ParkingReservationCancelRequested>(_onCancelRequested);
  }

  void _onParkingSelected(
    ParkingReservationParkingSelected event,
    Emitter<ParkingReservationState> emit,
  ) {
    _reservationController.setParkingId(event.parking.id);
    emit(ParkingReservationState.reservationDetails(event.parking));
  }

  void _onReservationDetailsSelected(
    ParkingReservationReservationDetailsSelected event,
    Emitter<ParkingReservationState> emit,
  ) {
    _reservationController.selectReservation(reservation: event.reservation);
    emit(ParkingReservationState.paymentDetails(event.reservation));
  }

  void _onPaymentDetailsSelected(
    ParkingReservationPaymentDetailsSelected event,
    Emitter<ParkingReservationState> emit,
  ) {
    // TODO: Not implemented
    // _reservationController.selectPayment(payment: event.payment);
    emit(ParkingReservationState.checkout(event.payment));
  }

  void _onCheckoutSubmitted(
    ParkingReservationCheckoutSubmitted event,
    Emitter<ParkingReservationState> emit,
  ) async {
    Reservation newRes = await _reservationController.reserveParkingSpot();
    emit(ParkingReservationState.confirmation(newRes));
    reservationTrace.putAttribute("status", "confirmed");
    await reservationTrace.stop();
  }

  void _onCancelRequested(
    ParkingReservationCancelRequested event,
    Emitter<ParkingReservationState> emit,
  ) async {
    _reservationController.cancelReservation();
    emit(const ParkingReservationState.cancelled());
    reservationTrace.putAttribute("status", "cancelled");
    await reservationTrace.stop();
  }
}
