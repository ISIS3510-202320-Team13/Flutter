import 'package:flutter/material.dart';
import 'package:parkez/ui/auth/auth_screen.dart';
import 'package:parkez/ui/theme/theme_constants.dart';

void main() {
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
