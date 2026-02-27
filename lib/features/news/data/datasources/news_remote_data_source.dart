import '../../../../core/error/exceptions.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/news_model.dart';
import '../models/category_model.dart';
import '../models/news_response_model.dart';
import '../models/pagination_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getNews({int page = 1, int limit = 5});
  Future<NewsResponseModel> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 5,
  });
  Future<NewsResponseModel> searchNews(
    String query, {
    int page = 1,
    int limit = 5,
  });
  Future<NewsModel> getNewsById(String id);
  Future<List<CategoryModel>> getCategories();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final SupabaseClient _supabaseClient;

  NewsRemoteDataSourceImpl() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  @override
  Future<NewsResponseModel> getNews({int page = 1, int limit = 5}) async {
    try {
      final offset = (page - 1) * limit;

      final countResponse = await _client
          .from('news')
          .select('id')
          .count(supabase_flutter.CountOption.exact);
      final total = countResponse.count;

      final data = await _client
          .from('news')
          .select()
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final newsList =
          (data as List).map((json) => NewsModel.fromJson(json)).toList();

      final totalPages = total > 0 ? (total / limit).ceil() : 1;

      return NewsResponseModel(
        news: newsList,
        pagination: PaginationModel(
          total: total,
          limit: limit,
          offset: offset,
          page: page,
          totalPages: totalPages,
          hasNext: page < totalPages,
          hasPrevious: page > 1,
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NewsResponseModel> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final offset = (page - 1) * limit;

      final countResponse = await _client
          .from('news')
          .select('id')
          .eq('category_id', category)
          .count(supabase_flutter.CountOption.exact);
      final total = countResponse.count;

      final data = await _client
          .from('news')
          .select()
          .eq('category_id', category)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final newsList =
          (data as List).map((json) => NewsModel.fromJson(json)).toList();

      final totalPages = total > 0 ? (total / limit).ceil() : 1;

      return NewsResponseModel(
        news: newsList,
        pagination: PaginationModel(
          total: total,
          limit: limit,
          offset: offset,
          page: page,
          totalPages: totalPages,
          hasNext: page < totalPages,
          hasPrevious: page > 1,
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NewsResponseModel> searchNews(
    String query, {
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final offset = (page - 1) * limit;

      final countResponse = await _client
          .from('news')
          .select('id')
          .or('title.ilike.%$query%,body.ilike.%$query%')
          .count(supabase_flutter.CountOption.exact);
      final total = countResponse.count;

      final data = await _client
          .from('news')
          .select()
          .or('title.ilike.%$query%,body.ilike.%$query%')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final newsList =
          (data as List).map((json) => NewsModel.fromJson(json)).toList();

      final totalPages = total > 0 ? (total / limit).ceil() : 1;

      return NewsResponseModel(
        news: newsList,
        pagination: PaginationModel(
          total: total,
          limit: limit,
          offset: offset,
          page: page,
          totalPages: totalPages,
          hasNext: page < totalPages,
          hasPrevious: page > 1,
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NewsModel> getNewsById(String id) async {
    try {
      // Increment read count
      await _client.rpc('increment_read_count', params: {'news_id': id});

      final data =
          await _client.from('news').select().eq('id', id).single();

      return NewsModel.fromJson(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await _client
          .from('news_categories')
          .select()
          .isFilter('deleted_at', null)
          .order('name');

      return (data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Failed to fetch categories: $e');
      return [];
    }
  }
}
