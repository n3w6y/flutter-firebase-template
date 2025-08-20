// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
    SubscriptionPlan(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      period: json['period'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isPopular: json['isPopular'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      originalPrice: json['originalPrice'] as String?,
      discount: json['discount'] as String?,
      productId: json['productId'] as String,
      entitlementId: json['entitlementId'] as String,
    );

Map<String, dynamic> _$SubscriptionPlanToJson(SubscriptionPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'period': instance.period,
      'features': instance.features,
      'isPopular': instance.isPopular,
      'isRecommended': instance.isRecommended,
      'originalPrice': instance.originalPrice,
      'discount': instance.discount,
      'productId': instance.productId,
      'entitlementId': instance.entitlementId,
    };

SubscriptionStatus _$SubscriptionStatusFromJson(Map<String, dynamic> json) =>
    SubscriptionStatus(
      isActive: json['isActive'] as bool,
      isPremium: json['isPremium'] as bool,
      activeEntitlement: json['activeEntitlement'] as String?,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      productId: json['productId'] as String?,
      willRenew: json['willRenew'] as bool? ?? false,
      isInGracePeriod: json['isInGracePeriod'] as bool? ?? false,
      store: json['store'] as String?,
    );

Map<String, dynamic> _$SubscriptionStatusToJson(SubscriptionStatus instance) =>
    <String, dynamic>{
      'isActive': instance.isActive,
      'isPremium': instance.isPremium,
      'activeEntitlement': instance.activeEntitlement,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'productId': instance.productId,
      'willRenew': instance.willRenew,
      'isInGracePeriod': instance.isInGracePeriod,
      'store': instance.store,
    };

PurchaseResult _$PurchaseResultFromJson(Map<String, dynamic> json) =>
    PurchaseResult(
      success: json['success'] as bool,
      error: json['error'] as String?,
      productId: json['productId'] as String?,
      transactionId: json['transactionId'] as String?,
      subscriptionStatus: json['subscriptionStatus'] == null
          ? null
          : SubscriptionStatus.fromJson(
              json['subscriptionStatus'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PurchaseResultToJson(PurchaseResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'productId': instance.productId,
      'transactionId': instance.transactionId,
      'subscriptionStatus': instance.subscriptionStatus,
    };
