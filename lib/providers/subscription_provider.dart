import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subscription_models.dart';
import '../services/revenue_cat_service.dart';

/// Subscription state
@immutable
class SubscriptionState {
  final SubscriptionStatus status;
  final List<SubscriptionPlan> availablePlans;
  final bool isLoading;
  final String? error;
  final bool isInitialized;

  const SubscriptionState({
    required this.status,
    required this.availablePlans,
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<SubscriptionPlan>? availablePlans,
    bool? isLoading,
    String? error,
    bool? isInitialized,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      availablePlans: availablePlans ?? this.availablePlans,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  /// Create initial state
  factory SubscriptionState.initial() {
    return SubscriptionState(
      status: SubscriptionStatus.free(),
      availablePlans: const [],
    );
  }
}

/// Subscription state notifier
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final RevenueCatService _revenueCatService;

  SubscriptionNotifier(this._revenueCatService) : super(SubscriptionState.initial());

  /// Initialize subscription service
  Future<void> initialize({String? userId}) async {
    if (state.isInitialized) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _revenueCatService.initialize(userId: userId);
      
      // Load subscription status and available plans
      await Future.wait([
        _loadSubscriptionStatus(),
        _loadAvailablePlans(),
      ]);

      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load current subscription status
  Future<void> _loadSubscriptionStatus() async {
    try {
      final status = await _revenueCatService.getSubscriptionStatus();
      state = state.copyWith(status: status);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading subscription status: $e');
      }
    }
  }

  /// Load available subscription plans
  Future<void> _loadAvailablePlans() async {
    try {
      final plans = await _revenueCatService.getAvailablePlans();
      state = state.copyWith(availablePlans: plans);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading available plans: $e');
      }
    }
  }

  /// Purchase a subscription plan
  Future<PurchaseResult> purchasePlan(SubscriptionPlan plan) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _revenueCatService.purchasePlan(plan);
      
      if (result.success && result.subscriptionStatus != null) {
        state = state.copyWith(
          status: result.subscriptionStatus!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return PurchaseResult.error(e.toString());
    }
  }

  /// Restore purchases
  Future<PurchaseResult> restorePurchases() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _revenueCatService.restorePurchases();
      
      if (result.success && result.subscriptionStatus != null) {
        state = state.copyWith(
          status: result.subscriptionStatus!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return PurchaseResult.error(e.toString());
    }
  }

  /// Refresh subscription status
  Future<void> refreshStatus() async {
    await _loadSubscriptionStatus();
  }

  /// Check if user has specific entitlement
  Future<bool> hasEntitlement(String entitlementId) async {
    return await _revenueCatService.hasEntitlement(entitlementId);
  }

  /// Check if user is premium
  bool get isPremium => state.status.isPremium;

  /// Check if user has active subscription
  bool get hasActiveSubscription => state.status.isActive;

  /// Get active entitlement
  String? get activeEntitlement => state.status.activeEntitlement;

  /// Login user
  Future<void> loginUser(String userId) async {
    try {
      await _revenueCatService.loginUser(userId);
      await refreshStatus();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      await _revenueCatService.logoutUser();
      state = state.copyWith(status: SubscriptionStatus.free());
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// RevenueCat service provider
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService.instance;
});

/// Subscription state provider
final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  final revenueCatService = ref.read(revenueCatServiceProvider);
  return SubscriptionNotifier(revenueCatService);
});

/// Subscription operations provider
final subscriptionOperationsProvider = Provider<SubscriptionNotifier>((ref) {
  return ref.read(subscriptionProvider.notifier);
});

/// Premium status provider
final isPremiumProvider = Provider<bool>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.status.isPremium;
});

/// Active subscription provider
final hasActiveSubscriptionProvider = Provider<bool>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.status.isActive;
});

/// Available plans provider
final availablePlansProvider = Provider<List<SubscriptionPlan>>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.availablePlans;
});

/// Subscription status provider
final subscriptionStatusProvider = Provider<SubscriptionStatus>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.status;
});

/// Subscription loading provider
final subscriptionLoadingProvider = Provider<bool>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.isLoading;
});

/// Subscription error provider
final subscriptionErrorProvider = Provider<String?>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.error;
});
