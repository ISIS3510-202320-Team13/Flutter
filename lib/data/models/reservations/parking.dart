import 'package:equatable/equatable.dart';

class Parking extends Equatable {
  // TODO: Add new fields (e.g., location)

  final String id;
  final String? name;

  const Parking({required this.id, this.name});

  static const empty = Parking(id: '');

  bool get isEmpty => this == Parking.empty;
  bool get isNotEmpty => this != Parking.empty;

  @override
  List<Object?> get props => [id, name];
}
