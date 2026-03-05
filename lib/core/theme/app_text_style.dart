import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class AppTextStyle {
  // Font Family
  static const String _fontFamily = 'Inter';

  // Headers
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.2,
  );

  static const TextStyle h2White = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColor.pureWhite,
    height: 1.2,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.2,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.2,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.4,
  );

  static const TextStyle bodyLargeBlue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryBlue,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.4,
  );

  static const TextStyle bodySmallBlue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryBlue,
    height: 1.4,
  );

  // Captions
  static const TextStyle captionLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColor.secondaryText,
    height: 1.3,
  );

  static const TextStyle captionMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.secondaryText,
    height: 1.3,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColor.secondaryText,
    height: 1.3,
  );

  static const TextStyle captionSmallWhite = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColor.pureWhite,
    height: 1.3,
  );

  static const TextStyle captionExtraSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColor.secondaryText,
    height: 1.3,
  );

  static const TextStyle captionExtraSmallWhite = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColor.pureWhite,
    height: 1.3,
  );

  // Display Text
  static const TextStyle heroNumber = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.1,
  );

  static const TextStyle heroNumberWhite = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColor.pureWhite,
    height: 1.1,
  );

  static const TextStyle nextClassTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColor.pureWhite,
    height: 1.1,
  );

  // Button Text
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.pureWhite,
    height: 1.2,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.2,
  );

  // Input Text
  static const TextStyle input = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryText,
    height: 1.4,
  );

  static const TextStyle placeholder = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.secondaryText,
    height: 1.4,
  );

  // Badge Text
  static const TextStyle badge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const TextStyle badgeSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Navigation Text
  static const TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // Font Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
}
