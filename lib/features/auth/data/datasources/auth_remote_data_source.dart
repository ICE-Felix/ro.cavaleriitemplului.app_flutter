import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/user_model.dart';

/// Abstract datasource for authentication operations
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signIn({required String email, required String password});

  /// Sign up with email, password and user data
  Future<UserModel> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Get the current user profile
  Future<UserModel?> getCurrentUser();

  /// Reset password for the given email
  Future<void> resetPassword({required String email});

  /// Check if user is currently authenticated
  bool get isAuthenticated;

  /// Get the current session
  Future<Map<String, dynamic>?> getCurrentSession();
}

/// Supabase implementation of the authentication datasource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseAuthClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await supabaseClient.signIn(
        email: email,
        password: password,
      );

      // User is guaranteed to be non-null from Supabase signIn

      return _mapUserToEntity(user);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final user = await supabaseClient.signUp(
        email: email,
        password: password,
        userData: userData,
      );

      // User is guaranteed to be non-null from Supabase signUp

      return _mapUserToEntity(user);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.signOut();
    } catch (e) {
      throw AuthException(message: 'Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.currentUser;
      if (user == null) return null;
      return _mapUserToEntity(user);
    } catch (e) {
      throw AuthException(
        message: 'Failed to get current user: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseClient.resetPassword(email: email);
    } catch (e) {
      throw AuthException(message: 'Password reset failed: ${e.toString()}');
    }
  }

  @override
  bool get isAuthenticated => supabaseClient.currentUser != null;

  @override
  Future<Map<String, dynamic>?> getCurrentSession() async {
    try {
      final session = supabaseClient.currentSession;
      if (session == null) return null;

      return {
        'access_token': session.accessToken,
        'refresh_token': session.refreshToken,
        'expires_at':
            session.expiresAt != null
                ? DateTime.fromMillisecondsSinceEpoch(
                  session.expiresAt! * 1000,
                ).toIso8601String()
                : null,
        'user': {
          'id': session.user.id,
          'email': session.user.email,
          'user_metadata': session.user.userMetadata,
        },
      };
    } catch (e) {
      throw AuthException(
        message: 'Failed to get current session: ${e.toString()}',
      );
    }
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
      token: supabaseClient.currentSession?.accessToken ?? '',
    );
  }
}
