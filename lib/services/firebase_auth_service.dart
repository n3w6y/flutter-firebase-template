import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

import '../models/user_model.dart';
import '../models/auth_state.dart';

/// Comprehensive Firebase Authentication Service
class FirebaseAuthService {
  static FirebaseAuthService? _instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuthService._();

  /// Singleton instance getter
  static FirebaseAuthService get instance {
    _instance ??= FirebaseAuthService._();
    return _instance!;
  }

  /// Get current user
  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  /// Get current user as UserModel
  UserModel? get currentUser {
    final firebaseUser = currentFirebaseUser;
    return firebaseUser != null ? UserModel.fromFirebaseUser(firebaseUser) : null;
  }

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Stream of user changes (including profile updates)
  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  /// Check if user is currently signed in
  bool get isSignedIn => currentFirebaseUser != null;

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName);
        await userCredential.user?.reload();
      }

      // Send email verification
      await sendEmailVerification();

      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult.failure(errorMessage: 'Google sign-in was cancelled.');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await _firebaseAuth.signInWithCredential(credential);

      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Google sign-in failed. Please try again.',
      );
    }
  }

  /// Sign in with Apple (iOS only)
  Future<AuthResult> signInWithApple() async {
    try {
      if (!Platform.isIOS) {
        return AuthResult.failure(
          errorMessage: 'Apple Sign-In is only available on iOS devices.',
        );
      }

      // Generate a random nonce
      final rawNonce = _generateNonce();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      // Update display name if available and not already set
      if (userCredential.user?.displayName == null) {
        final fullName = appleCredential.givenName != null && appleCredential.familyName != null
            ? '${appleCredential.givenName} ${appleCredential.familyName}'
            : null;
        
        if (fullName != null) {
          await userCredential.user?.updateDisplayName(fullName);
          await userCredential.user?.reload();
        }
      }

      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Apple sign-in failed. Please try again.',
      );
    }
  }

  /// Sign in anonymously
  Future<AuthResult> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Anonymous sign-in failed. Please try again.',
      );
    }
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Failed to send password reset email. Please try again.',
      );
    }
  }

  /// Send email verification
  Future<AuthResult> sendEmailVerification() async {
    try {
      final user = currentFirebaseUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return AuthResult.success();
      }
      return AuthResult.failure(
        errorMessage: 'No user found or email already verified.',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Failed to send verification email. Please try again.',
      );
    }
  }

  /// Update user profile
  Future<AuthResult> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = currentFirebaseUser;
      if (user == null) {
        return AuthResult.failure(errorMessage: 'No user found.');
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Failed to update profile. Please try again.',
      );
    }
  }

  /// Change password
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentFirebaseUser;
      if (user == null || user.email == null) {
        return AuthResult.failure(errorMessage: 'No user found.');
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Failed to change password. Please try again.',
      );
    }
  }

  /// Delete user account
  Future<AuthResult> deleteAccount({String? password}) async {
    try {
      final user = currentFirebaseUser;
      if (user == null) {
        return AuthResult.failure(errorMessage: 'No user found.');
      }

      // Re-authenticate if password is provided (for email users)
      if (password != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }

      await user.delete();
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        errorMessage: _getErrorMessage(e.code),
        errorCode: e.code,
      );
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Failed to delete account. Please try again.',
      );
    }
  }

  /// Sign out
  Future<AuthResult> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure(
        errorMessage: 'Failed to sign out. Please try again.',
      );
    }
  }

  /// Generate a cryptographically secure random nonce
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Get user-friendly error message from Firebase error code
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action.';
      case 'credential-already-in-use':
        return 'This account is already linked to another user.';
      case 'invalid-credential':
        return 'The provided credentials are invalid.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
