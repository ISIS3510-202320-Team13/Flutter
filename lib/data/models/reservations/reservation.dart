import 'package:equatable/equatable.dart';

class Reservation extends Equatable {
  // TODO: Add new fields (e.g., location)

  final String id;
  final DateTime? startDatetime;
  final DateTime? endDatetime;

  const Reservation({required this.id, this.startDatetime, this.endDatetime});

  static const empty = Reservation(id: '');

  bool get isEmpty => this == Reservation.empty;
  bool get isNotEmpty => this != Reservation.empty;

  @override
  List<Object?> get props => [id, startDatetime, endDatetime];
}
