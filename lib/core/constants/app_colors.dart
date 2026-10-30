import 'package:flutter/material.dart';

/// App color palette reflecting USA industry standard & AmCham branding.
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primaryNavy = Color(0xFF0A2540);
  static const Color secondaryNavy = Color(0xFF1E293B);
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentBlueSoft = Color(0xFFEFF6FF);

  // USA Flag & AmCham Accent Colors
  static const Color usaRed = Color(0xFFD92D20);
  static const Color usaRedSoft = Color(0xFFFEF3F2);
  static const Color usaRedBorder = Color(0xFFFECDCA);

  static const Color usaGreen = Color(0xFF027A48);
  static const Color usaGreenSoft = Color(0xFFECFDF3);
  static const Color usaGreenBorder = Color(0xFFA6F4C5);

  // Surface & Neutral Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF1F5F9);
  static const Color surfaceTertiary = Color(0xFFE2E8F0);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFFCBD5E1);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475467);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnNavy = Color(0xFFFFFFFF);

  // Status Colors
  static const Color statusSuccess = Color(0xFF12B76A);
  static const Color statusWarning = Color(0xFFF79009);
  static const Color statusError = Color(0xFFD92D20);
  static const Color statusInfo = Color(0xFF0BA5EC);

  // Ribbon Header Gradient Colors (American / Bangladesh synergy)
  static const List<Color> ribbonGradient = [
    Color(0xFF0A2540),
    Color(0xFFD92D20),
    Color(0xFF027A48),
  ];
}

