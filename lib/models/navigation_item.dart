import 'package:flutter/material.dart';

/// Navigation item model for menu items
class NavigationItem {
  final String id;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;
  final bool requiresAuth;
  final bool showInBottomNav;
  final bool showInDrawer;
  final List<NavigationItem>? subItems;
  final String? badge;
  final Color? badgeColor;

  const NavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
    this.requiresAuth = false,
    this.showInBottomNav = true,
    this.showInDrawer = true,
    this.subItems,
    this.badge,
    this.badgeColor,
  });

  /// Check if this item should be visible based on authentication status
  bool isVisible(bool isAuthenticated) {
    if (requiresAuth && !isAuthenticated) {
      return false;
    }
    return true;
  }

  /// Get the appropriate icon based on selection state
  IconData getIcon(bool isSelected) {
    if (isSelected && activeIcon != null) {
      return activeIcon!;
    }
    return icon;
  }

  NavigationItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    IconData? activeIcon,
    String? route,
    bool? requiresAuth,
    bool? showInBottomNav,
    bool? showInDrawer,
    List<NavigationItem>? subItems,
    String? badge,
    Color? badgeColor,
  }) {
    return NavigationItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      route: route ?? this.route,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      showInBottomNav: showInBottomNav ?? this.showInBottomNav,
      showInDrawer: showInDrawer ?? this.showInDrawer,
      subItems: subItems ?? this.subItems,
      badge: badge ?? this.badge,
      badgeColor: badgeColor ?? this.badgeColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Navigation section for grouping items
class NavigationSection {
  final String? title;
  final List<NavigationItem> items;
  final bool requiresAuth;

  const NavigationSection({
    this.title,
    required this.items,
    this.requiresAuth = false,
  });

  /// Get visible items based on authentication status
  List<NavigationItem> getVisibleItems(bool isAuthenticated) {
    if (requiresAuth && !isAuthenticated) {
      return [];
    }
    return items.where((item) => item.isVisible(isAuthenticated)).toList();
  }
}
