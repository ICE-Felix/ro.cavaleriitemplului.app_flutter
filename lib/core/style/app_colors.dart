import 'package:flutter/material.dart';

class AppColors {
  // Primary background colors
  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color darkBackground = Color(0xFF4D217B);

  // Primary colors - updated to work with new backgrounds
  static const Color primary = Color(0xFF4D217B);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Light theme colors
  static const Color background = lightBackground;
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF121212);
  static const Color onBackground = Color(0xFF121212);
  static const Color border = Color(0xFFE0E0E0);

  // Dark theme colors (using purple background)
  static const Color darkSurface = Color(
    0xFF6B4099,
  ); // Lighter shade of purple for surfaces
  static const Color onDarkSurface = Colors.white;
  static const Color onDarkBackground = Colors.white;
  static const Color darkBorder = Color(0xFF8B5FBF); // Purple-tinted border

  // Additional background variants for flexibility
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color purpleAccent = Color(
    0xFF8B5FBF,
  ); // Lighter purple for accents
}
