import 'package:flutter/material.dart';

/// Modern color palette for high-end professional design
class AppColors {
  // Primary Brand Colors - Modern Blue Gradient
  static const Color primaryBlue = Color(0xFF2563EB); // Modern blue
  static const Color primaryBlueDark = Color(0xFF1D4ED8); // Darker blue
  static const Color primaryBlueLight = Color(0xFF3B82F6); // Lighter blue
  
  // Secondary Colors - Elegant Purple Accent
  static const Color secondaryPurple = Color(0xFF7C3AED); // Modern purple
  static const Color secondaryPurpleLight = Color(0xFF8B5CF6); // Light purple
  static const Color secondaryPurpleDark = Color(0xFF6D28D9); // Dark purple
  
  // Neutral Colors - Professional Gray Scale
  static const Color neutral50 = Color(0xFFFAFAFA); // Almost white
  static const Color neutral100 = Color(0xFFF5F5F5); // Very light gray
  static const Color neutral200 = Color(0xFFE5E5E5); // Light gray
  static const Color neutral300 = Color(0xFFD4D4D4); // Medium light gray
  static const Color neutral400 = Color(0xFFA3A3A3); // Medium gray
  static const Color neutral500 = Color(0xFF737373); // Gray
  static const Color neutral600 = Color(0xFF525252); // Dark gray
  static const Color neutral700 = Color(0xFF404040); // Darker gray
  static const Color neutral800 = Color(0xFF262626); // Very dark gray
  static const Color neutral900 = Color(0xFF171717); // Almost black
  
  // Surface Colors - Modern Backgrounds
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceLightSecondary = Color(0xFFFAFAFA); // Off white
  static const Color surfaceDark = Color(0xFF0F0F0F); // Rich black
  static const Color surfaceDarkSecondary = Color(0xFF1A1A1A); // Dark gray
  
  // Card Colors - Elevated Surfaces
  static const Color cardLight = Color(0xFFFFFFFF); // White cards
  static const Color cardLightBorder = Color(0xFFF1F5F9); // Subtle border
  static const Color cardDark = Color(0xFF1E1E1E); // Dark cards
  static const Color cardDarkBorder = Color(0xFF2A2A2A); // Dark border
  
  // Text Colors - High Contrast
  static const Color textPrimaryLight = Color(0xFF0F172A); // Almost black
  static const Color textSecondaryLight = Color(0xFF475569); // Medium gray
  static const Color textTertiaryLight = Color(0xFF94A3B8); // Light gray
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Almost white
  static const Color textSecondaryDark = Color(0xFFCBD5E1); // Light gray
  static const Color textTertiaryDark = Color(0xFF64748B); // Medium gray
  
  // Status Colors - Semantic Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color successLight = Color(0xFFD1FAE5); // Light green
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color warningLight = Color(0xFFFEF3C7); // Light orange
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFFEE2E2); // Light red
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFFDBEAFE); // Light blue
  
  // Premium Colors - Luxury Feel
  static const Color premiumGold = Color(0xFFD4AF37); // Gold
  static const Color premiumGoldLight = Color(0xFFFAF3E0); // Light gold
  static const Color premiumSilver = Color(0xFFC0C0C0); // Silver
  static const Color premiumPlatinum = Color(0xFFE5E4E2); // Platinum
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryPurple, secondaryPurpleDark],
  );
  
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [premiumGold, Color(0xFFB8860B)],
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [neutral50, neutral100],
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x0F000000); // 6% black
  static const Color shadowMedium = Color(0x1A000000); // 10% black
  static const Color shadowDark = Color(0x26000000); // 15% black
  
  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0); // Light border
  static const Color borderMedium = Color(0xFFCBD5E1); // Medium border
  static const Color borderDark = Color(0xFF475569); // Dark border
  
  // Interactive Colors
  static const Color hoverLight = Color(0xFFF8FAFC); // Light hover
  static const Color hoverDark = Color(0xFF334155); // Dark hover
  static const Color pressedLight = Color(0xFFE2E8F0); // Light pressed
  static const Color pressedDark = Color(0xFF475569); // Dark pressed
  
  // Focus Colors
  static const Color focusRing = Color(0xFF3B82F6); // Blue focus ring
  static const Color focusRingLight = Color(0x4D3B82F6); // Light blue focus
  
  // Overlay Colors
  static const Color overlayLight = Color(0x80000000); // 50% black
  static const Color overlayDark = Color(0x80FFFFFF); // 50% white
  static const Color backdropBlur = Color(0x40000000); // 25% black
  
  // Helper Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  static Color blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }
  
  // Theme-aware color getters
  static Color getTextPrimary(bool isDark) {
    return isDark ? textPrimaryDark : textPrimaryLight;
  }
  
  static Color getTextSecondary(bool isDark) {
    return isDark ? textSecondaryDark : textSecondaryLight;
  }
  
  static Color getSurface(bool isDark) {
    return isDark ? surfaceDark : surfaceLight;
  }
  
  static Color getCard(bool isDark) {
    return isDark ? cardDark : cardLight;
  }
  
  static Color getBorder(bool isDark) {
    return isDark ? cardDarkBorder : cardLightBorder;
  }
}
