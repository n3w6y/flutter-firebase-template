# 🛒 RevenueCat In-App Purchase Integration Guide

This comprehensive guide will walk you through setting up RevenueCat for in-app purchases in your Flutter AI template.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [RevenueCat Account Setup](#revenuecat-account-setup)
4. [App Store Configuration](#app-store-configuration)
5. [Flutter App Configuration](#flutter-app-configuration)
6. [Testing](#testing)
7. [Production Deployment](#production-deployment)
8. [Troubleshooting](#troubleshooting)

## 🎯 Overview

Our Flutter template includes a complete RevenueCat integration with:

- **Professional subscription screen** with plan selection
- **Premium feature management** and access control
- **Cross-platform support** (iOS & Android)
- **Demo mode** for testing without API keys
- **Comprehensive error handling** and user feedback
- **State management** with Riverpod providers

### Features Included:
- ✅ Monthly and yearly subscription plans
- ✅ Premium badge and status indicators
- ✅ Subscription management and restoration
- ✅ Premium content gating
- ✅ Revenue analytics integration
- ✅ Cross-device subscription sync

## 📚 Prerequisites

Before starting, ensure you have:

- [ ] **Flutter development environment** set up
- [ ] **Google Play Console** account (for Android)
- [ ] **Apple Developer** account (for iOS)
- [ ] **RevenueCat** account (free tier available)
- [ ] **Firebase project** configured (already included in template)

## 🚀 RevenueCat Account Setup

### Step 1: Create RevenueCat Account

1. **Visit RevenueCat:**
   - Go to [https://www.revenuecat.com](https://www.revenuecat.com)
   - Click "Get Started Free"
   - Sign up with your email

2. **Create New Project:**
   - Click "Create New Project"
   - Enter project name: `Flutter AI Template`
   - Select your primary platform

3. **Get API Key:**
   - Navigate to **Project Settings** → **API Keys**
   - Copy your **Public API Key** (starts with `sk_`)
   - Keep this key secure and private

### Step 2: Configure Your App

1. **Add App to RevenueCat:**
   - Go to **Project Settings** → **Apps**
   - Click "Add App"
   - Enter your app details:
     - **App Name:** Your app name
     - **Bundle ID (iOS):** `com.yourcompany.yourapp`
     - **Package Name (Android):** `com.yourcompany.yourapp`

2. **Platform Configuration:**
   - **For iOS:** Connect to App Store Connect
   - **For Android:** Connect to Google Play Console
   - Follow RevenueCat's guided setup

## 🏪 App Store Configuration

### Google Play Console Setup

1. **Create App in Google Play Console:**
   ```bash
   # Navigate to Google Play Console
   # Create new app or select existing app
   # Go to Monetization → Products → In-app products
   ```

2. **Create In-App Products:**
   ```
   Product ID: premium_monthly
   Product Type: Subscription
   Name: Monthly Premium
   Description: Premium features for one month
   Price: $9.99/month
   
   Product ID: premium_yearly
   Product Type: Subscription  
   Name: Yearly Premium
   Description: Premium features for one year
   Price: $99.99/year
   ```

3. **Configure Subscription Groups:**
   - Create subscription group: "Premium Subscriptions"
   - Add both products to the group
   - Set upgrade/downgrade paths

### Apple App Store Connect Setup

1. **Create App in App Store Connect:**
   ```bash
   # Navigate to App Store Connect
   # Create new app or select existing app
   # Go to Features → In-App Purchases
   ```

2. **Create Auto-Renewable Subscriptions:**
   ```
   Product ID: premium_monthly
   Reference Name: Monthly Premium
   Subscription Group: Premium Subscriptions
   Price: $9.99/month
   
   Product ID: premium_yearly
   Reference Name: Yearly Premium
   Subscription Group: Premium Subscriptions
   Price: $99.99/year
   ```

3. **Configure Subscription Details:**
   - Add localized descriptions
   - Set subscription duration
   - Configure pricing tiers

## ⚙️ Flutter App Configuration

### Step 1: Add API Key

1. **Update Configuration:**
   ```dart
   // lib/config/api_config.dart
   static const String revenueCatApiKey = 'your_revenuecat_api_key_here';
   ```

2. **Verify Configuration:**
   ```dart
   // The app will automatically validate the API key
   // Check console for initialization messages
   ```

### Step 2: Configure Products (Optional)

The template includes default product configurations, but you can customize them:

```dart
// lib/services/revenue_cat_service.dart
// Update _getDefaultPlans() method with your product IDs and pricing
```

### Step 3: Customize Premium Features

1. **Add Premium Features:**
   ```dart
   // lib/widgets/subscription/premium_feature_widget.dart
   // Customize the premium features list
   
   const features = [
     'Unlimited AI conversations',
     'Priority support',
     'Advanced AI models',
     'No advertisements',
     'Export conversations',
     'Your custom feature here',
   ];
   ```

2. **Implement Feature Gating:**
   ```dart
   // Example: Gate a feature behind premium
   Consumer(
     builder: (context, ref, child) {
       final isPremium = ref.watch(isPremiumProvider);
       
       if (!isPremium) {
         return PremiumFeatureWidget(
           featureName: 'Advanced AI Models',
           description: 'Access to GPT-4 and other premium models',
           child: YourPremiumContent(),
         );
       }
       
       return YourPremiumContent();
     },
   )
   ```

## 🧪 Testing

### Demo Mode Testing (No API Key Required)

1. **Test UI Components:**
   ```bash
   # Run the app
   flutter run
   
   # Navigate to Premium tab
   # Test subscription screen UI
   # Verify premium feature widgets
   ```

2. **Test Purchase Flow:**
   - Tap on subscription plans
   - Test purchase button (simulated)
   - Verify success/error dialogs

### Sandbox Testing (With API Key)

1. **iOS Sandbox Testing:**
   ```bash
   # Create sandbox test accounts in App Store Connect
   # Sign out of App Store on device
   # Install app and test purchases
   ```

2. **Android Testing:**
   ```bash
   # Add test accounts in Google Play Console
   # Install app via internal testing track
   # Test purchases with test accounts
   ```

### Test Scenarios:

- [ ] **Successful purchase** flow
- [ ] **Cancelled purchase** handling
- [ ] **Restore purchases** functionality
- [ ] **Subscription status** updates
- [ ] **Premium feature** access
- [ ] **Cross-device** sync

## 🚀 Production Deployment

### Step 1: Final Configuration

1. **Verify API Keys:**
   ```dart
   // Ensure production RevenueCat API key is set
   // Remove any debug/test configurations
   ```

2. **Update App Metadata:**
   ```yaml
   # pubspec.yaml
   version: 1.0.0+1
   
   # Update app name, description, etc.
   ```

### Step 2: Store Submission

1. **Google Play Store:**
   ```bash
   # Build release APK
   flutter build apk --release
   
   # Or build App Bundle (recommended)
   flutter build appbundle --release
   
   # Upload to Google Play Console
   # Complete store listing
   # Submit for review
   ```

2. **Apple App Store:**
   ```bash
   # Build iOS release
   flutter build ios --release
   
   # Archive in Xcode
   # Upload to App Store Connect
   # Complete app information
   # Submit for review
   ```

### Step 3: RevenueCat Production Setup

1. **Configure Webhooks:**
   - Set up server-to-server notifications
   - Configure webhook endpoints
   - Test webhook delivery

2. **Set Up Analytics:**
   - Configure revenue tracking
   - Set up cohort analysis
   - Monitor subscription metrics

## 🔧 Troubleshooting

### Common Issues:

#### 1. "RevenueCat not initialized" Error
```dart
// Solution: Ensure API key is correctly set
static const String revenueCatApiKey = 'your_actual_key_here';
```

#### 2. Products Not Loading
```bash
# Check:
# - Product IDs match between stores and RevenueCat
# - Products are active in store consoles
# - RevenueCat offerings are configured
```

#### 3. Purchase Failures
```bash
# Verify:
# - App is signed with correct certificates
# - Test accounts are properly configured
# - Billing permissions are added to AndroidManifest.xml
```

#### 4. Subscription Status Not Updating
```dart
// Force refresh subscription status
await ref.read(subscriptionOperationsProvider).refreshStatus();
```

### Debug Commands:

```bash
# Check RevenueCat logs
flutter logs | grep RevenueCat

# Verify product configuration
# Check RevenueCat dashboard for offering status

# Test API key validation
# Look for initialization success messages
```

### Support Resources:

- **RevenueCat Documentation:** [docs.revenuecat.com](https://docs.revenuecat.com)
- **Flutter Plugin Docs:** [pub.dev/packages/purchases_flutter](https://pub.dev/packages/purchases_flutter)
- **Community Support:** RevenueCat Discord/Slack
- **Template Issues:** GitHub repository issues

## 📊 Analytics & Monitoring

### RevenueCat Dashboard:

1. **Revenue Metrics:**
   - Monthly Recurring Revenue (MRR)
   - Annual Recurring Revenue (ARR)
   - Customer Lifetime Value (LTV)

2. **Subscription Analytics:**
   - Conversion rates
   - Churn analysis
   - Cohort performance

3. **A/B Testing:**
   - Test different pricing strategies
   - Optimize subscription flows
   - Measure feature impact

### Custom Analytics:

```dart
// Track custom events
await ref.read(subscriptionOperationsProvider).trackEvent(
  'premium_feature_accessed',
  properties: {'feature': 'advanced_ai'},
);
```

## 🎯 Best Practices

### 1. User Experience:
- **Clear value proposition** for premium features
- **Smooth onboarding** flow
- **Transparent pricing** and terms
- **Easy cancellation** process

### 2. Technical:
- **Graceful error handling** for network issues
- **Offline support** for premium status
- **Secure API key** management
- **Regular testing** of purchase flows

### 3. Business:
- **Monitor key metrics** regularly
- **A/B test** pricing and features
- **Respond to user feedback** quickly
- **Keep features** valuable and updated

---

## 🎉 Congratulations!

You now have a complete RevenueCat integration in your Flutter AI template! Your app can:

- ✅ **Accept subscriptions** on both iOS and Android
- ✅ **Manage premium features** automatically
- ✅ **Track revenue** and user analytics
- ✅ **Handle edge cases** gracefully
- ✅ **Scale** with your business growth

For additional support or questions, refer to the troubleshooting section or reach out to the RevenueCat community.

**Happy monetizing!** 🚀💰
