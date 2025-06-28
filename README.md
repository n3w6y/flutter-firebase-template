# 🚀 Flutter AI Template

A comprehensive Flutter template for building AI-powered mobile applications with Firebase backend, featuring authentication, real-time chat, and flexible data storage.

## ✨ **Features**

### 🎨 **User Experience**
- **Professional Splash Screen** with customizable branding
- **Interactive Onboarding** with smooth animations
- **Material Design 3** with light/dark theme support
- **Responsive Design** that works on all screen sizes

### 🔐 **Authentication**
- **Firebase Authentication** with email/password
- **Google Sign-In** integration
- **Email verification** and password reset
- **User profile management** with photo support

### 🤖 **AI Integration**
- **OpenRouter API** with multiple AI models
- **DeepSeek R1** for advanced reasoning
- **Real-time chat interface** with typing indicators
- **Message persistence** and conversation management

### 🗄️ **Database**
- **Firestore Database** with offline support
- **Real-time synchronization** across devices
- **Flexible repository pattern** for any data type
- **User-based security** with comprehensive rules

### 🏗️ **Architecture**
- **Clean Architecture** with separation of concerns
- **Riverpod State Management** for reactive UI
- **Repository Pattern** for data access
- **Comprehensive error handling** and loading states

## 📱 **Screenshots**

| Splash Screen | Onboarding | Authentication | AI Chat |
|---------------|------------|----------------|---------|
| ![Splash](docs/images/splash.png) | ![Onboarding](docs/images/onboarding.png) | ![Auth](docs/images/auth.png) | ![Chat](docs/images/chat.png) |

## 🚀 **Quick Start**

### **Prerequisites**
- Flutter SDK 3.24.0+
- Android Studio / VS Code
- Firebase account
- OpenRouter account (for AI features)

### **Installation**
```bash
# Clone the repository
git clone https://github.com/yourusername/flutter-ai-template.git
cd flutter-ai-template

# Install dependencies
flutter pub get

# Generate necessary files
flutter packages pub run build_runner build
```

### **Configuration**
1. **Firebase Setup**: Follow [Firebase Auth Guide](docs/FIREBASE_AUTH_GUIDE.md)
2. **AI Integration**: Follow [AI Integration Guide](docs/AI_INTEGRATION_GUIDE.md)
3. **Customization**: Follow [Complete Setup Guide](docs/COMPLETE_SETUP_GUIDE.md)

### **Run the App**
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Build APK
flutter build apk --release
```

## 📚 **Documentation**

### **Setup Guides**
- 📖 [**Complete Setup Guide**](docs/COMPLETE_SETUP_GUIDE.md) - Comprehensive setup instructions
- 🎨 [**Splash Screen Guide**](docs/SPLASH_SCREEN_GUIDE.md) - Customize splash screen and branding
- 🎯 [**Onboarding Guide**](docs/ONBOARDING_GUIDE.md) - Configure first-time user experience
- 🔐 [**Firebase Auth Guide**](docs/FIREBASE_AUTH_GUIDE.md) - Authentication setup and customization
- 🤖 [**AI Integration Guide**](docs/AI_INTEGRATION_GUIDE.md) - OpenRouter API and chat features
- 🗄️ [**Firestore Integration**](docs/FIRESTORE_INTEGRATION.md) - Database setup and usage
- 🔧 [**Firestore Setup**](docs/FIRESTORE_SETUP.md) - Quick database configuration

### **Technical Documentation**
- 📚 [**Code Documentation**](docs/CODE_DOCUMENTATION.md) - Architecture and code explanations
- 🏗️ [**Architecture Overview**](docs/ARCHITECTURE.md) - System design and patterns
- 🧪 [**Testing Guide**](docs/TESTING.md) - Testing strategies and examples

## 🎯 **Customization**

### **Branding**
```dart
// Update app colors in lib/utils/app_theme.dart
static const Color primaryColor = Color(0xFF6366F1);     // Your brand color
static const Color secondaryColor = Color(0xFF8B5CF6);   // Secondary color

// Update app name in pubspec.yaml
name: your_app_name
description: Your app description
```

### **Splash Screen**
```yaml
# Update splash configuration in pubspec.yaml
flutter_native_splash:
  color: "#FFFFFF"                    # Background color
  image: assets/splash/your_logo.png  # Your logo (512x512px)
```

### **AI Model**
```dart
// Change AI model in lib/services/openrouter_service.dart
static const String _defaultModel = 'deepseek/deepseek-r1-0528';  // Your preferred model
static const String _apiKey = 'your-openrouter-api-key';          // Your API key
```

## 🔧 **Available AI Models**

| Model | Description | Cost/1K tokens | Best for |
|-------|-------------|----------------|----------|
| `deepseek/deepseek-r1-0528` | Advanced reasoning | $0.14 | Complex analysis, coding |
| `openai/gpt-4o` | OpenAI's latest | $5.00 | General conversation |
| `openai/gpt-3.5-turbo` | Fast & efficient | $0.50 | Quick responses |
| `anthropic/claude-3-haiku` | Anthropic's model | $0.25 | Creative writing |

## 🏗️ **Project Structure**

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App configuration
├── constants/                # App-wide constants
│   └── app_constants.dart
├── models/                   # Data models
│   ├── chat_message.dart
│   ├── conversation.dart
│   ├── user_model.dart
│   └── openrouter_models.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── openrouter_service.dart
│   ├── firestore_service.dart
│   └── onboarding_service.dart
├── repositories/             # Data access layer
│   ├── base_repository.dart
│   └── chat_repository.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── chat_provider.dart
│   └── onboarding_provider.dart
├── screens/                  # UI screens
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   └── home/
├── widgets/                  # Reusable components
└── utils/                    # Utilities
    ├── app_router.dart
    └── app_theme.dart

assets/
├── images/                   # Image assets
│   ├── onboarding_1.png     # 300x300px
│   ├── onboarding_2.png     # 300x300px
│   └── onboarding_3.png     # 300x300px
└── splash/                   # Splash screen assets
    └── splash_logo.png       # 512x512px

docs/                         # Documentation
├── COMPLETE_SETUP_GUIDE.md
├── SPLASH_SCREEN_GUIDE.md
├── ONBOARDING_GUIDE.md
├── FIREBASE_AUTH_GUIDE.md
├── AI_INTEGRATION_GUIDE.md
├── FIRESTORE_INTEGRATION.md
└── CODE_DOCUMENTATION.md
```

## 🧪 **Testing**

### **Run Tests**
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

### **Test Coverage**
- ✅ Authentication flows
- ✅ AI chat functionality
- ✅ Database operations
- ✅ UI components
- ✅ Error handling

## 🚀 **Deployment**

### **Android**
```bash
# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

### **Firebase Setup for Production**
1. Create production Firebase project
2. Update `google-services.json`
3. Configure Firestore security rules
4. Set up authentication providers
5. Deploy Firestore rules: `firebase deploy --only firestore:rules`

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Setup**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Submit a pull request

### **Code Style**
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Add documentation for public APIs
- Write tests for new features

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- **Flutter Team** for the amazing framework
- **Firebase** for backend services
- **OpenRouter** for AI API access
- **Riverpod** for state management
- **Material Design** for UI guidelines

## 📞 **Support**

### **Documentation**
- 📖 Check the [docs/](docs/) folder for detailed guides
- 🔍 Search existing [GitHub Issues](https://github.com/yourusername/flutter-ai-template/issues)
- 💬 Join our [Discord Community](https://discord.gg/your-invite)

### **Getting Help**
1. **Read the documentation** in the `docs/` folder
2. **Check the code comments** for implementation details
3. **Create an issue** if you find a bug
4. **Start a discussion** for feature requests

### **Common Issues**
- **Build errors**: Run `flutter clean && flutter pub get`
- **Firebase issues**: Check `google-services.json` placement
- **AI not working**: Verify OpenRouter API key
- **Database errors**: Check Firestore security rules

## 🎯 **Roadmap**

### **Upcoming Features**
- [ ] Push notifications
- [ ] Voice messages
- [ ] File sharing
- [ ] Multi-language support
- [ ] Advanced AI features
- [ ] Analytics integration
- [ ] Payment integration
- [ ] Social features

### **Version History**
- **v1.0.0** - Initial release with core features
- **v1.1.0** - Enhanced AI integration
- **v1.2.0** - Improved database architecture
- **v2.0.0** - Major UI/UX improvements (planned)

---

## 🌟 **Star this repo if it helped you!**

Built with ❤️ using Flutter

**Happy coding!** 🚀
