/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Flutter Template';
  static const String appVersion = '1.0.0';
  
  // Shared Preferences Keys
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String userTokenKey = 'user_token';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration onboardingTransitionDuration = Duration(milliseconds: 400);
  
  // UI Constants - Modern Design System
  static const double defaultPadding = 20.0;
  static const double largePadding = 32.0;
  static const double smallPadding = 12.0;
  static const double extraSmallPadding = 8.0;

  // Border Radius - Modern Rounded Design
  static const double defaultBorderRadius = 16.0;
  static const double largeBorderRadius = 24.0;
  static const double smallBorderRadius = 12.0;
  static const double cardBorderRadius = 20.0;

  // Button Design
  static const double buttonHeight = 56.0;
  static const double smallButtonHeight = 44.0;
  static const double buttonBorderRadius = 16.0;

  // Card Design
  static const double cardElevation = 0.0; // Flat modern design
  static const double cardPadding = 24.0;

  // Spacing System
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // Icon Sizes
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  // Asset Paths
  static const String splashLogoPath = 'assets/images/splash_logo.png';
  static const String onboardingImagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  
  // Route Names
  static const String splashRoute = '/splash';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';
}
