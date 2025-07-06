import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/news_model.dart';
import '../models/category_model.dart';
import 'news_mock_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    as supabase_flutter
    hide AuthException;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Future<NewsModel> getNewsById(String id);
  Future<List<CategoryModel>> getCategories();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final SupabaseAuthClient _authClient;

  NewsRemoteDataSourceImpl()
    : _supabaseClient = SupabaseClient(),
      _authClient = SupabaseAuthClient();

  @override
  Future<List<NewsModel>> getNews({int page = 1, int limit = 20}) async {
    try {
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};

      // Make API call to fetch news
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/news',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch news: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> data = responseData['data'];
      final List<dynamic> newsData = data['data'] ?? [];

      // Convert to NewsModel objects
      final news =
          newsData.map((newsJson) => NewsModel.fromJson(newsJson)).toList();

      return news;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
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
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters with category filter
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'category_id': category,
      };

      // Make API call to fetch news with category filter
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/news',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to fetch news by category: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> data = responseData['data'];
      final List<dynamic> newsData = data['data'] ?? [];

      // Convert to NewsModel objects
      final news =
          newsData.map((newsJson) => NewsModel.fromJson(newsJson)).toList();

      return news;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
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
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Build query parameters with search filter
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'search': query,
      };

      // Make API call to search news
      final uri = Uri.parse(
        '${dotenv.get('SUPABASE_URL')}/functions/v1/news',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to search news: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> data = responseData['data'];
      final List<dynamic> newsData = data['data'] ?? [];

      // Convert to NewsModel objects
      final news =
          newsData.map((newsJson) => NewsModel.fromJson(newsJson)).toList();

      return news;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NewsModel> getNewsById(String id) async {
    try {
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Make API call to fetch specific news by ID
      final response = await http.get(
        Uri.parse('${dotenv.get('SUPABASE_URL')}/functions/v1/news/$id'),
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          throw ServerException(message: 'News not found');
        }
        throw ServerException(
          message: 'Failed to fetch news: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      // Convert to NewsModel object
      final newsData = responseData['data'];
      final news = NewsModel.fromJson(newsData);

      return news;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Check if user is authenticated
      if (!_authClient.isAuthenticated) {
        throw AuthException(message: 'User not authenticated');
      }

      // Get the current session token
      final session = _authClient.currentSession;
      if (session?.accessToken == null) {
        throw AuthException(message: 'No valid session token');
      }

      // Make direct HTTP call to match the curl command exactly
      final response = await http.get(
        Uri.parse('${dotenv.get('SUPABASE_URL')}/functions/v1/news_categories'),
        headers: {
          'apikey': dotenv.get('ANON_KEY'),
          'Authorization': 'Bearer ${session!.accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-type': 'api',
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'API call failed with status: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${responseData['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> categoriesData = responseData['data'] ?? [];

      // Convert to CategoryModel objects and filter out deleted categories
      final categories =
          categoriesData
              .map((categoryJson) => CategoryModel.fromJson(categoryJson))
              .where(
                (category) => category.deletedAt == null,
              ) // Filter out deleted categories
              .toList();

      return categories;
    } catch (e) {
      // Fallback to mock data if API fails for now
      print('Failed to fetch categories from API, using mock data: $e');
      return NewsMockDataSource.getMockCategories();
    }
  }
}
