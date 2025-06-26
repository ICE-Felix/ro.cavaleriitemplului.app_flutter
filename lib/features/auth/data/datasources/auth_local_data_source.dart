import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();
  Future<bool> isAuthenticated();
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'auth_token';
  static const String _isAuthenticatedKey = 'is_authenticated';

  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(_userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cached user: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(_userKey, userJson);
      await sharedPreferences.setString(_tokenKey, user.token);
      await sharedPreferences.setBool(_isAuthenticatedKey, true);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(_userKey);
      await sharedPreferences.remove(_tokenKey);
      await sharedPreferences.setBool(_isAuthenticatedKey, false);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear cached user: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return sharedPreferences.getBool(_isAuthenticatedKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }
}
