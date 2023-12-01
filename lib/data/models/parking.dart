import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:parkez/data/utils/type_conversions.dart';

class Parking extends Equatable {
  // TODO: Add new fields (e.g., address)

  final String id;
  final String? name;
  final double? price;
  final int? carSpotsAvailable;
  final int? motorSpotsAvailable;
  final GeoPoint? location;
  final double? rating;

  const Parking({
    required this.id,
    this.name,
    this.price,
    this.carSpotsAvailable,
    this.motorSpotsAvailable,
    this.location,
    this.rating,
  });

  Parking.fromChambonada(String uid, String this.name, String waitTime,
      String numberSpots, String price, String distance)
      : id = uid,
        price = double.tryParse(price),
        carSpotsAvailable = int.parse(numberSpots),
        motorSpotsAvailable = 0,
        location = null,
        rating = 0;

  Parking.fromJson(String uid, Map<String, dynamic> json)
      : id = uid,
        name = json['name'],
        price = parseDouble(json['price']),
        carSpotsAvailable = parseInt(json['carSpotsAvailable']),
        motorSpotsAvailable = parseInt(json['motorSpotsAvailable']),
        location = json['location'],
        rating = parseDouble(json['rating']);

  Map<String, dynamic> toDocument() {
    final parkingDocument = <String, dynamic>{
      'name': name,
      'price': price,
      'carSpotsAvailable': carSpotsAvailable,
      'motorSpotsAvailable': motorSpotsAvailable,
      'location': location,
      'rating': rating,
    };

    return parkingDocument;
  }

  static const empty = Parking(id: '');

  bool get isEmpty => this == Parking.empty;
  bool get isNotEmpty => this != Parking.empty;

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        carSpotsAvailable,
        motorSpotsAvailable,
        location,
        rating
      ];
}
