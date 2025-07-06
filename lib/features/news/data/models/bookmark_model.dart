import '../../domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.newsId,
    required super.title,
    required super.summary,
    required super.imageUrl,
    required super.author,
    required super.bookmarkedAt,
    required super.category,
    required super.source,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      newsId: map['news_id'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String,
      imageUrl: map['image_url'] as String,
      author: map['author'] as String,
      bookmarkedAt: DateTime.fromMillisecondsSinceEpoch(
        map['bookmarked_at'] as int,
      ),
      category: map['category'] as String,
      source: map['source'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'news_id': newsId,
      'title': title,
      'summary': summary,
      'image_url': imageUrl,
      'author': author,
      'bookmarked_at': bookmarkedAt.millisecondsSinceEpoch,
      'category': category,
      'source': source,
    };
  }

  factory BookmarkModel.fromNewsEntity({
    required String newsId,
    required String title,
    required String summary,
    required String imageUrl,
    required String author,
    required String category,
    required String source,
  }) {
    return BookmarkModel(
      newsId: newsId,
      title: title,
      summary: summary,
      imageUrl: imageUrl,
      author: author,
      bookmarkedAt: DateTime.now(),
      category: category,
      source: source,
    );
  }
}
