import 'package:app/core/banners/data/datasources/banners_remote_data_source.dart';
import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/domain/repositories/banners_repository.dart';
import 'package:app/core/error/exceptions.dart';

class BannersRepositoryImpl implements BannersRepository {
  final BannersRemoteDataSource remoteDataSource;

  BannersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BannerEntity>> getBanners() async {
    try {
      final banners = await remoteDataSource.getBanners();
      return banners.map((banner) => banner.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<void> incrementDisplays(String id) async {
    try {
      await remoteDataSource.incrementDisplays(id);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<void> incrementClicks(String id) async {
    try {
      await remoteDataSource.incrementClicks(id);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }
}
