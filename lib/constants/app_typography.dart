import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Modern typography system for professional design
class AppTypography {
  // Font Families - Modern and Professional
  static const String primaryFontFamily = 'Inter'; // Clean, modern
  static const String secondaryFontFamily = 'SF Pro Display'; // Apple-style
  static const String monoFontFamily = 'JetBrains Mono'; // Code/monospace
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  
  // Font Sizes - Modern Scale
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize48 = 48.0;
  
  // Line Heights - Optimal Readability
  static const double lineHeight1_2 = 1.2;
  static const double lineHeight1_4 = 1.4;
  static const double lineHeight1_5 = 1.5;
  static const double lineHeight1_6 = 1.6;
  
  // Letter Spacing - Modern Feel
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingExtraWide = 1.0;
  
  // Display Text Styles - Large Headlines
  static TextStyle displayLarge(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize48,
    fontWeight: extraBold,
    height: lineHeight1_2,
    letterSpacing: letterSpacingTight,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle displayMedium(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize36,
    fontWeight: bold,
    height: lineHeight1_2,
    letterSpacing: letterSpacingTight,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle displaySmall(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize32,
    fontWeight: bold,
    height: lineHeight1_4,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  // Headline Text Styles - Section Headers
  static TextStyle headlineLarge(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize28,
    fontWeight: semiBold,
    height: lineHeight1_4,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle headlineMedium(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize24,
    fontWeight: semiBold,
    height: lineHeight1_4,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle headlineSmall(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize20,
    fontWeight: medium,
    height: lineHeight1_5,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  // Title Text Styles - Card Titles
  static TextStyle titleLarge(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize18,
    fontWeight: medium,
    height: lineHeight1_5,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle titleMedium(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize16,
    fontWeight: medium,
    height: lineHeight1_5,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle titleSmall(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize14,
    fontWeight: medium,
    height: lineHeight1_5,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  // Body Text Styles - Main Content
  static TextStyle bodyLarge(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize16,
    fontWeight: regular,
    height: lineHeight1_6,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle bodyMedium(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize14,
    fontWeight: regular,
    height: lineHeight1_5,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextSecondary(isDark),
  );
  
  static TextStyle bodySmall(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize12,
    fontWeight: regular,
    height: lineHeight1_5,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextSecondary(isDark),
  );
  
  // Label Text Styles - UI Elements
  static TextStyle labelLarge(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize14,
    fontWeight: medium,
    height: lineHeight1_4,
    letterSpacing: letterSpacingWide,
    color: AppColors.getTextPrimary(isDark),
  );
  
  static TextStyle labelMedium(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize12,
    fontWeight: medium,
    height: lineHeight1_4,
    letterSpacing: letterSpacingWide,
    color: AppColors.getTextSecondary(isDark),
  );
  
  static TextStyle labelSmall(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize12,
    fontWeight: regular,
    height: lineHeight1_4,
    letterSpacing: letterSpacingExtraWide,
    color: AppColors.getTextSecondary(isDark),
  );
  
  // Button Text Styles
  static TextStyle buttonLarge(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize16,
    fontWeight: semiBold,
    height: lineHeight1_4,
    letterSpacing: letterSpacingWide,
    color: Colors.white,
  );
  
  static TextStyle buttonMedium(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize14,
    fontWeight: semiBold,
    height: lineHeight1_4,
    letterSpacing: letterSpacingWide,
    color: Colors.white,
  );
  
  static TextStyle buttonSmall(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize12,
    fontWeight: medium,
    height: lineHeight1_4,
    letterSpacing: letterSpacingWide,
    color: Colors.white,
  );
  
  // Special Text Styles
  static TextStyle caption(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize12,
    fontWeight: regular,
    height: lineHeight1_4,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextSecondary(isDark),
  );
  
  static TextStyle overline(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize12,
    fontWeight: medium,
    height: lineHeight1_4,
    letterSpacing: letterSpacingExtraWide,
    color: AppColors.getTextSecondary(isDark),
  );
  
  // Code/Monospace Text
  static TextStyle code(bool isDark) => GoogleFonts.jetBrainsMono(
    fontSize: fontSize14,
    fontWeight: regular,
    height: lineHeight1_5,
    letterSpacing: letterSpacingNormal,
    color: AppColors.getTextPrimary(isDark),
  );
  
  // Premium Text Styles
  static TextStyle premiumTitle(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize20,
    fontWeight: semiBold,
    height: lineHeight1_4,
    letterSpacing: letterSpacingNormal,
    color: AppColors.premiumGold,
  );
  
  static TextStyle premiumLabel(bool isDark) => GoogleFonts.inter(
    fontSize: fontSize12,
    fontWeight: bold,
    height: lineHeight1_4,
    letterSpacing: letterSpacingExtraWide,
    color: AppColors.premiumGold,
  );
  
  // Helper method to get TextTheme
  static TextTheme getTextTheme(bool isDark) {
    return TextTheme(
      displayLarge: displayLarge(isDark),
      displayMedium: displayMedium(isDark),
      displaySmall: displaySmall(isDark),
      headlineLarge: headlineLarge(isDark),
      headlineMedium: headlineMedium(isDark),
      headlineSmall: headlineSmall(isDark),
      titleLarge: titleLarge(isDark),
      titleMedium: titleMedium(isDark),
      titleSmall: titleSmall(isDark),
      bodyLarge: bodyLarge(isDark),
      bodyMedium: bodyMedium(isDark),
      bodySmall: bodySmall(isDark),
      labelLarge: labelLarge(isDark),
      labelMedium: labelMedium(isDark),
      labelSmall: labelSmall(isDark),
    );
  }
}
