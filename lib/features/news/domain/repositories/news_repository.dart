import '../entities/news_entity.dart';
import '../../data/models/category_model.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getNews({int page = 1, int limit = 20});
  Future<List<NewsEntity>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 20,
  });
  Future<List<NewsEntity>> searchNews(
    String query, {
    int page = 1,
    int limit = 20,
  });
  Future<NewsEntity> getNewsById(String id);
  Future<List<CategoryModel>> getCategories();
}
