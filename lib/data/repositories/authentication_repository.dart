import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkez/data/models/user.dart';
import 'package:parkez/data/repositories/authenthication_exceptions.dart';
import 'package:parkez/data/repositories/user_repository.dart';

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserRepository _userRepository;

  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _userRepository = userRepository ?? UserRepository();

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      return user;
    });
  }

  User get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return User.empty;
    }
    return user.toUser;
  }

  Future<void> signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      firebase_auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      await _firebaseAuth.currentUser!.updateDisplayName(name);
      await _userRepository.createUser(userId, email, name);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SingupWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SingupWithEmailAndPasswordFailure();
    }
  }

  Future<void> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SigninWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SigninWithEmailAndPasswordFailure();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SigninWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const SigninWithGoogleFailure();
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw const SignOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, picture: photoURL);
  }
}
