import 'package:flutter/material.dart';

class AppTheme {
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color offWhite = Color(0xFFF1F1F1);

  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color darkGray = Color(0xFF2C2C2C);
  static const Color errorRed = Color(0xFFEF4444);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      brightness: Brightness.light,
      primaryColor: emeraldGreen,
      scaffoldBackgroundColor: offWhite,
      colorScheme: const ColorScheme.light(
        primary: emeraldGreen,
        surface: pureWhite,
        error: errorRed,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: charcoal,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        bodyLarge: TextStyle(color: charcoal, fontSize: 16),
        bodyMedium: TextStyle(color: darkGray, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pureWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: emeraldGreen, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      brightness: Brightness.dark,
      primaryColor: emeraldGreen,
      scaffoldBackgroundColor: charcoal,
      colorScheme: const ColorScheme.dark(
        primary: emeraldGreen,
        surface: darkGray,
        error: errorRed,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: offWhite,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        bodyLarge: TextStyle(color: offWhite, fontSize: 16),
        bodyMedium: TextStyle(color: offWhite, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: emeraldGreen, width: 2),
        ),
      ),
    );
  }
}