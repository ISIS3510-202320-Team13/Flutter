import 'package:equatable/equatable.dart';
import 'package:parkez/data/utils/type_conversions.dart';

class Reservation extends Equatable {
  final String id;
  final double? cost;
  final DateTime? startDatetime;
  final DateTime? endDatetime;
  final String? parkingId;
  final String? status;
  final String? userId;
  final double? timeToReserve;

  const Reservation({
    required this.id,
    this.cost,
    this.startDatetime,
    this.endDatetime,
    this.parkingId,
    this.status,
    this.userId,
    this.timeToReserve,
  });

  Reservation.copyWith({
    String? id,
    double? cost,
    DateTime? startDatetime,
    DateTime? endDatetime,
    String? parkingId,
    String? status,
    String? userId,
    double? timeToReserve,
  })  : id = id ?? "",
        cost = cost ?? 0,
        startDatetime = startDatetime ?? DateTime.now(),
        endDatetime = endDatetime ?? DateTime.now(),
        parkingId = parkingId ?? "",
        status = status ?? "",
        userId = userId ?? "",
        timeToReserve = timeToReserve ?? 0;

  // Model from http://api.parkez.xyz:8082/docs#/Reservations/post_reservation_reservations_post
  Reservation.fromJson(String uid, Map<String, dynamic> values)
      : id = uid,
        cost = parseDouble(values['cost']),
        startDatetime = parseDateTime(values['entry_time']),
        endDatetime = parseDateTime(values['exit_time']),
        parkingId = values['parking'],
        status = values['status'],
        userId = values['user'],
        timeToReserve = parseDouble(values['time_to_reserve'] ?? "");

  Map<String, dynamic> toDocument() {
    final reservationDocument = <String, dynamic>{
      'cost': cost,
      'entry_time': formatDateTime(startDatetime),
      'exit_time': formatDateTime(endDatetime),
      'parking': parkingId,
      'status': status,
      'user': userId,
      'time_to_reserve': timeToReserve,
    };
    return reservationDocument;
  }

  static const empty = Reservation(id: '');

  bool get isEmpty => this == Reservation.empty;
  bool get isNotEmpty => this != Reservation.empty;

  @override
  List<Object?> get props => [
        id,
        cost,
        startDatetime,
        endDatetime,
        parkingId,
        status,
        userId,
        timeToReserve
      ];

  Reservation copyWith({required timeToReserve, required startDatetime}) {
    return Reservation(
      id: id,
      cost: timeToReserve * 100,
      startDatetime: startDatetime,
      endDatetime: startDatetime.add(Duration(minutes: timeToReserve.toInt())),
      parkingId: parkingId,
      status: status,
      userId: userId,
      timeToReserve: timeToReserve,
    );
  }
}
