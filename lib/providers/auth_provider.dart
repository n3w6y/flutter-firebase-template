import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../models/auth_state.dart';
import '../services/firebase_auth_service.dart';
import 'subscription_provider.dart';

/// Provider for FirebaseAuthService instance
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService.instance;
});

/// Provider for Firebase Auth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Stream provider for authentication state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return authService.authStateChanges;
});

/// Stream provider for user changes (including profile updates)
final userChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return authService.userChanges;
});

/// Provider for current user as UserModel
final currentUserProvider = Provider<UserModel?>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return authService.currentUser;
});

/// Provider to check if user is signed in
final isSignedInProvider = Provider<bool>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return authService.isSignedIn;
});

/// State notifier for authentication operations
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;
  final Ref _ref;

  AuthNotifier(this._authService, this._ref) : super(AuthState.loading) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated;
        // Initialize subscription service with user ID
        _initializeSubscriptionService(user.uid);
      } else {
        state = AuthState.unauthenticated;
        // Logout from subscription service
        _logoutFromSubscriptionService();
      }
    });
  }

  /// Initialize subscription service for authenticated user
  void _initializeSubscriptionService(String userId) {
    try {
      final subscriptionNotifier = _ref.read(subscriptionOperationsProvider);
      subscriptionNotifier.initialize(userId: userId);
    } catch (e) {
      // Handle subscription initialization error silently
      // This is not critical for app functionality
    }
  }

  /// Logout from subscription service
  void _logoutFromSubscriptionService() {
    try {
      final subscriptionNotifier = _ref.read(subscriptionOperationsProvider);
      subscriptionNotifier.logoutUser();
    } catch (e) {
      // Handle subscription logout error silently
    }
  }

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = AuthState.loading;
    
    final result = await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (!result.success) {
      state = AuthState.error;
    }

    return result;
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading;
    
    final result = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (!result.success) {
      state = AuthState.error;
    }

    return result;
  }

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    state = AuthState.loading;
    
    final result = await _authService.signInWithGoogle();

    if (!result.success) {
      state = AuthState.error;
    }

    return result;
  }

  /// Sign in with Apple
  Future<AuthResult> signInWithApple() async {
    state = AuthState.loading;
    
    final result = await _authService.signInWithApple();

    if (!result.success) {
      state = AuthState.error;
    }

    return result;
  }

  /// Sign in anonymously
  Future<AuthResult> signInAnonymously() async {
    state = AuthState.loading;
    
    final result = await _authService.signInAnonymously();

    if (!result.success) {
      state = AuthState.error;
    }

    return result;
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    return await _authService.sendPasswordResetEmail(email);
  }

  /// Send email verification
  Future<AuthResult> sendEmailVerification() async {
    return await _authService.sendEmailVerification();
  }

  /// Update user profile
  Future<AuthResult> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    return await _authService.updateProfile(
      displayName: displayName,
      photoURL: photoURL,
    );
  }

  /// Change password
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Delete account
  Future<AuthResult> deleteAccount({String? password}) async {
    state = AuthState.loading;
    
    final result = await _authService.deleteAccount(password: password);

    if (!result.success) {
      state = AuthState.error;
    }

    return result;
  }

  /// Sign out
  Future<AuthResult> signOut() async {
    state = AuthState.loading;
    
    final result = await _authService.signOut();

    if (!result.success) {
      state = AuthState.error;
    }

    return result;
  }

  /// Reset auth state
  void resetState() {
    if (_authService.isSignedIn) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }
  }
}

/// Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return AuthNotifier(authService, ref);
});

/// Convenience providers for auth operations
final authOperationsProvider = Provider<AuthNotifier>((ref) {
  return ref.read(authNotifierProvider.notifier);
});

/// Provider for checking if email verification is needed
final emailVerificationNeededProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null && !user.emailVerified && user.isEmailUser;
});

/// Provider for user display name or email
final userDisplayProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 'Guest';
  
  if (user.displayName != null && user.displayName!.isNotEmpty) {
    return user.displayName!;
  } else if (user.email != null) {
    return user.email!;
  } else {
    return 'User';
  }
});

/// Provider for user initials
final userInitialsProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.initials ?? 'U';
});

/// Provider for checking if user can change password
final canChangePasswordProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isEmailUser ?? false;
});

/// Provider for user's sign-in methods
final userSignInMethodsProvider = Provider<List<String>>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.providerIds ?? [];
});
