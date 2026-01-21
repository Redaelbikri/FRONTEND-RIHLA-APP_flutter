import 'package:flutter/material.dart';

class RihlaColors {

  static const Color background = Color(0xFFF6EFE6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF7F2EA);


  static const Color primary = Color(0xFF1F6E5C);
  static const Color primaryDark = Color(0xFF155446);
  static const Color accent = Color(0xFFC9A34A);
  static const Color accentSoft = Color(0xFFE8D3A0);


  static const Color text = Color(0xFF1B1B1B);
  static const Color textSoft = Color(0xFF6C6C6C);
  static const Color textMuted = Color(0xFF8A8A8A);


  static const Color success = Color(0xFF2E8B57);
  static const Color warning = Color(0xFFE3A008);
  static const Color danger = Color(0xFFD64545);


  static const Color glassWhite = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x22FFFFFF);
  static const Color divider = Color(0x1A000000);


  static const Color shadow = Color(0x14000000);

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1F6E5C),
      Color(0xFF2A8C76),
      Color(0xFFC9A34A),
    ],
    stops: [0.0, 0.55, 1.0],
  );
}
