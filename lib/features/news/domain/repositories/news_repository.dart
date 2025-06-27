import '../entities/news_entity.dart';

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
  Future<NewsEntity> getNewsById(int id);
  Future<List<String>> getCategories();
}
