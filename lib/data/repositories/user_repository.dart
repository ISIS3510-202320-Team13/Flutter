import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:parkez/data/models/user.dart';

class UserRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  UserRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  Future<User?> getUser() async {
    return _firebaseAuth.currentUser?.toUser;
  }

  Future<String?> getUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, picture: photoURL, reservations: {'':''});
  }
}
