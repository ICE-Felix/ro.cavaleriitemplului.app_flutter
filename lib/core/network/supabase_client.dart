import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase_flutter
    hide AuthException;

import '../error/exceptions.dart';

/// Wrapper around Supabase client to handle authentication
class SupabaseAuthClient {
  // Singleton pattern
  static final SupabaseAuthClient _instance = SupabaseAuthClient._internal();
  factory SupabaseAuthClient() => _instance;

  SupabaseAuthClient._internal();

  // Initialize Supabase - call this before using the client
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: dotenv.get('SUPABASE_URL'),
        anonKey: dotenv.get('ANON_KEY'),
        debug: kDebugMode,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Supabase: $e');
      }
      throw ServerException(message: 'Failed to initialize Supabase: $e');
    }
  }

  // Auth methods
  Future<User> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );

      if (response.user == null) {
        throw AuthException(message: 'Failed to sign up');
      }

      return response.user!;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: e.toString());
    }
  }

  Future<User> signIn({required String email, required String password}) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException(message: 'Failed to sign in');
      }

      return response.user!;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  // Get current user
  User? get currentUser => Supabase.instance.client.auth.currentUser;

  // Get current session
  Session? get currentSession => Supabase.instance.client.auth.currentSession;

  // Check if user is authenticated
  bool get isAuthenticated => Supabase.instance.client.auth.currentUser != null;

  // Get user profile
  Future<User> getProfile() async {
    if (!isAuthenticated) {
      throw AuthException(message: 'User not authenticated');
    }
    return currentUser!;
  }

  // Reset password (forgot password)
  Future<void> resetPassword({required String email}) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutterquickstart://reset-callback/',
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get onAuthStateChange =>
      Supabase.instance.client.auth.onAuthStateChange;

  // Refresh session
  Future<void> refreshSession() async {
    try {
      await Supabase.instance.client.auth.refreshSession();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
}

/// General Supabase client for database operations
class SupabaseClient {
  static final SupabaseClient _instance = SupabaseClient._internal();
  factory SupabaseClient() => _instance;
  SupabaseClient._internal();

  /// Access to the underlying Supabase client
  supabase_flutter.SupabaseClient get client => Supabase.instance.client;
}
