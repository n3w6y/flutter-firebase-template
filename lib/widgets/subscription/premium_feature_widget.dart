import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/subscription_provider.dart';

/// Widget that shows premium content or upgrade prompt
class PremiumFeatureWidget extends ConsumerWidget {
  final Widget child;
  final String featureName;
  final String description;
  final IconData? icon;

  const PremiumFeatureWidget({
    super.key,
    required this.child,
    required this.featureName,
    required this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);

    if (isPremium) {
      return child;
    }

    return _buildUpgradePrompt(context);
  }

  Widget _buildUpgradePrompt(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon!,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            featureName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/subscription');
            },
            icon: const Icon(Icons.workspace_premium),
            label: const Text('Upgrade to Premium'),
          ),
        ],
      ),
    );
  }
}

/// Widget for premium badge
class PremiumBadge extends ConsumerWidget {
  final double size;

  const PremiumBadge({
    super.key,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);

    if (!isPremium) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            size: size * 0.8,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 2),
          Text(
            'PRO',
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for subscription status indicator
class SubscriptionStatusWidget extends ConsumerWidget {
  const SubscriptionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStatus = ref.watch(subscriptionStatusProvider);
    final theme = Theme.of(context);

    if (!subscriptionStatus.isActive) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            'Premium Active',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for premium feature list
class PremiumFeaturesList extends StatelessWidget {
  final List<String> features;

  const PremiumFeaturesList({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Widget for upgrade button
class UpgradeButton extends ConsumerWidget {
  final String? text;
  final VoidCallback? onPressed;

  const UpgradeButton({
    super.key,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);

    if (isPremium) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: onPressed ?? () => context.push('/subscription'),
      icon: const Icon(Icons.workspace_premium),
      label: Text(text ?? 'Upgrade to Premium'),
    );
  }
}

/// Widget for premium content wrapper
class PremiumContentWrapper extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;

  const PremiumContentWrapper({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);

    if (isPremium) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}
