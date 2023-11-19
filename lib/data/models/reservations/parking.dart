import 'package:equatable/equatable.dart';

class Parking extends Equatable {
  // TODO: Add new fields (e.g., address)

  final String id;
  final String? name;
  final double? price;
  final double? distance;
  final int? spotsAvailable;

  const Parking(
      {required this.id,
      this.name,
      this.price,
      this.distance,
      this.spotsAvailable});

  Parking.fromChambonada(String uid, String this.name, String waitTime,
      String numberSpots, String price, String distance)
      : id = uid,
        price = double.tryParse(price),
        distance = double.tryParse(distance),
        spotsAvailable = int.parse(numberSpots);

  static const empty = Parking(id: '');

  bool get isEmpty => this == Parking.empty;
  bool get isNotEmpty => this != Parking.empty;

  @override
  List<Object?> get props => [id, name, price, distance, spotsAvailable];
}
