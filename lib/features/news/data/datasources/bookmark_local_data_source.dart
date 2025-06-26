import '../../../../core/database/database_helper.dart';
import '../models/bookmark_model.dart';

abstract class BookmarkLocalDataSource {
  Future<void> addBookmark(BookmarkModel bookmark);
  Future<void> removeBookmark(int newsId);
  Future<bool> isBookmarked(int newsId);
  Future<List<BookmarkModel>> getAllBookmarks();
  Future<BookmarkModel?> getBookmark(int newsId);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  final DatabaseHelper databaseHelper;

  BookmarkLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> addBookmark(BookmarkModel bookmark) async {
    await databaseHelper.insertBookmark(bookmark.toMap());
  }

  @override
  Future<void> removeBookmark(int newsId) async {
    await databaseHelper.deleteBookmark(newsId);
  }

  @override
  Future<bool> isBookmarked(int newsId) async {
    return await databaseHelper.isBookmarked(newsId);
  }

  @override
  Future<List<BookmarkModel>> getAllBookmarks() async {
    final maps = await databaseHelper.getAllBookmarks();
    return maps.map((map) => BookmarkModel.fromMap(map)).toList();
  }

  @override
  Future<BookmarkModel?> getBookmark(int newsId) async {
    final map = await databaseHelper.getBookmark(newsId);
    return map != null ? BookmarkModel.fromMap(map) : null;
  }
}
