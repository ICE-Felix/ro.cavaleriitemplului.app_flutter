import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/news_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/news_response_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<NewsResponseModel> getNews({int page = 1, int limit = 5}) async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.getNews(page: page, limit: limit);
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<NewsResponseModel> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 5,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.getNewsByCategory(
          category,
          page: page,
          limit: limit,
        );
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<NewsResponseModel> searchNews(
    String query, {
    int page = 1,
    int limit = 5,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.searchNews(
          query,
          page: page,
          limit: limit,
        );
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<NewsEntity> getNewsById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.getNewsById(id);
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.getCategories();
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }
}
