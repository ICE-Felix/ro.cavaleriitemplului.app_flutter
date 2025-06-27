import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/news_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<NewsEntity>> getNews({int page = 1, int limit = 20}) async {
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
  Future<List<NewsEntity>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 20,
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
  Future<List<NewsEntity>> searchNews(
    String query, {
    int page = 1,
    int limit = 20,
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
  Future<NewsEntity> getNewsById(int id) async {
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
  Future<List<String>> getCategories() async {
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
