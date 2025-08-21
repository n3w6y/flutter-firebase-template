# 🔧 Setup with Real Credentials

This guide explains how to configure the Flutter template with your actual API keys and credentials.

## 📋 Prerequisites

1. You have access to the `REAL_CREDENTIALS.md` file (gitignored)
2. You have the necessary accounts (OpenRouter, Firebase, RevenueCat)

## 🔑 Step 1: Configure API Keys

### Option A: Copy from REAL_CREDENTIALS.md
1. Open `REAL_CREDENTIALS.md` (if you have access)
2. Copy the real API keys
3. Replace the demo keys in `lib/config/api_config.dart`

### Option B: Use Your Own Keys
1. Get your OpenRouter API key from [OpenRouter.ai](https://openrouter.ai)
2. Get your RevenueCat API key from [RevenueCat Dashboard](https://app.revenuecat.com)
3. Replace the demo keys in `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Replace these demo keys with your actual keys
  static const String openRouterApiKey = 'sk-or-v1-YOUR_ACTUAL_OPENROUTER_KEY';
  static const String revenueCatApiKey = 'sk_YOUR_ACTUAL_REVENUECAT_KEY';
  static const String firebaseProjectId = 'your-actual-firebase-project-id';
  
  // Update these with your app details
  static const String siteUrl = 'https://your-actual-domain.com';
  static const String siteName = 'Your Actual App Name';
}
```

## 🔥 Step 2: Configure Firebase

### Download Configuration Files
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project (or create a new one)
3. Download configuration files:
   - **Android**: `google-services.json` → place in `android/app/`
   - **iOS**: `GoogleService-Info.plist` → place in `ios/Runner/`

### Update Firebase Options
1. Run: `flutter packages pub run build_runner build`
2. Or manually update `lib/firebase_options.dart` with your project details

## 🧪 Step 3: Test Configuration

### Run Setup Script
```bash
# Linux/Mac
./setup.sh

# Windows
setup.bat
```

### Verify Configuration
```bash
flutter clean
flutter pub get
flutter run
```

## 🚨 Security Reminders

- ✅ Never commit `lib/config/api_config.dart` with real keys
- ✅ Never commit Firebase configuration files
- ✅ Keep `REAL_CREDENTIALS.md` secure and private
- ✅ Use environment variables for production builds

## 🔄 Switching Between Demo and Real Keys

### For Development (Real Keys)
```dart
// lib/config/api_config.dart
static const String openRouterApiKey = 'sk-or-v1-your-real-key';
```

### For Public Repository (Demo Keys)
```dart
// lib/config/api_config.dart
static const String openRouterApiKey = 'sk-or-v1-DEMO_KEY_REPLACE_WITH_YOUR_ACTUAL_OPENROUTER_KEY';
```

## 🏗️ Production Deployment

Use environment variables for production:

```bash
flutter build apk --dart-define=OPENROUTER_API_KEY=sk-or-v1-your-real-key
```

Or use CI/CD secrets for automated deployments.
