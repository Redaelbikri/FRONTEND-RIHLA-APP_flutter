import 'package:flutter/material.dart';
import 'rihla_colors.dart';

class RihlaText {
  static const String fontFamily = 'SFPro';

  static TextTheme textTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.dark
        ? Colors.white
        : RihlaColors.text;

    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.35,
        fontWeight: FontWeight.w500,
        color: baseColor.withValues(alpha: 0.86),
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: baseColor.withValues(alpha: 0.85),
      ),
    );
  }
}
