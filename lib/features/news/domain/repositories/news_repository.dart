import '../entities/news_entity.dart';
import '../../data/models/category_model.dart';
import '../../data/models/news_response_model.dart';

abstract class NewsRepository {
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
  Future<NewsEntity> getNewsById(String id);
  Future<List<CategoryModel>> getCategories();
}
