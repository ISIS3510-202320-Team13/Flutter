import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:parkez/data/models/user.dart';

class UserRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;


  UserRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  Future<Future<DocumentSnapshot<Map<String, dynamic>>>?> getUser() async {
    return _firebaseAuth.currentUser?.toUser;
  }
}

extension on firebase_auth.User {
  Future<DocumentSnapshot<Map<String, dynamic>>> get toUser {
    final _firestore = FirebaseFirestore.instance;
    User id =  User(id: uid);

    return _firestore.collection('users').doc(id.id).get();
  }
}
