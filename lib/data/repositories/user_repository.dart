import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:parkez/data/models/user.dart';

class UserRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _db;
  final usersCollPath = "users";

  final mockPicture =
      "https://images.unsplash.com/photo-1696813519917-1fb0a17177b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80";

  UserRepository(
      {firebase_auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  Future<User?> getUser() async {
    return _firebaseAuth.currentUser?.toUser;
  }

  Future<String?> getUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }

  Future<User> createUser(String id, String email, String name) async {
    final user = {
      'email': email,
      'name': name,
      'picture': mockPicture,
    };

    return await _db.collection(usersCollPath).doc(id).set(user).then((value) =>
        User(id: id, email: email, name: name, picture: mockPicture));
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
        id: uid,
        email: email,
        name: displayName,
        picture: photoURL,
        reservations: {'': ''});
  }
}
