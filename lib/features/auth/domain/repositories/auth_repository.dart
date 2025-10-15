import '../../data/models/user_model.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
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

  /// Reset password for the given email
  Future<void> resetPassword({required String email});

  /// Get the current user profile
  Future<UserModel?> getCurrentUser();

  /// Check if user is currently authenticated
  bool get isAuthenticated;

  /// Get the current session
  Future<Map<String, dynamic>?> getCurrentSession();

  // Persistence methods
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();
}
