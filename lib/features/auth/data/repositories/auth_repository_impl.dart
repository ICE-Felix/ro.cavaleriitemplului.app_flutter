import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.login(email, password);
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<void> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
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
        return await remoteDataSource.register(name, email, password);
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
        return await remoteDataSource.getProfile();
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    // Here you would check if the user token exists in local storage
    // For now, we'll return false as we haven't implemented it
    return false;
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
}
