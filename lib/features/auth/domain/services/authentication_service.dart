import 'dart:async';

import '../../data/models/user_model.dart';

/// Abstract service for authentication operations
/// This service provides high-level authentication functionality
/// leveraging Supabase features like auth state changes, session management, etc.
abstract class AuthenticationService {
  /// Stream of authentication state changes
  /// This leverages Supabase's built-in auth state change detection
  Stream<UserModel?> get authStateChanges;

  /// Check if user is currently logged in
  bool get isUserLoggedIn;

  /// Get the current user profile
  Future<UserModel?> get currentUser;

  /// Check authentication status on app startup
  Future<UserModel?> checkAuthStatus();

  /// Listen to Supabase auth state changes
  /// This provides real-time authentication state updates
  StreamSubscription<UserModel?> listenToAuthChanges();

  /// Dispose the service and clean up resources
  /// This method cleans up streams, subscriptions, and other resources
  /// to prevent memory leaks when the service is no longer needed
  void dispose();
}
