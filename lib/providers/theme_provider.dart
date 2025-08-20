import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_constants.dart';

/// Theme mode enumeration
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Theme state class
class ThemeState {
  final AppThemeMode themeMode;
  final Color primaryColor;
  final double fontSize;

  const ThemeState({
    this.themeMode = AppThemeMode.system,
    this.primaryColor = AppColors.primaryBlue,
    this.fontSize = AppTypography.fontSize16,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    Color? primaryColor,
    double? fontSize,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'primaryColor': primaryColor.value,
      'fontSize': fontSize,
    };
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(
      themeMode: AppThemeMode.values[json['themeMode'] ?? 0],
      primaryColor: Color(json['primaryColor'] ?? Colors.blue.value),
      fontSize: json['fontSize']?.toDouble() ?? 14.0,
    );
  }
}

/// Theme notifier class
class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'app_theme_settings';
  
  ThemeNotifier() : super(const ThemeState()) {
    _loadThemeSettings();
  }

  /// Load theme settings from shared preferences
  Future<void> _loadThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeJson = prefs.getString(_themeKey);
      
      if (themeJson != null) {
        final themeData = Map<String, dynamic>.from(
          // Simple JSON parsing for basic types
          {
            'themeMode': prefs.getInt('themeMode') ?? 0,
            'primaryColor': prefs.getInt('primaryColor') ?? Colors.blue.value,
            'fontSize': prefs.getDouble('fontSize') ?? 14.0,
          }
        );
        
        state = ThemeState.fromJson(themeData);
      }
    } catch (e) {
      // If loading fails, keep default theme
      debugPrint('Failed to load theme settings: $e');
    }
  }

  /// Save theme settings to shared preferences
  Future<void> _saveThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('themeMode', state.themeMode.index);
      await prefs.setInt('primaryColor', state.primaryColor.value);
      await prefs.setDouble('fontSize', state.fontSize);
    } catch (e) {
      debugPrint('Failed to save theme settings: $e');
    }
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    final newMode = state.themeMode == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;
    
    state = state.copyWith(themeMode: newMode);
    _saveThemeSettings();
  }

  /// Set specific theme mode
  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveThemeSettings();
  }

  /// Set primary color
  void setPrimaryColor(Color color) {
    state = state.copyWith(primaryColor: color);
    _saveThemeSettings();
  }

  /// Set font size
  void setFontSize(double size) {
    state = state.copyWith(fontSize: size);
    _saveThemeSettings();
  }

  /// Reset to default theme
  void resetToDefault() {
    state = const ThemeState();
    _saveThemeSettings();
  }
}

/// Theme provider
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier(),
);

/// Current theme mode provider
final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeState = ref.watch(themeNotifierProvider);
  
  switch (themeState.themeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});

/// Is dark mode provider (for simple boolean checks)
final isDarkModeProvider = Provider<bool>((ref) {
  final themeState = ref.watch(themeNotifierProvider);
  return themeState.themeMode == AppThemeMode.dark;
});

/// Light theme provider
final lightThemeProvider = Provider<ThemeData>((ref) {
  final themeState = ref.watch(themeNotifierProvider);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Modern Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryBlueLight,
      onPrimaryContainer: AppColors.neutral900,
      secondary: AppColors.secondaryPurple,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryPurpleLight,
      onSecondaryContainer: AppColors.neutral900,
      tertiary: AppColors.premiumGold,
      onTertiary: AppColors.neutral900,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.neutral900,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainerHighest: AppColors.surfaceLightSecondary,
      onSurfaceVariant: AppColors.textSecondaryLight,
      outline: AppColors.borderLight,
      outlineVariant: AppColors.borderMedium,
      shadow: AppColors.shadowLight,
      scrim: AppColors.overlayLight,
      inverseSurface: AppColors.neutral800,
      onInverseSurface: AppColors.neutral100,
      inversePrimary: AppColors.primaryBlueLight,
    ),

    // Modern Typography
    textTheme: AppTypography.getTextTheme(false),

    // Modern AppBar
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      titleTextStyle: AppTypography.titleLarge(false),
      toolbarHeight: 64,
      shape: const Border(
        bottom: BorderSide(
          color: AppColors.borderLight,
          width: 0.5,
        ),
      ),
    ),

    // Modern Cards
    cardTheme: CardThemeData(
      elevation: AppConstants.cardElevation,
      color: AppColors.cardLight,
      shadowColor: AppColors.shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: const BorderSide(
          color: AppColors.cardLightBorder,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(AppConstants.spacing8),
    ),

    // Modern Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing20,
        vertical: AppConstants.spacing16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.primaryBlue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      labelStyle: AppTypography.bodyMedium(false),
      hintStyle: AppTypography.bodyMedium(false).copyWith(
        color: AppColors.textTertiaryLight,
      ),
      errorStyle: AppTypography.bodySmall(false).copyWith(
        color: AppColors.error,
      ),
    ),

    // Modern Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing24,
          vertical: AppConstants.spacing16,
        ),
        minimumSize: const Size(0, AppConstants.buttonHeight),
        textStyle: AppTypography.buttonLarge(false),
      ),
    ),

    // Modern Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        side: const BorderSide(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing24,
          vertical: AppConstants.spacing16,
        ),
        minimumSize: const Size(0, AppConstants.buttonHeight),
        textStyle: AppTypography.buttonLarge(false).copyWith(
          color: AppColors.primaryBlue,
        ),
      ),
    ),

    // Modern Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing20,
          vertical: AppConstants.spacing12,
        ),
        minimumSize: const Size(0, AppConstants.smallButtonHeight),
        textStyle: AppTypography.buttonMedium(false).copyWith(
          color: AppColors.primaryBlue,
        ),
      ),
    ),

    // Modern Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.textTertiaryLight,
      selectedLabelStyle: AppTypography.labelSmall(false),
      unselectedLabelStyle: AppTypography.labelSmall(false),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Modern Navigation Bar (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      indicatorColor: AppColors.primaryBlue.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelSmall(false).copyWith(
            color: AppColors.primaryBlue,
          );
        }
        return AppTypography.labelSmall(false).copyWith(
          color: AppColors.textTertiaryLight,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.primaryBlue,
            size: AppConstants.iconSizeMedium,
          );
        }
        return const IconThemeData(
          color: AppColors.textTertiaryLight,
          size: AppConstants.iconSizeMedium,
        );
      }),
      elevation: 0,
      height: 80,
    ),

    // Modern Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.borderLight,
      thickness: 0.5,
      space: 1,
    ),

    // Modern List Tile
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing20,
        vertical: AppConstants.spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
      ),
      titleTextStyle: AppTypography.titleMedium(false),
      subtitleTextStyle: AppTypography.bodyMedium(false),
      leadingAndTrailingTextStyle: AppTypography.bodyMedium(false),
    ),
  );
});

/// Dark theme provider
final darkThemeProvider = Provider<ThemeData>((ref) {
  final themeState = ref.watch(themeNotifierProvider);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Modern Dark Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryBlueLight,
      onPrimary: AppColors.neutral900,
      primaryContainer: AppColors.primaryBlueDark,
      onPrimaryContainer: AppColors.neutral100,
      secondary: AppColors.secondaryPurpleLight,
      onSecondary: AppColors.neutral900,
      secondaryContainer: AppColors.secondaryPurpleDark,
      onSecondaryContainer: AppColors.neutral100,
      tertiary: AppColors.premiumGold,
      onTertiary: AppColors.neutral900,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.error.withOpacity(0.2),
      onErrorContainer: AppColors.errorLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceDarkSecondary,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.cardDarkBorder,
      outlineVariant: AppColors.neutral700,
      shadow: AppColors.shadowDark,
      scrim: AppColors.overlayDark,
      inverseSurface: AppColors.neutral100,
      onInverseSurface: AppColors.neutral800,
      inversePrimary: AppColors.primaryBlue,
    ),

    // Modern Typography
    textTheme: AppTypography.getTextTheme(true),

    // Modern Dark AppBar
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: AppTypography.titleLarge(true),
      toolbarHeight: 64,
      shape: const Border(
        bottom: BorderSide(
          color: AppColors.cardDarkBorder,
          width: 0.5,
        ),
      ),
    ),

    // Modern Dark Cards
    cardTheme: CardThemeData(
      elevation: AppConstants.cardElevation,
      color: AppColors.cardDark,
      shadowColor: AppColors.shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: const BorderSide(
          color: AppColors.cardDarkBorder,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(AppConstants.spacing8),
    ),

    // Modern Dark Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral800,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing20,
        vertical: AppConstants.spacing16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.cardDarkBorder,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.cardDarkBorder,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.primaryBlueLight,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      labelStyle: AppTypography.bodyMedium(true),
      hintStyle: AppTypography.bodyMedium(true).copyWith(
        color: AppColors.textTertiaryDark,
      ),
      errorStyle: AppTypography.bodySmall(true).copyWith(
        color: AppColors.error,
      ),
    ),

    // Modern Dark Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlueLight,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing24,
          vertical: AppConstants.spacing16,
        ),
        minimumSize: const Size(0, AppConstants.buttonHeight),
        textStyle: AppTypography.buttonLarge(true).copyWith(
          color: AppColors.neutral900,
        ),
      ),
    ),

    // Modern Dark Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlueLight,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        side: const BorderSide(
          color: AppColors.primaryBlueLight,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing24,
          vertical: AppConstants.spacing16,
        ),
        minimumSize: const Size(0, AppConstants.buttonHeight),
        textStyle: AppTypography.buttonLarge(true).copyWith(
          color: AppColors.primaryBlueLight,
        ),
      ),
    ),

    // Modern Dark Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlueLight,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing20,
          vertical: AppConstants.spacing12,
        ),
        minimumSize: const Size(0, AppConstants.smallButtonHeight),
        textStyle: AppTypography.buttonMedium(true).copyWith(
          color: AppColors.primaryBlueLight,
        ),
      ),
    ),

    // Modern Dark Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryBlueLight,
      unselectedItemColor: AppColors.textTertiaryDark,
      selectedLabelStyle: AppTypography.labelSmall(true),
      unselectedLabelStyle: AppTypography.labelSmall(true),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Modern Dark Navigation Bar (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primaryBlueLight.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelSmall(true).copyWith(
            color: AppColors.primaryBlueLight,
          );
        }
        return AppTypography.labelSmall(true).copyWith(
          color: AppColors.textTertiaryDark,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.primaryBlueLight,
            size: AppConstants.iconSizeMedium,
          );
        }
        return const IconThemeData(
          color: AppColors.textTertiaryDark,
          size: AppConstants.iconSizeMedium,
        );
      }),
      elevation: 0,
      height: 80,
    ),

    // Modern Dark Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.cardDarkBorder,
      thickness: 0.5,
      space: 1,
    ),

    // Modern Dark List Tile
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing20,
        vertical: AppConstants.spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
      ),
      titleTextStyle: AppTypography.titleMedium(true),
      subtitleTextStyle: AppTypography.bodyMedium(true),
      leadingAndTrailingTextStyle: AppTypography.bodyMedium(true),
    ),
  );
});

/// Available modern theme colors
final availableThemeColors = [
  AppColors.primaryBlue,
  AppColors.secondaryPurple,
  AppColors.success,
  AppColors.warning,
  AppColors.error,
  AppColors.info,
  AppColors.premiumGold,
  const Color(0xFF06B6D4), // Cyan
  const Color(0xFF8B5CF6), // Violet
  const Color(0xFF10B981), // Emerald
  const Color(0xFFF59E0B), // Amber
  const Color(0xFFEF4444), // Red
];
