import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkez/data/models/parking.dart';

class ParkingRepository {
  final FirebaseFirestore _db;
  final parkingCollPath = "parkings";

  ParkingRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  Future<List<Parking>> getParkings() async {
    return await _db.collection(parkingCollPath).get().then((value) =>
        value.docs.map((e) => Parking.fromJson(e.id, e.data())).toList());
  }

  Future<Parking> addParking(Parking parking) async {
    Map<String, dynamic> parkingDoc = parking.toDocument();
    return await _db
        .collection(parkingCollPath)
        .add(parkingDoc)
        .then((DocumentReference doc) => Parking.fromJson(doc.id, parkingDoc));
  }

  Future<Parking> updateParking(Parking parking) async {
    Map<String, dynamic> parkingDoc = parking.toDocument();
    return await _db
        .collection(parkingCollPath)
        .doc(parking.id)
        .update(parkingDoc)
        .then((_) => Parking.fromJson(parking.id, parkingDoc));
  }

  Future<Parking> updateParkingAvailability(
      Parking parking, int deltaSpots) async {
    Map<String, dynamic> parkingDoc = parking.toDocument();
    parkingDoc['carSpotsAvailable'] = parking.carSpotsAvailable! + deltaSpots;
    return await _db
        .collection(parkingCollPath)
        .doc(parking.id)
        .update(parkingDoc)
        .then((_) => Parking.fromJson(parking.id, parkingDoc));
  }
}
