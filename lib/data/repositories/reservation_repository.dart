import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';

class ReservationRepository {
  final FirebaseFirestore _db;
  final resCollPath = "reservations";

  ReservationRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  Future<List<Reservation>> getReservations() async {
    return await _db.collection(resCollPath).get().then((value) =>
        value.docs.map((e) => Reservation.fromJson(e.id, e.data())).toList());
  }

  Future<Reservation> addReservation(Reservation res) async {
    Map<String, dynamic> resDoc = res.toDocument();
    return await _db
        .collection(resCollPath)
        .add(resDoc)
        .then((DocumentReference doc) => Reservation.fromJson(doc.id, resDoc));
  }
}
