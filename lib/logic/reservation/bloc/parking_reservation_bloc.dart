import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:parkez/data/repositories/parking_reservation_repository.dart';

part 'parking_reservation_event.dart';
part 'parking_reservation_state.dart';

class ParkingReservationBloc
    extends Bloc<ParkingReservationEvent, ParkingReservationState> {
  final ParkingReservationRepository _parkingReservationRepository;

  ParkingReservationBloc({
    required ParkingReservationRepository parkingReservationRepository,
  })  : _parkingReservationRepository = parkingReservationRepository,
        super(const ParkingReservationState.parkingDetails()) {
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
    _parkingReservationRepository.selectParking(parking: event.parking);
    emit(ParkingReservationState.reservationDetails(event.parking));
  }

  void _onReservationDetailsSelected(
    ParkingReservationReservationDetailsSelected event,
    Emitter<ParkingReservationState> emit,
  ) {
    _parkingReservationRepository.selectReservation(
        reservation: event.reservation);
    emit(ParkingReservationState.paymentDetails(event.reservation));
  }

  void _onPaymentDetailsSelected(
    ParkingReservationPaymentDetailsSelected event,
    Emitter<ParkingReservationState> emit,
  ) {
    _parkingReservationRepository.selectPayment(payment: event.payment);
    emit(ParkingReservationState.checkout(event.payment));
  }

  void _onCheckoutSubmitted(
    ParkingReservationCheckoutSubmitted event,
    Emitter<ParkingReservationState> emit,
  ) async {
    await _parkingReservationRepository.createParkingReservation();
    emit(const ParkingReservationState.confirmation());
  }

  void _onCancelRequested(
    ParkingReservationCancelRequested event,
    Emitter<ParkingReservationState> emit,
  ) async {
    await _parkingReservationRepository.cancelReservation();
    emit(const ParkingReservationState.cancelled());
  }
}
