import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_drawer.dart';
import 'app_bottom_navigation.dart';
import '../../providers/navigation_provider.dart';

/// Responsive navigation wrapper that adapts to screen size
class ResponsiveNavigation extends ConsumerWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showAppBar;
  final bool showBottomNavigation;
  final bool showDrawer;
  final PreferredSizeWidget? customAppBar;

  const ResponsiveNavigation({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showAppBar = true,
    this.showBottomNavigation = true,
    this.showDrawer = true,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width > 768;
    final isDesktop = mediaQuery.size.width > 1200;

    // Update current navigation based on current route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != null) {
        ref.read(currentNavigationProvider.notifier).state = currentRoute;
      }
    });

    if (isDesktop) {
      return _buildDesktopLayout(context, ref, theme);
    } else if (isTablet) {
      return _buildTabletLayout(context, ref, theme);
    } else {
      return _buildMobileLayout(context, ref, theme);
    }
  }

  /// Desktop layout with permanent navigation rail
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Scaffold(
      body: Row(
        children: [
          // Permanent navigation rail
          if (showDrawer) _buildNavigationRail(context, ref, theme),
          
          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar
                if (showAppBar) _buildAppBar(context, theme, false),
                
                // Content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  /// Tablet layout with collapsible drawer
  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Scaffold(
      appBar: showAppBar ? (customAppBar ?? _buildAppBar(context, theme, true)) : null,
      drawer: showDrawer ? const AppDrawer() : null,
      body: child,
      bottomNavigationBar: showBottomNavigation ? const AppBottomNavigation() : null,
      floatingActionButton: floatingActionButton,
    );
  }

  /// Mobile layout with drawer and bottom navigation
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Scaffold(
      appBar: showAppBar ? (customAppBar ?? _buildAppBar(context, theme, true)) : null,
      drawer: showDrawer ? const AppDrawer() : null,
      body: child,
      bottomNavigationBar: showBottomNavigation ? const AppBottomNavigation() : null,
      floatingActionButton: floatingActionButton,
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme, bool showMenuButton) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: showMenuButton && showDrawer,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  /// Build navigation rail for desktop
  Widget _buildNavigationRail(BuildContext context, WidgetRef ref, ThemeData theme) {
    final sections = ref.watch(drawerNavigationSectionsProvider);
    final currentRoute = ref.watch(currentNavigationProvider);
    
    // Flatten all navigation items
    final allItems = sections.expand((section) => section.items).toList();
    final currentIndex = allItems.indexWhere((item) => item.route == currentRoute);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: const AppDrawer(),
    );
  }
}

/// Navigation layout builder for different screen sizes
class NavigationLayoutBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, bool isDesktop, bool isTablet) builder;

  const NavigationLayoutBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width > 768;
    final isDesktop = mediaQuery.size.width > 1200;

    return builder(context, isDesktop, isTablet);
  }
}

/// Navigation breakpoints
class NavigationBreakpoints {
  static const double mobile = 768;
  static const double tablet = 1200;
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }
}
