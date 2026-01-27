import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColor.pureWhite,
    colorScheme: ColorScheme.light(
      primary: AppColor.primaryBlue,
      secondary: AppColor.primaryBlueDark,
      surface: AppColor.veryLightGrey,
      error: AppColor.alertRed,
      onPrimary: AppColor.pureWhite,
      onSecondary: AppColor.pureWhite,
      onSurface: AppColor.primaryText,
      onError: AppColor.pureWhite,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyle.heroNumber,
      displayMedium: AppTextStyle.nextClassTitle,
      headlineLarge: AppTextStyle.h1,
      headlineMedium: AppTextStyle.h2,
      headlineSmall: AppTextStyle.h3,
      titleLarge: AppTextStyle.h4,
      titleMedium: AppTextStyle.bodyLarge,
      titleSmall: AppTextStyle.bodyMedium,
      bodyLarge: AppTextStyle.bodyLarge,
      bodyMedium: AppTextStyle.bodyMedium,
      bodySmall: AppTextStyle.bodySmall,
      labelLarge: AppTextStyle.buttonPrimary,
      labelMedium: AppTextStyle.buttonSecondary,
      labelSmall: AppTextStyle.badge,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryBlue,
        foregroundColor: AppColor.pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppTextStyle.buttonPrimary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.veryLightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: AppTextStyle.placeholder,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      color: AppColor.veryLightGrey,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColor.dividerGrey,
      thickness: 1,
    ),
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColor.primaryText,
    colorScheme: ColorScheme.dark(
      primary: AppColor.primaryBlue,
      secondary: AppColor.primaryBlueDark,
      surface: Color(0xFF2C2C2E),
      error: AppColor.alertRed,
      onPrimary: AppColor.pureWhite,
      onSecondary: AppColor.pureWhite,
      onSurface: AppColor.pureWhite,
      onError: AppColor.pureWhite,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyle.heroNumberWhite,
      displayMedium: AppTextStyle.nextClassTitle,
      headlineLarge: AppTextStyle.h1.copyWith(color: AppColor.pureWhite),
      headlineMedium: AppTextStyle.h2White,
      headlineSmall: AppTextStyle.h3.copyWith(color: AppColor.pureWhite),
      titleLarge: AppTextStyle.h4.copyWith(color: AppColor.pureWhite),
      titleMedium: AppTextStyle.bodyLarge.copyWith(color: AppColor.pureWhite),
      titleSmall: AppTextStyle.bodyMedium.copyWith(color: AppColor.pureWhite),
      bodyLarge: AppTextStyle.bodyLarge.copyWith(color: AppColor.pureWhite),
      bodyMedium: AppTextStyle.bodyMedium.copyWith(color: AppColor.pureWhite),
      bodySmall: AppTextStyle.bodySmall.copyWith(color: AppColor.pureWhite),
      labelLarge: AppTextStyle.buttonPrimary,
      labelMedium: AppTextStyle.buttonSecondary.copyWith(
        color: AppColor.pureWhite,
      ),
      labelSmall: AppTextStyle.badge,
    ),
  );
}
