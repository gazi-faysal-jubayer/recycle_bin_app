import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF4CAF50),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF4CAF50),
      secondary: const Color(0xFF8BC34A),
      surface: Colors.white,
      background: const Color(0xFFF5F5F5),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4CAF50),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  // Dark theme colors
  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF2E7D32),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF2E7D32),
      secondary: const Color(0xFF558B2F),
      surface: const Color(0xFF121212),
      background: const Color(0xFF121212),
      error: const Color(0xFFCF6679),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2E7D32),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}