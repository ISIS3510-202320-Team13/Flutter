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

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
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
