import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';

// TODO: Probably add some cloud firestore stuff so this works
class ReservationRepository {
  final FirebaseFirestore _firestore;

  ReservationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
}
