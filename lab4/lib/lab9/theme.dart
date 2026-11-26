import 'package:flutter/material.dart';

class FlipColors {
  static const blue = Color(0xFF1E6FE0);
  static const yellow = Color(0xFFFFC107);
  static const red = Color(0xFFE53935);
  static const background = Color(0xFFF4F4F5);
  static const card = Colors.white;
  static const grey = Color(0xFF8E8E93);

  static const darkBackground = Color(0xFF111318);
  static const darkCard = Color(0xFF1E232B);
}

ThemeData buildFlipTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: FlipColors.blue,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark
        ? FlipColors.darkBackground
        : FlipColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: isDark
          ? FlipColors.darkBackground
          : FlipColors.background,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      foregroundColor: isDark ? Colors.white : Colors.black87,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF252B34) : const Color(0xFFF4F4F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: FlipColors.blue, width: 1.4),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? const Color(0xFF303640) : Colors.black87,
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: FlipColors.blue,
      unselectedItemColor: isDark ? Colors.white60 : FlipColors.grey,
    ),
  );
}

String formatPrice(double price) {
  return '\$${price.toStringAsFixed(2)}';
}
