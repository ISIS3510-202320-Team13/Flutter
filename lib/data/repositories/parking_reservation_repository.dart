import 'dart:async';

import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/parking_reservation.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:uuid/uuid.dart';

class ParkingReservationRepository {
  Parking? _parking;
  Reservation? _reservation;
  Payment? _payment;

  void selectParking({
    required Parking parking,
  }) {
    // TODO: Actual selecting. This is a mock select
    _parking = parking;
  }

  void selectReservation({
    required Reservation reservation,
  }) {
    // TODO: Actual selecting. This is a mock select
    _reservation = reservation;
  }

  void selectPayment({
    required Payment payment,
  }) {
    // TODO: Actual selecting. This is a mock select
    _payment = payment;
  }

  Future<ParkingReservation> createParkingReservation() {
    if (_parking == null || _reservation == null || _payment == null) {
      throw Exception(
          'Cannot create parking reservation: missing required information');
    }

    final parkingReservation = ParkingReservation(
      id: const Uuid().v4(),
      parking: _parking,
      reservation: _reservation,
      payment: _payment,
    );

    // TODO: This should really wait for firestore to save everything
    return Future.delayed(const Duration(seconds: 1), () => parkingReservation);
  }

  Future<void> cancelReservation() {
    _parking = null;
    _reservation = null;
    _payment = null;
    return Future.delayed(const Duration(seconds: 1));
  }
}
