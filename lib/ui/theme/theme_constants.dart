import 'package:flutter/material.dart';

const screenPadding = EdgeInsets.all(48.0);

const colorPrimary = Colors.blue;
const colorAccent = Colors.lightBlueAccent;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPrimary,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: colorAccent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(colorPrimary),
    ),
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: colorPrimary), // This is also button font
    headlineMedium: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
  ),
);
