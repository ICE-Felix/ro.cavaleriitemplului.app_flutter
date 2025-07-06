import '../entities/bookmark_entity.dart';

abstract class BookmarkRepository {
  Future<void> addBookmark({
    required String newsId,
    required String title,
    required String summary,
    required String imageUrl,
    required String author,
    required String category,
    required String source,
  });

  Future<void> removeBookmark(String newsId);
  Future<bool> isBookmarked(String newsId);
  Future<List<BookmarkEntity>> getAllBookmarks();
  Future<BookmarkEntity?> getBookmark(String newsId);
}
