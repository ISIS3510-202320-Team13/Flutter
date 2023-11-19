import 'package:equatable/equatable.dart';

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

  static DateTime parseDateTime(String dateString) {
    int extraHours = 0;
    if (dateString.contains('PM')) {
      extraHours = 12;
    }
    dateString = dateString.replaceAll(' AM', '');
    dateString = dateString.replaceAll(' PM', '');

    DateTime newDatetime = DateTime.parse(dateString);
    newDatetime = newDatetime.add(Duration(hours: extraHours));

    return newDatetime;
  }

  static double? parseNumber(dynamic? numberVal) {
    if (numberVal is int) {
      return numberVal.toDouble();
    } else if (numberVal is double) {
      return numberVal;
    } else if (numberVal is String) {
      return double.parse(numberVal);
    } else {
      return null;
    }
  }

  // Model from http://api.parkez.xyz:8082/docs#/Reservations/post_reservation_reservations_post
  Reservation.fromJson(String uid, Map<String, dynamic> values)
      : id = uid,
        cost = parseNumber(values['cost']),
        startDatetime = parseDateTime(values['entry_time']),
        endDatetime = parseDateTime(values['exit_time']),
        parkingId = values['parking'],
        status = values['status'],
        userId = values['user'],
        timeToReserve = parseNumber(values['time_to_reserve'] ?? "");

  Map<String, dynamic> toDocument() {
    final reservationDocument = <String, dynamic>{
      'cost': cost,
      'entry_time': startDatetime.toString(),
      'exit_time': endDatetime.toString(),
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
}
