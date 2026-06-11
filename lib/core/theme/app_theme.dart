import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData buildLightTheme(Color accentColor, double fontScale) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      textTheme: _buildTextTheme(fontScale),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData buildDarkTheme(Color accentColor, double fontScale) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      textTheme: _buildTextTheme(fontScale),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surfaceContainerHigh,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(double fontScale) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 57 * fontScale, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(fontSize: 45 * fontScale, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontSize: 36 * fontScale, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontSize: 32 * fontScale, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 28 * fontScale, fontWeight: FontWeight.w500),
      headlineSmall: TextStyle(fontSize: 24 * fontScale, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 22 * fontScale, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16 * fontScale, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14 * fontScale, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16 * fontScale, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14 * fontScale, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12 * fontScale, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14 * fontScale, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontSize: 12 * fontScale, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 11 * fontScale, fontWeight: FontWeight.w500),
    ).apply(
      fontFamily: '.SF Pro Display',
    );
  }
}
