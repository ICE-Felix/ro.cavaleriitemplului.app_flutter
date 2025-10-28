import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/dio_client.dart';
import '../models/banner_model.dart';

abstract class BannersRemoteDataSource {
  Future<List<BannerModel>> getBanners();
  Future<void> incrementDisplays(String id);
  Future<void> incrementClicks(String id);
}

class BannersRemoteDataSourceImpl implements BannersRemoteDataSource {
  final DioClient dio;

  BannersRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await dio.get('/banners', queryParameters: {'active': true});

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> bannersData = response['data'] as List<dynamic>;
      return bannersData
          .map((banner) => BannerModel.fromJson(banner as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> incrementDisplays(String id) async {
    try {
      final response = await dio.post(
        '/banners-increment-displays',
        data: {'id': id},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> incrementClicks(String id) async {
    try {
      final response = await dio.post(
        '/banners-increment-clicks',
        data: {'id': id},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
