import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_data_source.dart';
import '../models/bookmark_model.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addBookmark({
    required String newsId,
    required String title,
    required String summary,
    required String imageUrl,
    required String author,
    required String category,
    required String source,
  }) async {
    final bookmark = BookmarkModel.fromNewsEntity(
      newsId: newsId,
      title: title,
      summary: summary,
      imageUrl: imageUrl,
      author: author,
      category: category,
      source: source,
    );
    await localDataSource.addBookmark(bookmark);
  }

  @override
  Future<void> removeBookmark(String newsId) async {
    await localDataSource.removeBookmark(newsId);
  }

  @override
  Future<bool> isBookmarked(String newsId) async {
    return await localDataSource.isBookmarked(newsId);
  }

  @override
  Future<List<BookmarkEntity>> getAllBookmarks() async {
    final bookmarks = await localDataSource.getAllBookmarks();
    return bookmarks.cast<BookmarkEntity>();
  }

  @override
  Future<BookmarkEntity?> getBookmark(String newsId) async {
    return await localDataSource.getBookmark(newsId);
  }
}
