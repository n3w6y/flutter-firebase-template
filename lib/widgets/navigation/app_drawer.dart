import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/navigation_item.dart';
import '../../models/user_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_constants.dart';

/// Modern navigation drawer with smooth animations
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final sections = ref.watch(drawerNavigationSectionsProvider);
    final currentRoute = ref.watch(currentNavigationProvider);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header section
            _buildHeader(context, theme, user),
            
            // Navigation sections
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ...sections.map((section) => _buildSection(
                    context,
                    ref,
                    theme,
                    section,
                    currentRoute,
                  )),
                  
                  // Logout section for authenticated users
                  if (user != null) ...[
                    const Divider(height: 32),
                    _buildLogoutTile(context, ref, theme),
                  ],
                ],
              ),
            ),
            
            // Footer
            _buildFooter(context, theme),
          ],
        ),
      ),
    );
  }

  /// Build drawer header
  Widget _buildHeader(BuildContext context, ThemeData theme, UserModel? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App logo/icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 32,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // User info or app name
          if (user != null) ...[
            Text(
              user.displayName ?? 'User',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (user.email != null)
              Text(
                user.email!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
          ] else ...[
            Text(
              AppConstants.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'AI-Powered Assistant',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build navigation section
  Widget _buildSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    NavigationSection section,
    String currentRoute,
  ) {
    if (section.items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        if (section.title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              section.title!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        
        // Section items
        ...section.items.map((item) => _buildNavigationTile(
          context,
          ref,
          theme,
          item,
          currentRoute == item.route,
        )),
      ],
    );
  }

  /// Build navigation tile
  Widget _buildNavigationTile(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    NavigationItem item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(
          item.getIcon(isSelected),
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        title: Text(
          item.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: item.badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.badgeColor ?? theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.badge!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        selected: isSelected,
        selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          NavigationHelper.navigateTo(context, ref, item.route);
          Navigator.of(context).pop(); // Close drawer
        },
      ),
    );
  }

  /// Build logout tile
  Widget _buildLogoutTile(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: theme.colorScheme.error,
        ),
        title: Text(
          'Sign Out',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () async {
          Navigator.of(context).pop(); // Close drawer first
          
          final authNotifier = ref.read(authNotifierProvider.notifier);
          final result = await authNotifier.signOut();
          
          if (context.mounted && result.success) {
            // Stay on current screen after logout
            // The navigation will update automatically based on auth state
          }
        },
      ),
    );
  }

  /// Build footer
  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Version 1.0.0',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
