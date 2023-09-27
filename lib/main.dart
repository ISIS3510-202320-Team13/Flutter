import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parkez/ui/auth/auth_screen.dart';
import 'package:parkez/ui/theme/theme_constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const LandingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
