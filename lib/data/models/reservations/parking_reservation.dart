import 'package:equatable/equatable.dart';
import 'package:parkez/data/models/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';

class ParkingReservation extends Equatable {
  // TODO: Add new fields

  final String id;
  final Parking? parking;
  final Reservation? reservation;
  final Payment? payment;

  const ParkingReservation(
      {required this.id, this.parking, this.reservation, this.payment});

  static const empty = ParkingReservation(id: '');

  bool get isEmpty => this == ParkingReservation.empty;
  bool get isNotEmpty => this != ParkingReservation.empty;

  @override
  List<Object?> get props => [id, parking, reservation, payment];
}
