import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parkez/app.dart';
import 'package:parkez/data/repositories/authentication_repository.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  final authRepository = AuthenticationRepository();
  await authRepository.user.first;

  runApp(App(authRepository: authRepository));
}
