import 'package:json_annotation/json_annotation.dart';

part 'subscription_models.g.dart';

/// Subscription plan model
@JsonSerializable()
class SubscriptionPlan {
  final String id;
  final String title;
  final String description;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final bool isRecommended;
  final String? originalPrice;
  final String? discount;
  final String productId;
  final String entitlementId;

  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
    this.isRecommended = false,
    this.originalPrice,
    this.discount,
    required this.productId,
    required this.entitlementId,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => 
      _$SubscriptionPlanFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);

  SubscriptionPlan copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    String? period,
    List<String>? features,
    bool? isPopular,
    bool? isRecommended,
    String? originalPrice,
    String? discount,
    String? productId,
    String? entitlementId,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      period: period ?? this.period,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      isRecommended: isRecommended ?? this.isRecommended,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      productId: productId ?? this.productId,
      entitlementId: entitlementId ?? this.entitlementId,
    );
  }
}

/// Subscription status model
@JsonSerializable()
class SubscriptionStatus {
  final bool isActive;
  final bool isPremium;
  final String? activeEntitlement;
  final DateTime? expirationDate;
  final DateTime? purchaseDate;
  final String? productId;
  final bool willRenew;
  final bool isInGracePeriod;
  final String? store;

  const SubscriptionStatus({
    required this.isActive,
    required this.isPremium,
    this.activeEntitlement,
    this.expirationDate,
    this.purchaseDate,
    this.productId,
    this.willRenew = false,
    this.isInGracePeriod = false,
    this.store,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) => 
      _$SubscriptionStatusFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionStatusToJson(this);

  /// Create a default free status
  factory SubscriptionStatus.free() {
    return const SubscriptionStatus(
      isActive: false,
      isPremium: false,
    );
  }

  SubscriptionStatus copyWith({
    bool? isActive,
    bool? isPremium,
    String? activeEntitlement,
    DateTime? expirationDate,
    DateTime? purchaseDate,
    String? productId,
    bool? willRenew,
    bool? isInGracePeriod,
    String? store,
  }) {
    return SubscriptionStatus(
      isActive: isActive ?? this.isActive,
      isPremium: isPremium ?? this.isPremium,
      activeEntitlement: activeEntitlement ?? this.activeEntitlement,
      expirationDate: expirationDate ?? this.expirationDate,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      productId: productId ?? this.productId,
      willRenew: willRenew ?? this.willRenew,
      isInGracePeriod: isInGracePeriod ?? this.isInGracePeriod,
      store: store ?? this.store,
    );
  }
}

/// Purchase result model
@JsonSerializable()
class PurchaseResult {
  final bool success;
  final String? error;
  final String? productId;
  final String? transactionId;
  final SubscriptionStatus? subscriptionStatus;

  const PurchaseResult({
    required this.success,
    this.error,
    this.productId,
    this.transactionId,
    this.subscriptionStatus,
  });

  factory PurchaseResult.fromJson(Map<String, dynamic> json) => 
      _$PurchaseResultFromJson(json);
  
  Map<String, dynamic> toJson() => _$PurchaseResultToJson(this);

  /// Create a success result
  factory PurchaseResult.success({
    required String productId,
    String? transactionId,
    SubscriptionStatus? subscriptionStatus,
  }) {
    return PurchaseResult(
      success: true,
      productId: productId,
      transactionId: transactionId,
      subscriptionStatus: subscriptionStatus,
    );
  }

  /// Create an error result
  factory PurchaseResult.error(String error) {
    return PurchaseResult(
      success: false,
      error: error,
    );
  }
}

/// Entitlement configuration
class EntitlementConfig {
  static const String premiumEntitlement = 'premium';
  static const String proEntitlement = 'pro';
  
  // Product IDs (these should match your App Store Connect / Google Play Console)
  static const String monthlyProductId = 'premium_monthly';
  static const String yearlyProductId = 'premium_yearly';
  static const String lifetimeProductId = 'premium_lifetime';
  
  // Offering IDs
  static const String defaultOffering = 'default';
  
  /// Get all available entitlements
  static List<String> get allEntitlements => [
    premiumEntitlement,
    proEntitlement,
  ];
  
  /// Get all product IDs
  static List<String> get allProductIds => [
    monthlyProductId,
    yearlyProductId,
    lifetimeProductId,
  ];
}
