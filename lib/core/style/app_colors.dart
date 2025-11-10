import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Dark Red & Gold Theme
  static const Color primary = Color(0xFF8B0000); // Dark red
  static const Color secondary = Color(0xFFC9A227); // Gold
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Background colors
  static const Color background = Color(0xFFF7F5EF); // Warm off-white
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF1B1B1B);
  static const Color onBackground = Color(0xFF1B1B1B);

  // Border and divider colors
  static const Color border = Color(0xFFE2DED3); // Warm gray border
  static const Color divider = Color(0xFFE2DED3);
  static const Color focusedBorder = Color(0xFFA31212); // Brighter red for focus

  // Input colors
  static const Color inputFill = Color(0xFFF1EFE8); // Slightly darker than background

  // Other UI colors
  static const Color snackBarBackground = Color(0xFF0B1424); // Dark blue-gray
  static const Color textButtonColor = Color(0xFFA88717); // Darker gold for text buttons

  // Legacy/Dark theme colors (kept for compatibility, not used)
  static const Color lightBackground = background;
  static const Color lightSurface = surface;
  static const Color darkBackground = Color(0xFF4D217B);
  static const Color darkSurface = Color(0xFF6B4099);
  static const Color onDarkSurface = Colors.white;
  static const Color onDarkBackground = Colors.white;
  static const Color darkBorder = Color(0xFF8B5FBF);
  static const Color purpleAccent = Color(0xFF8B5FBF);
}
