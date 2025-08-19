import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/navigation_item.dart';
import '../constants/app_constants.dart';
import 'auth_provider.dart';

/// Navigation configuration provider
class NavigationConfig {
  static const List<NavigationSection> sections = [
    // Main navigation section
    NavigationSection(
      items: [
        NavigationItem(
          id: 'home',
          label: 'AI Chat',
          icon: Icons.chat_outlined,
          activeIcon: Icons.chat,
          route: AppConstants.homeRoute,
          showInBottomNav: true,
          showInDrawer: true,
        ),
        NavigationItem(
          id: 'profile',
          label: 'Profile',
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          route: '/profile',
          requiresAuth: true,
          showInBottomNav: true,
          showInDrawer: true,
        ),
        NavigationItem(
          id: 'help',
          label: 'Help',
          icon: Icons.help_outline,
          activeIcon: Icons.help,
          route: '/help',
          showInBottomNav: true,
          showInDrawer: true,
        ),
        NavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings_outlined,
          activeIcon: Icons.settings,
          route: '/settings',
          showInBottomNav: true,
          showInDrawer: true,
        ),
      ],
    ),
    
    // Account section (for drawer only)
    NavigationSection(
      title: 'Account',
      requiresAuth: true,
      items: [
        NavigationItem(
          id: 'edit_profile',
          label: 'Edit Profile',
          icon: Icons.edit_outlined,
          activeIcon: Icons.edit,
          route: '/profile/edit',
          requiresAuth: true,
          showInBottomNav: false,
          showInDrawer: true,
        ),
      ],
    ),
    
    // Authentication section (for unauthenticated users)
    NavigationSection(
      title: 'Get Started',
      items: [
        NavigationItem(
          id: 'login',
          label: 'Sign In',
          icon: Icons.login_outlined,
          activeIcon: Icons.login,
          route: AppConstants.loginRoute,
          showInBottomNav: false,
          showInDrawer: true,
        ),
        NavigationItem(
          id: 'signup',
          label: 'Sign Up',
          icon: Icons.person_add_outlined,
          activeIcon: Icons.person_add,
          route: AppConstants.signupRoute,
          showInBottomNav: false,
          showInDrawer: true,
        ),
      ],
    ),
  ];

  /// Get bottom navigation items based on authentication status
  static List<NavigationItem> getBottomNavItems(bool isAuthenticated) {
    final List<NavigationItem> items = [];
    
    for (final section in sections) {
      final visibleItems = section.getVisibleItems(isAuthenticated);
      items.addAll(visibleItems.where((item) => item.showInBottomNav));
    }
    
    return items;
  }

  /// Get drawer navigation sections based on authentication status
  static List<NavigationSection> getDrawerSections(bool isAuthenticated) {
    return sections
        .map((section) => NavigationSection(
              title: section.title,
              items: section.getVisibleItems(isAuthenticated)
                  .where((item) => item.showInDrawer)
                  .toList(),
              requiresAuth: section.requiresAuth,
            ))
        .where((section) => section.items.isNotEmpty)
        .toList();
  }

  /// Find navigation item by route
  static NavigationItem? findItemByRoute(String route) {
    for (final section in sections) {
      for (final item in section.items) {
        if (item.route == route) {
          return item;
        }
      }
    }
    return null;
  }
}

/// Current navigation state provider
final currentNavigationProvider = StateProvider<String>((ref) {
  return AppConstants.homeRoute; // Default to home
});

/// Provider for bottom navigation items
final bottomNavigationItemsProvider = Provider<List<NavigationItem>>((ref) {
  final user = ref.watch(currentUserProvider);
  final isAuthenticated = user != null;
  return NavigationConfig.getBottomNavItems(isAuthenticated);
});

/// Provider for drawer navigation sections
final drawerNavigationSectionsProvider = Provider<List<NavigationSection>>((ref) {
  final user = ref.watch(currentUserProvider);
  final isAuthenticated = user != null;
  return NavigationConfig.getDrawerSections(isAuthenticated);
});

/// Provider for current navigation item
final currentNavigationItemProvider = Provider<NavigationItem?>((ref) {
  final currentRoute = ref.watch(currentNavigationProvider);
  return NavigationConfig.findItemByRoute(currentRoute);
});

/// Navigation helper methods
class NavigationHelper {
  /// Navigate to a route and update current navigation state
  static void navigateTo(BuildContext context, WidgetRef ref, String route) {
    ref.read(currentNavigationProvider.notifier).state = route;
    context.go(route);
  }

  /// Check if a route is currently active
  static bool isRouteActive(WidgetRef ref, String route) {
    final currentRoute = ref.watch(currentNavigationProvider);
    return currentRoute == route;
  }

  /// Get the index of current route in bottom navigation
  static int getCurrentBottomNavIndex(WidgetRef ref) {
    final currentRoute = ref.watch(currentNavigationProvider);
    final items = ref.watch(bottomNavigationItemsProvider);
    
    for (int i = 0; i < items.length; i++) {
      if (items[i].route == currentRoute) {
        return i;
      }
    }
    return 0; // Default to first item
  }
}
