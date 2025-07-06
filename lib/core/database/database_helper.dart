import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'mommy_hai.db';
  static const int _databaseVersion = 1;

  static const String bookmarksTable = 'bookmarks';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $bookmarksTable (
        news_id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        summary TEXT NOT NULL,
        image_url TEXT NOT NULL,
        author TEXT NOT NULL,
        bookmarked_at INTEGER NOT NULL,
        category TEXT NOT NULL,
        source TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertBookmark(Map<String, dynamic> bookmark) async {
    Database db = await database;
    return await db.insert(
      bookmarksTable,
      bookmark,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    Database db = await database;
    return await db.query(bookmarksTable, orderBy: 'bookmarked_at DESC');
  }

  Future<Map<String, dynamic>?> getBookmark(String newsId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      bookmarksTable,
      where: 'news_id = ?',
      whereArgs: [newsId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> isBookmarked(String newsId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      bookmarksTable,
      where: 'news_id = ?',
      whereArgs: [newsId],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  Future<int> deleteBookmark(String newsId) async {
    Database db = await database;
    return await db.delete(
      bookmarksTable,
      where: 'news_id = ?',
      whereArgs: [newsId],
    );
  }

  Future<int> getBookmarksCount() async {
    Database db = await database;
    var result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $bookmarksTable',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
