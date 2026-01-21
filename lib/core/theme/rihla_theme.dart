import 'package:flutter/material.dart';
import 'rihla_colors.dart';
import 'rihla_text.dart';

class RihlaTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: RihlaColors.primary,
      brightness: Brightness.light,
      primary: RihlaColors.primary,
      secondary: RihlaColors.accent,
      surface: RihlaColors.surface,
      background: RihlaColors.background,
      error: RihlaColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: RihlaText.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: RihlaColors.background,
      textTheme: RihlaText.textTheme(Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerColor: RihlaColors.divider,
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: RihlaColors.primary,
      brightness: Brightness.dark,
      primary: RihlaColors.primary,
      secondary: RihlaColors.accent,
      surface: const Color(0xFF121212),
      background: const Color(0xFF0F0F0F),
      error: RihlaColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: RihlaText.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      textTheme: RihlaText.textTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerColor: Colors.white12,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
