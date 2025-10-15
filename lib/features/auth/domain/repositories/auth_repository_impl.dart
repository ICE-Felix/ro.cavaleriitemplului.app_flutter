import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import 'auth_repository.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signIn(
          email: email,
          password: password,
        );
        // Cache the user locally after successful login
        await localDataSource.cacheUser(user);
        return user;
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Clear local cache first
      await localDataSource.clearCachedUser();

      // Then try to logout from remote if connected
      if (await networkInfo.isConnected) {
        await remoteDataSource.signOut();
      }
    } catch (e) {
      // Even if remote logout fails, we've cleared local cache
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(
          email: email,
          password: password,
          userData: userData,
        );
        // Cache the user locally after successful registration
        await localDataSource.cacheUser(user);
        return user;
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        if (user != null) {
          // Update local cache with fresh profile data
          await localDataSource.cacheUser(user);
        }
        return user;
      } catch (e) {
        // If remote fails, try to get from local cache
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return cachedUser;
        }
        throw ServerException(message: e.toString());
      }
    } else {
      // No internet, get from local cache
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return cachedUser;
      }
      throw NetworkException(
        message: 'No internet connection and no cached user',
      );
    }
  }

  @override
  bool get isAuthenticated => remoteDataSource.isAuthenticated;

  @override
  Future<Map<String, dynamic>?> getCurrentSession() async {
    try {
      return await remoteDataSource.getCurrentSession();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(email: email);
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await localDataSource.cacheUser(user);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await localDataSource.clearCachedUser();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
