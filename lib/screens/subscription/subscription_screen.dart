import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../models/subscription_models.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/navigation/responsive_navigation.dart';

/// Subscription/Premium screen
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  SubscriptionPlan? selectedPlan;

  @override
  void initState() {
    super.initState();
    // Initialize subscription service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionOperationsProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subscriptionState = ref.watch(subscriptionProvider);
    final isLoading = ref.watch(subscriptionLoadingProvider);

    return ResponsiveNavigation(
      title: 'Premium Features',
      child: subscriptionState.status.isPremium
          ? _buildPremiumActiveView(context, theme)
          : _buildSubscriptionView(context, theme, isLoading),
    );
  }

  Widget _buildPremiumActiveView(BuildContext context, ThemeData theme) {
    final status = ref.watch(subscriptionStatusProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Premium active card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.verified,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Premium Active',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have access to all premium features',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (status.expirationDate != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Expires: ${_formatDate(status.expirationDate!)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Premium features
          _buildPremiumFeatures(context, theme),

          const SizedBox(height: 24),

          // Manage subscription button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _showManageSubscriptionDialog(context);
              },
              child: const Text('Manage Subscription'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionView(BuildContext context, ThemeData theme, bool isLoading) {
    final availablePlans = ref.watch(availablePlansProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, theme),

          const SizedBox(height: 32),

          // Premium features
          _buildPremiumFeatures(context, theme),

          const SizedBox(height: 32),

          // Subscription plans
          if (availablePlans.isNotEmpty) ...[
            Text(
              'Choose Your Plan',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...availablePlans.map((plan) => _buildPlanCard(context, theme, plan)),
          ] else if (isLoading) ...[
            const Center(child: CircularProgressIndicator()),
          ] else ...[
            _buildDefaultPlans(context, theme),
          ],

          const SizedBox(height: 24),

          // Purchase button
          if (selectedPlan != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _purchasePlan(selectedPlan!),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Subscribe for ${selectedPlan!.price}'),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Restore purchases button
          TextButton(
            onPressed: isLoading ? null : _restorePurchases,
            child: const Text('Restore Purchases'),
          ),

          const SizedBox(height: 16),

          // Terms and privacy
          _buildTermsAndPrivacy(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.workspace_premium,
            size: 64,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Unlock Premium Features',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Get unlimited access to advanced AI features and premium content',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPremiumFeatures(BuildContext context, ThemeData theme) {
    final features = [
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'Unlimited AI Conversations',
        'description': 'Chat with Qwen3 without any limits',
      },
      {
        'icon': Icons.priority_high,
        'title': 'Priority Support',
        'description': 'Get faster response times and dedicated support',
      },
      {
        'icon': Icons.psychology,
        'title': 'Advanced AI Models',
        'description': 'Access to the latest and most powerful AI models',
      },
      {
        'icon': Icons.block,
        'title': 'No Advertisements',
        'description': 'Enjoy an ad-free experience',
      },
      {
        'icon': Icons.download,
        'title': 'Export Conversations',
        'description': 'Save and export your chat history',
      },
      {
        'icon': Icons.cloud_sync,
        'title': 'Cloud Sync',
        'description': 'Sync your data across all devices',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => _buildFeatureItem(context, theme, feature)),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, ThemeData theme, Map<String, dynamic> feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  feature['description'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, ThemeData theme, SubscriptionPlan plan) {
    final isSelected = selectedPlan?.id == plan.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = plan;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Radio<SubscriptionPlan>(
                    value: plan,
                    groupValue: selectedPlan,
                    onChanged: (value) {
                      setState(() {
                        selectedPlan = value;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          plan.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (plan.originalPrice != null) ...[
                        Text(
                          plan.originalPrice!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                      Text(
                        plan.price,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '/${plan.period}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (plan.isPopular) ...[
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'POPULAR',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            if (plan.discount != null) ...[
              Positioned(
                top: plan.isPopular ? 28 : 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topRight: plan.isPopular ? const Radius.circular(0) : const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    plan.discount!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPlans(BuildContext context, ThemeData theme) {
    // Default plans when RevenueCat offerings are not available
    final defaultPlans = [
      const SubscriptionPlan(
        id: 'monthly',
        title: 'Monthly Premium',
        description: 'Premium features for one month',
        price: '\$9.99',
        period: 'month',
        features: [],
        productId: 'premium_monthly',
        entitlementId: 'premium',
      ),
      const SubscriptionPlan(
        id: 'yearly',
        title: 'Yearly Premium',
        description: 'Premium features for one year',
        price: '\$99.99',
        period: 'year',
        features: [],
        isPopular: true,
        isRecommended: true,
        originalPrice: '\$119.88',
        discount: '17% OFF',
        productId: 'premium_yearly',
        entitlementId: 'premium',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...defaultPlans.map((plan) => _buildPlanCard(context, theme, plan)),
      ],
    );
  }

  Widget _buildTermsAndPrivacy(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Text(
          'By subscribing, you agree to our Terms of Service and Privacy Policy. '
          'Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // TODO: Open Terms of Service
              },
              child: const Text('Terms of Service'),
            ),
            Text(
              ' • ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Open Privacy Policy
              },
              child: const Text('Privacy Policy'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _purchasePlan(SubscriptionPlan plan) async {
    try {
      final result = await ref.read(subscriptionOperationsProvider).purchasePlan(plan);

      if (mounted) {
        if (result.success) {
          _showSuccessDialog(context, plan);
        } else {
          _showErrorDialog(context, result.error ?? 'Purchase failed');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _restorePurchases() async {
    try {
      final result = await ref.read(subscriptionOperationsProvider).restorePurchases();

      if (mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchases restored successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          _showErrorDialog(context, result.error ?? 'Failed to restore purchases');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  void _showSuccessDialog(BuildContext context, SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to Premium!'),
        content: Text('You have successfully subscribed to ${plan.title}. Enjoy all premium features!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Failed'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showManageSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Subscription'),
        content: const Text(
          'To manage your subscription, please visit the App Store (iOS) or Google Play Store (Android) settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
