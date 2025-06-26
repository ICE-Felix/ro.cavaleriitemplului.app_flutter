import '../entities/bookmark_entity.dart';

abstract class BookmarkRepository {
  Future<void> addBookmark({
    required int newsId,
    required String title,
    required String summary,
    required String imageUrl,
    required String author,
    required String category,
    required String source,
  });

  Future<void> removeBookmark(int newsId);
  Future<bool> isBookmarked(int newsId);
  Future<List<BookmarkEntity>> getAllBookmarks();
  Future<BookmarkEntity?> getBookmark(int newsId);
}
