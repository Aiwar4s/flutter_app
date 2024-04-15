import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: Colors.teal,
    secondary: Colors.amber,
    background: Color(0xFF1E1E2C),
    surface: Color(0xFF1C1C2B),
    error: Colors.redAccent,
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.w500,

    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
      fontSize: 34.0,
      fontWeight: FontWeight.w700,
    )
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E2C),
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal,
      textStyle: const TextStyle(color: Colors.white),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF1C1C2B),
    filled: true,
    focusColor: Colors.tealAccent,
    labelStyle: const TextStyle(color: Colors.white70),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.white24),
    ),
  ),
);