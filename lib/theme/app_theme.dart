import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(
    0xFF4B2340,
  ); // deep purple (Secondary in design)
  static const Color onPrimary = Color.fromARGB(
    255,
    215,
    167,
    228,
  ); // onSecondary style
  static const Color tertiary = Color(0xFFF08D70);
  static const Color background = Color(0xFFFDF9FC);
  static const Color inputBorder = Color(0xFF6F2E5A);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 18),

      bodyMedium: TextStyle(fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      ),
    ),
  );
}
