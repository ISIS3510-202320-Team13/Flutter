import 'package:flutter/material.dart';

const screenPadding = EdgeInsets.all(48.0);

const colorPrimary = Colors.blue;
const colorAccent = Colors.lightBlueAccent;

Color colorB1 = Color(int.parse("0961AD", radix: 16) + 0xFF000000);
Color colorB2 = Color(int.parse("2597FA", radix: 16) + 0xFF000000);
Color colorB3 = Color(int.parse("40A6FF", radix: 16) + 0xFF000000);
Color colorB4 = Color(int.parse("F5FCFF", radix: 16) + 0xFF000000);
Color colorBackground = Color(int.parse("F9FCFF", radix: 16) + 0xFF000000);

Color colorY1 = Color(int.parse("B89865", radix: 16) + 0xFF000000);

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
