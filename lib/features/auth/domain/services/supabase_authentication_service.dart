import 'dart:async';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../../data/models/user_model.dart';
import 'authentication_service.dart';

/// Supabase implementation of the authentication service
/// This service leverages Supabase's built-in features like:
/// - Real-time auth state changes
/// - Session management
/// - Built-in authentication state detection
class SupabaseAuthenticationService implements AuthenticationService {
  final SupabaseAuthClient _supabaseClient;

  StreamSubscription<dynamic>? _authStateSubscription;
  final StreamController<UserModel?> _authStateController =
      StreamController<UserModel?>.broadcast();

  SupabaseAuthenticationService({required SupabaseAuthClient supabaseClient})
    : _supabaseClient = supabaseClient {
    _initializeAuthStateListener();
  }

  /// Initialize the auth state listener to leverage Supabase's built-in auth state changes
  void _initializeAuthStateListener() {
    _authStateSubscription = _supabaseClient.onAuthStateChange.listen(
      (data) {
        final user = data.session?.user;
        if (user != null) {
          final userEntity = _mapUserToEntity(user);
          _authStateController.add(userEntity);
        } else {
          _authStateController.add(null);
        }
      },
      onError: (error) {
        _authStateController.add(null);
      },
    );
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  bool get isUserLoggedIn => _supabaseClient.currentUser != null;

  @override
  Future<UserModel?> get currentUser async {
    try {
      final user = _supabaseClient.currentUser;
      if (user == null) return null;
      return _mapUserToEntity(user);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> checkAuthStatus() async {
    try {
      // Leverage Supabase's built-in authentication check
      final currentUser = _supabaseClient.currentUser;
      if (currentUser == null) return null;

      return _mapUserToEntity(currentUser);
    } catch (e) {
      return null;
    }
  }

  @override
  StreamSubscription<UserModel?> listenToAuthChanges() {
    return authStateChanges.listen(
      (UserModel? user) {
        // This will be called whenever auth state changes
        // The listener is already set up in _initializeAuthStateListener
      },
      onError: (error) {
        // Handle auth state change errors
        _authStateController.add(null);
      },
    );
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _authStateController.close();
  }

  /// Maps Supabase User to UserModel
  UserModel _mapUserToEntity(dynamic user) {
    return UserModel(
      id: int.tryParse(user.id) ?? 0,
      name:
          user.userMetadata?['name'] as String? ??
          user.userMetadata?['full_name'] as String? ??
          user.email?.split('@').first ??
          'User',
      email: user.email ?? '',
      avatar: user.userMetadata?['avatar_url'] as String?,
      token: _supabaseClient.currentSession?.accessToken ?? '',
    );
  }

  /// Get the current Supabase session
  dynamic get currentSupabaseSession => _supabaseClient.currentSession;

  /// Get the current Supabase user
  dynamic get currentSupabaseUser => _supabaseClient.currentUser;

  /// Check if the current session is valid and not expired
  bool get isSessionValid {
    final session = currentSupabaseSession;
    if (session == null) return false;

    final now = DateTime.now().toUtc();
    final expiresAt = session.expiresAt;

    return expiresAt != null &&
        now.isBefore(DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000));
  }

  /// Refresh the current session if needed
  Future<void> refreshSession() async {
    try {
      await _supabaseClient.refreshSession();
    } catch (e) {
      throw AuthException(
        message: 'Failed to refresh session: ${e.toString()}',
      );
    }
  }
}
