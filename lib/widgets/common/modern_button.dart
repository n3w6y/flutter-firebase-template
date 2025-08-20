import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_typography.dart';

/// Modern button variants
enum ModernButtonVariant {
  primary,
  secondary,
  outline,
  text,
  premium,
  success,
  warning,
  error,
}

/// Modern button sizes
enum ModernButtonSize {
  small,
  medium,
  large,
}

/// Modern button widget with consistent styling
class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonVariant variant;
  final ModernButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? margin;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ModernButtonVariant.primary,
    this.size = ModernButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: margin,
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(context, isDarkMode),
    );
  }

  Widget _buildButton(BuildContext context, bool isDarkMode) {
    final buttonStyle = _getButtonStyle(isDarkMode);
    final textStyle = _getTextStyle(isDarkMode);
    final buttonHeight = _getButtonHeight();

    Widget buttonChild = _buildButtonChild(textStyle);

    switch (variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.secondary:
      case ModernButtonVariant.success:
      case ModernButtonVariant.warning:
      case ModernButtonVariant.error:
        return SizedBox(
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        );

      case ModernButtonVariant.outline:
        return SizedBox(
          height: buttonHeight,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        );

      case ModernButtonVariant.text:
        return SizedBox(
          height: buttonHeight,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        );

      case ModernButtonVariant.premium:
        return SizedBox(
          height: buttonHeight,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.premiumGradient,
              borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.premiumGold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onPressed,
                borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                child: Container(
                  padding: _getButtonPadding(),
                  alignment: Alignment.center,
                  child: buttonChild,
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget _buildButtonChild(TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textStyle.color ?? Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _getIconSize(),
            color: textStyle.color,
          ),
          const SizedBox(width: AppConstants.spacing8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  ButtonStyle _getButtonStyle(bool isDarkMode) {
    final colors = _getButtonColors(isDarkMode);
    
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors['disabled'];
        }
        if (states.contains(WidgetState.pressed)) {
          return colors['pressed'];
        }
        if (states.contains(WidgetState.hovered)) {
          return colors['hovered'];
        }
        return colors['default'];
      }),
      foregroundColor: WidgetStateProperty.all(colors['foreground']),
      overlayColor: WidgetStateProperty.all(colors['overlay']),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
      ),
      side: variant == ModernButtonVariant.outline
          ? WidgetStateProperty.all(
              BorderSide(
                color: colors['border'] ?? colors['default']!,
                width: 1.5,
              ),
            )
          : null,
      padding: WidgetStateProperty.all(_getButtonPadding()),
      minimumSize: WidgetStateProperty.all(Size(0, _getButtonHeight())),
    );
  }

  Map<String, Color?> _getButtonColors(bool isDarkMode) {
    switch (variant) {
      case ModernButtonVariant.primary:
        return {
          'default': AppColors.primaryBlue,
          'foreground': Colors.white,
          'hovered': AppColors.primaryBlueDark,
          'pressed': AppColors.primaryBlueDark,
          'disabled': AppColors.neutral300,
          'overlay': Colors.white.withOpacity(0.1),
        };

      case ModernButtonVariant.secondary:
        return {
          'default': AppColors.secondaryPurple,
          'foreground': Colors.white,
          'hovered': AppColors.secondaryPurpleDark,
          'pressed': AppColors.secondaryPurpleDark,
          'disabled': AppColors.neutral300,
          'overlay': Colors.white.withOpacity(0.1),
        };

      case ModernButtonVariant.outline:
        return {
          'default': Colors.transparent,
          'foreground': isDarkMode ? AppColors.primaryBlueLight : AppColors.primaryBlue,
          'hovered': isDarkMode ? AppColors.primaryBlueLight.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.1),
          'pressed': isDarkMode ? AppColors.primaryBlueLight.withOpacity(0.2) : AppColors.primaryBlue.withOpacity(0.2),
          'disabled': Colors.transparent,
          'overlay': isDarkMode ? AppColors.primaryBlueLight.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.1),
          'border': isDarkMode ? AppColors.primaryBlueLight : AppColors.primaryBlue,
        };

      case ModernButtonVariant.text:
        return {
          'default': Colors.transparent,
          'foreground': isDarkMode ? AppColors.primaryBlueLight : AppColors.primaryBlue,
          'hovered': isDarkMode ? AppColors.primaryBlueLight.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.1),
          'pressed': isDarkMode ? AppColors.primaryBlueLight.withOpacity(0.2) : AppColors.primaryBlue.withOpacity(0.2),
          'disabled': Colors.transparent,
          'overlay': isDarkMode ? AppColors.primaryBlueLight.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.1),
        };

      case ModernButtonVariant.success:
        return {
          'default': AppColors.success,
          'foreground': Colors.white,
          'hovered': AppColors.success.withOpacity(0.8),
          'pressed': AppColors.success.withOpacity(0.9),
          'disabled': AppColors.neutral300,
          'overlay': Colors.white.withOpacity(0.1),
        };

      case ModernButtonVariant.warning:
        return {
          'default': AppColors.warning,
          'foreground': Colors.white,
          'hovered': AppColors.warning.withOpacity(0.8),
          'pressed': AppColors.warning.withOpacity(0.9),
          'disabled': AppColors.neutral300,
          'overlay': Colors.white.withOpacity(0.1),
        };

      case ModernButtonVariant.error:
        return {
          'default': AppColors.error,
          'foreground': Colors.white,
          'hovered': AppColors.error.withOpacity(0.8),
          'pressed': AppColors.error.withOpacity(0.9),
          'disabled': AppColors.neutral300,
          'overlay': Colors.white.withOpacity(0.1),
        };

      case ModernButtonVariant.premium:
        return {
          'default': Colors.transparent,
          'foreground': AppColors.neutral900,
          'hovered': Colors.transparent,
          'pressed': Colors.transparent,
          'disabled': AppColors.neutral300,
          'overlay': Colors.black.withOpacity(0.1),
        };
    }
  }

  TextStyle _getTextStyle(bool isDarkMode) {
    final baseStyle = switch (size) {
      ModernButtonSize.small => AppTypography.buttonSmall(isDarkMode),
      ModernButtonSize.medium => AppTypography.buttonMedium(isDarkMode),
      ModernButtonSize.large => AppTypography.buttonLarge(isDarkMode),
    };

    final colors = _getButtonColors(isDarkMode);
    return baseStyle.copyWith(color: colors['foreground']);
  }

  EdgeInsetsGeometry _getButtonPadding() {
    return switch (size) {
      ModernButtonSize.small => const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing16,
          vertical: AppConstants.spacing8,
        ),
      ModernButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing20,
          vertical: AppConstants.spacing12,
        ),
      ModernButtonSize.large => const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing24,
          vertical: AppConstants.spacing16,
        ),
    };
  }

  double _getButtonHeight() {
    return switch (size) {
      ModernButtonSize.small => AppConstants.smallButtonHeight,
      ModernButtonSize.medium => AppConstants.buttonHeight - 8,
      ModernButtonSize.large => AppConstants.buttonHeight,
    };
  }

  double _getIconSize() {
    return switch (size) {
      ModernButtonSize.small => AppConstants.iconSizeSmall,
      ModernButtonSize.medium => AppConstants.iconSizeSmall,
      ModernButtonSize.large => AppConstants.iconSizeMedium,
    };
  }
}
