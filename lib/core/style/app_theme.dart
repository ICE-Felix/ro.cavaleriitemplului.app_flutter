import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerColor: AppColors.divider,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.snackBarBackground,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.focusedBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(50),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textButtonColor,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: AppTextStyles.textTheme,
    );
  }

  // not used at the moment
  // static ThemeData get darkTheme {
  //   return ThemeData(
  //     useMaterial3: true,
  //     scaffoldBackgroundColor: AppColors.darkBackground,
  //     colorScheme: ColorScheme.fromSeed(
  //       seedColor: AppColors.primary,
  //       brightness: Brightness.dark,
  //       surface: AppColors.darkSurface,
  //     ),
  //     appBarTheme: const AppBarTheme(
  //       elevation: 0,
  //       centerTitle: true,
  //       backgroundColor: AppColors.darkBackground,
  //       foregroundColor: Colors.white,
  //     ),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         foregroundColor: Colors.white,
  //         backgroundColor: AppColors.purpleAccent,
  //         minimumSize: const Size.fromHeight(50),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //       ),
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: const BorderSide(color: AppColors.darkBorder),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: const BorderSide(color: AppColors.purpleAccent),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: const BorderSide(color: AppColors.error),
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: 16,
  //         vertical: 14,
  //       ),
  //       fillColor: AppColors.darkSurface,
  //       filled: true,
  //     ),
  //     textTheme: AppTextStyles.textTheme.apply(
  //       bodyColor: AppColors.onDarkBackground,
  //       displayColor: AppColors.onDarkBackground,
  //     ),
  //   );
  // }
}
