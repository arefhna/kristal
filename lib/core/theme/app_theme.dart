import 'package:flutter/material.dart';

import 'theme_palette.dart';

class AppTheme {
  AppTheme._();

  static ThemeData fromPalette(ThemePalette palette) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: palette.accent,
      brightness: Brightness.dark,
    ).copyWith(
      surface: palette.backgroundGradient.first,
      onSurface: palette.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.backgroundGradient.first,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: palette.textPrimary,
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        headlineMedium: TextStyle(
          color: palette.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: palette.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
        bodyMedium: TextStyle(
          color: palette.textPrimary,
          fontSize: 14,
        ),
      ),
    );
  }
}
