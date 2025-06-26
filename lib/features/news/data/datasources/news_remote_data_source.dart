import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/news_model.dart';
import 'news_mock_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase_flutter
    hide AuthException;

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews({int page = 1, int limit = 20});
  Future<List<NewsModel>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 20,
  });
  Future<List<NewsModel>> searchNews(
    String query, {
    int page = 1,
    int limit = 20,
  });
  Future<NewsModel> getNewsById(int id);
  Future<List<String>> getCategories();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  NewsRemoteDataSourceImpl();

  @override
  Future<List<NewsModel>> getNews({int page = 1, int limit = 20}) async {
    try {
      // Using mock data for now
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      final allNews = NewsMockDataSource.getMockNews();
      final offset = (page - 1) * limit;
      final endIndex = (offset + limit).clamp(0, allNews.length);

      return allNews.sublist(offset.clamp(0, allNews.length), endIndex);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<NewsModel>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Using mock data for now
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      final filteredNews = NewsMockDataSource.getMockNewsByCategory(category);
      final offset = (page - 1) * limit;
      final endIndex = (offset + limit).clamp(0, filteredNews.length);

      return filteredNews.sublist(
        offset.clamp(0, filteredNews.length),
        endIndex,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<NewsModel>> searchNews(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Using mock data for now
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      final searchResults = NewsMockDataSource.searchMockNews(query);
      final offset = (page - 1) * limit;
      final endIndex = (offset + limit).clamp(0, searchResults.length);

      return searchResults.sublist(
        offset.clamp(0, searchResults.length),
        endIndex,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NewsModel> getNewsById(int id) async {
    try {
      // Using mock data for now
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      final allNews = NewsMockDataSource.getMockNews();
      final news = allNews.firstWhere(
        (news) => news.id == id,
        orElse: () => throw ServerException(message: 'News not found'),
      );

      return news;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      // Using mock data for now
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      return NewsMockDataSource.getMockCategories();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
