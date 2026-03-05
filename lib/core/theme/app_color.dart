import 'package:flutter/material.dart';

class AppColor {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color primaryBlueDark = Color(0xFF0051D5);

  // Background Colors
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color veryLightGrey = Color(0xFFF5F7FA);

  // Text Colors
  static const Color primaryText = Color(0xFF1A1A1A);
  static const Color secondaryText = Color(0xFF8E8E93);
  static const Color tertiaryText = Color(0xFFC7C7CC);

  // Semantic Colors
  static const Color alertRed = Color(0xFFFF3B30);
  static const Color successGreen = Color(0xFF34C759);
  static const Color successGreenDark = Color(0xFF248A3D);
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color warningOrangeDark = Color(0xFFC77700);
  static const Color starYellow = Color(0xFFFFD60A);

  // Additional UI Colors
  static const Color dividerGrey = Color(0xFFE5E5EA);
  static const Color shadowColor = Color(0x1A000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueAvatarGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenAvatarGradient = LinearGradient(
    colors: [successGreen, successGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeAvatarGradient = LinearGradient(
    colors: [warningOrange, warningOrangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Opacity variants
  static Color primaryBlue10 = primaryBlue.withValues(alpha: 0.1);
  static Color primaryBlue20 = primaryBlue.withValues(alpha: 0.2);
  static Color alertRed10 = alertRed.withValues(alpha: 0.1);
  static Color successGreen10 = successGreen.withValues(alpha: 0.1);
}
