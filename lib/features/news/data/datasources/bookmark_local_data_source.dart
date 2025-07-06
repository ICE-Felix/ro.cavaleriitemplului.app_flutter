import '../../../../core/database/database_helper.dart';
import '../models/bookmark_model.dart';

abstract class BookmarkLocalDataSource {
  Future<void> addBookmark(BookmarkModel bookmark);
  Future<void> removeBookmark(String newsId);
  Future<bool> isBookmarked(String newsId);
  Future<List<BookmarkModel>> getAllBookmarks();
  Future<BookmarkModel?> getBookmark(String newsId);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  final DatabaseHelper databaseHelper;

  BookmarkLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> addBookmark(BookmarkModel bookmark) async {
    await databaseHelper.insertBookmark(bookmark.toMap());
  }

  @override
  Future<void> removeBookmark(String newsId) async {
    await databaseHelper.deleteBookmark(newsId);
  }

  @override
  Future<bool> isBookmarked(String newsId) async {
    return await databaseHelper.isBookmarked(newsId);
  }

  @override
  Future<List<BookmarkModel>> getAllBookmarks() async {
    final maps = await databaseHelper.getAllBookmarks();
    return maps.map((map) => BookmarkModel.fromMap(map)).toList();
  }

  @override
  Future<BookmarkModel?> getBookmark(String newsId) async {
    final map = await databaseHelper.getBookmark(newsId);
    return map != null ? BookmarkModel.fromMap(map) : null;
  }
}
