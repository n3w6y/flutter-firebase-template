import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../config/api_config.dart';
import '../models/subscription_models.dart';

/// RevenueCat service for handling in-app purchases and subscriptions
class RevenueCatService {
  static RevenueCatService? _instance;
  static RevenueCatService get instance => _instance ??= RevenueCatService._();
  
  RevenueCatService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize RevenueCat SDK
  Future<void> initialize({String? userId}) async {
    try {
      if (_isInitialized) return;

      // Enable debug logs in development
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      // Check if RevenueCat is configured
      if (!ApiConfig.isRevenueCatConfigured) {
        if (kDebugMode) {
          print('RevenueCat API key not configured - running in demo mode');
        }
        _isInitialized = true;
        return;
      }

      // Configure RevenueCat
      PurchasesConfiguration configuration;

      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(ApiConfig.validatedRevenueCatApiKey);
      } else if (Platform.isIOS) {
        configuration = PurchasesConfiguration(ApiConfig.validatedRevenueCatApiKey);
      } else {
        throw UnsupportedError('Platform not supported for RevenueCat');
      }

      // Set user ID if provided
      if (userId != null) {
        configuration = configuration.copyWith(appUserID: userId);
      }

      await Purchases.configure(configuration);
      _isInitialized = true;

      if (kDebugMode) {
        print('RevenueCat initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize RevenueCat: $e');
      }
      rethrow;
    }
  }

  /// Get current subscription status
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Return demo status if RevenueCat is not configured
      if (!ApiConfig.isRevenueCatConfigured) {
        return SubscriptionStatus.free();
      }

      final customerInfo = await Purchases.getCustomerInfo();
      return _parseSubscriptionStatus(customerInfo);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting subscription status: $e');
      }
      return SubscriptionStatus.free();
    }
  }

  /// Get available subscription plans
  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Return demo plans if RevenueCat is not configured
      if (!ApiConfig.isRevenueCatConfigured) {
        return _getDefaultPlans();
      }

      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null) {
        if (kDebugMode) {
          print('No current offering found');
        }
        return _getDefaultPlans();
      }

      final plans = <SubscriptionPlan>[];

      for (final package in currentOffering.availablePackages) {
        final plan = _createPlanFromPackage(package);
        if (plan != null) {
          plans.add(plan);
        }
      }

      return plans.isNotEmpty ? plans : _getDefaultPlans();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting available plans: $e');
      }
      return _getDefaultPlans();
    }
  }

  /// Purchase a subscription plan
  Future<PurchaseResult> purchasePlan(SubscriptionPlan plan) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Return demo success if RevenueCat is not configured
      if (!ApiConfig.isRevenueCatConfigured) {
        if (kDebugMode) {
          print('Demo mode: Simulating successful purchase of ${plan.title}');
        }
        return PurchaseResult.success(
          productId: plan.productId,
          subscriptionStatus: SubscriptionStatus(
            isActive: true,
            isPremium: true,
            activeEntitlement: plan.entitlementId,
            expirationDate: DateTime.now().add(const Duration(days: 30)),
            purchaseDate: DateTime.now(),
            productId: plan.productId,
            willRenew: true,
          ),
        );
      }

      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null) {
        return PurchaseResult.error('No offerings available');
      }

      // Find the package for this plan
      Package? targetPackage;
      for (final package in currentOffering.availablePackages) {
        if (package.storeProduct.identifier == plan.productId) {
          targetPackage = package;
          break;
        }
      }

      if (targetPackage == null) {
        return PurchaseResult.error('Product not found: ${plan.productId}');
      }

      final customerInfo = await Purchases.purchasePackage(targetPackage);
      final subscriptionStatus = _parseSubscriptionStatus(customerInfo);

      return PurchaseResult.success(
        productId: plan.productId,
        subscriptionStatus: subscriptionStatus,
      );
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      String errorMessage = 'Purchase failed';

      switch (errorCode) {
        case PurchasesErrorCode.purchaseCancelledError:
          errorMessage = 'Purchase was cancelled';
          break;
        case PurchasesErrorCode.purchaseNotAllowedError:
          errorMessage = 'Purchase not allowed';
          break;
        case PurchasesErrorCode.purchaseInvalidError:
          errorMessage = 'Purchase invalid';
          break;
        case PurchasesErrorCode.productNotAvailableForPurchaseError:
          errorMessage = 'Product not available for purchase';
          break;
        case PurchasesErrorCode.networkError:
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = e.message ?? 'Unknown purchase error';
      }

      if (kDebugMode) {
        print('Purchase error: $errorMessage');
      }

      return PurchaseResult.error(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected purchase error: $e');
      }
      return PurchaseResult.error('An unexpected error occurred');
    }
  }

  /// Restore purchases
  Future<PurchaseResult> restorePurchases() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final customerInfo = await Purchases.restorePurchases();
      final subscriptionStatus = _parseSubscriptionStatus(customerInfo);

      return PurchaseResult.success(
        productId: 'restored',
        subscriptionStatus: subscriptionStatus,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error restoring purchases: $e');
      }
      return PurchaseResult.error('Failed to restore purchases');
    }
  }

  /// Check if user has specific entitlement
  Future<bool> hasEntitlement(String entitlementId) async {
    try {
      final status = await getSubscriptionStatus();
      return status.isActive && status.activeEntitlement == entitlementId;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking entitlement: $e');
      }
      return false;
    }
  }

  /// Check if user is premium
  Future<bool> isPremium() async {
    try {
      final status = await getSubscriptionStatus();
      return status.isPremium;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking premium status: $e');
      }
      return false;
    }
  }

  /// Login user (for user identification)
  Future<void> loginUser(String userId) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      await Purchases.logIn(userId);
      
      if (kDebugMode) {
        print('User logged in: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in user: $e');
      }
      rethrow;
    }
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      await Purchases.logOut();
      
      if (kDebugMode) {
        print('User logged out');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging out user: $e');
      }
      rethrow;
    }
  }

  /// Parse CustomerInfo to SubscriptionStatus
  SubscriptionStatus _parseSubscriptionStatus(CustomerInfo customerInfo) {
    final entitlements = customerInfo.entitlements.active;
    
    if (entitlements.isEmpty) {
      return SubscriptionStatus.free();
    }

    // Get the first active entitlement
    final activeEntitlement = entitlements.values.first;
    
    return SubscriptionStatus(
      isActive: true,
      isPremium: true,
      activeEntitlement: activeEntitlement.identifier,
      expirationDate: activeEntitlement.expirationDate,
      purchaseDate: activeEntitlement.latestPurchaseDate,
      productId: activeEntitlement.productIdentifier,
      willRenew: activeEntitlement.willRenew,
      isInGracePeriod: activeEntitlement.isActive,
      store: customerInfo.originalAppUserId,
    );
  }

  /// Create SubscriptionPlan from Package
  SubscriptionPlan? _createPlanFromPackage(Package package) {
    final product = package.storeProduct;
    final identifier = package.identifier;
    
    // Determine plan details based on identifier
    String title = 'Premium';
    String period = 'month';
    bool isPopular = false;
    bool isRecommended = false;
    
    switch (identifier) {
      case PackageType.monthly:
        title = 'Monthly Premium';
        period = 'month';
        break;
      case PackageType.annual:
        title = 'Yearly Premium';
        period = 'year';
        isPopular = true;
        isRecommended = true;
        break;
      case PackageType.lifetime:
        title = 'Lifetime Premium';
        period = 'lifetime';
        break;
      default:
        title = 'Premium Plan';
    }

    return SubscriptionPlan(
      id: identifier,
      title: title,
      description: product.description,
      price: product.priceString,
      period: period,
      features: _getPremiumFeatures(),
      isPopular: isPopular,
      isRecommended: isRecommended,
      productId: product.identifier,
      entitlementId: EntitlementConfig.premiumEntitlement,
    );
  }

  /// Get default plans when offerings are not available
  List<SubscriptionPlan> _getDefaultPlans() {
    return [
      const SubscriptionPlan(
        id: 'monthly',
        title: 'Monthly Premium',
        description: 'Premium features for one month',
        price: '\$9.99',
        period: 'month',
        features: [
          'Unlimited AI conversations',
          'Priority support',
          'Advanced AI models',
          'No ads',
          'Export conversations',
        ],
        productId: EntitlementConfig.monthlyProductId,
        entitlementId: EntitlementConfig.premiumEntitlement,
      ),
      const SubscriptionPlan(
        id: 'yearly',
        title: 'Yearly Premium',
        description: 'Premium features for one year',
        price: '\$99.99',
        period: 'year',
        features: [
          'Unlimited AI conversations',
          'Priority support',
          'Advanced AI models',
          'No ads',
          'Export conversations',
          'Save 17% vs monthly',
        ],
        isPopular: true,
        isRecommended: true,
        originalPrice: '\$119.88',
        discount: '17% OFF',
        productId: EntitlementConfig.yearlyProductId,
        entitlementId: EntitlementConfig.premiumEntitlement,
      ),
    ];
  }

  /// Get premium features list
  List<String> _getPremiumFeatures() {
    return [
      'Unlimited AI conversations',
      'Priority support',
      'Advanced AI models',
      'No ads',
      'Export conversations',
      'Cloud sync',
      'Premium themes',
    ];
  }
}
