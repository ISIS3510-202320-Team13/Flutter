import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:parkez/data/utils/type_conversions.dart';

class Parking extends Equatable {
  final String id;
  final String? name;
  final double? price;
  final int? carSpotsAvailable;
  final int? motorSpotsAvailable;
  final GeoPoint? coordinates;
  final double? rating;

  const Parking({
    required this.id,
    this.name,
    this.price,
    this.carSpotsAvailable,
    this.motorSpotsAvailable,
    this.coordinates,
    this.rating,
  });

  Parking.fromChambonada(String uid, String this.name, String waitTime,
      String numberSpots, String price, String distance)
      : id = uid,
        price = double.tryParse(price),
        carSpotsAvailable = int.parse(numberSpots),
        motorSpotsAvailable = 0,
        coordinates = null,
        rating = 0;

  Parking.fromJson(String uid, Map<String, dynamic> json)
      : id = uid,
        name = json['name'],
        price = parseDouble(json['price']),
        carSpotsAvailable = parseInt(json['availabilityCars']),
        motorSpotsAvailable = parseInt(json['availabilityMotorcycle']),
        coordinates = json['coordinates'],
        rating = parseDouble(json['rating']);

  Map<String, dynamic> toDocument() {
    final parkingDocument = <String, dynamic>{
      'name': name,
      'price': price,
      'availabilityCars': carSpotsAvailable,
      'availabilityMotorcycle': motorSpotsAvailable,
      'location': coordinates,
      'rating': rating,
    };

    return parkingDocument;
  }

  static const empty = Parking(id: '');
  static const notFound = Parking(id: '', name: 'Parkings not found');

  bool get isEmpty => this == Parking.empty;
  bool get isNotEmpty => this != Parking.empty;

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        carSpotsAvailable,
        motorSpotsAvailable,
        coordinates,
        rating
      ];

  Parking copyWith({
    String? id,
    String? name,
    double? price,
    int? carSpotsAvailable,
    int? motorSpotsAvailable,
    GeoPoint? coordinates,
    double? rating,
  }) {
    return Parking(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      carSpotsAvailable: carSpotsAvailable ?? this.carSpotsAvailable,
      motorSpotsAvailable: motorSpotsAvailable ?? this.motorSpotsAvailable,
      coordinates: coordinates ?? this.coordinates,
      rating: rating ?? this.rating,
    );
  }

  static Parking compareChoiceParking(Parking a, Parking b) {
    if (a.isEmpty) {
      return b;
    } else if (b.isEmpty) {
      return a;
    }

    var taRate = a.rating! + ((-1 * a.price!) / 100);
    var tbRate = b.rating! + ((-1 * b.price!) / 100);

    return taRate > tbRate ? a : b;
  }
}
