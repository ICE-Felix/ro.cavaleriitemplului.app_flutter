import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

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
  Future<UserEntity> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
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
  Future<void> logout() async {
    try {
      // Clear local cache first
      await localDataSource.clearCachedUser();

      // Then try to logout from remote if connected
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
    } catch (e) {
      // Even if remote logout fails, we've cleared local cache
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserEntity> register(
    String name,
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.register(name, email, password);
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
  Future<UserEntity> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getProfile();
        // Update local cache with fresh profile data
        await localDataSource.cacheUser(user);
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
  Future<bool> isAuthenticated() async {
    try {
      return await localDataSource.isAuthenticated();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(email);
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserEntity user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        token: user.token,
      );
      await localDataSource.cacheUser(userModel);
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
