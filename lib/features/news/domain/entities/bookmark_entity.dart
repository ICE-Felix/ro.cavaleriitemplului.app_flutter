import 'package:equatable/equatable.dart';

class BookmarkEntity extends Equatable {
  final String newsId;
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final DateTime bookmarkedAt;
  final String category;
  final String source;

  const BookmarkEntity({
    required this.newsId,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.bookmarkedAt,
    required this.category,
    required this.source,
  });

  @override
  List<Object?> get props => [
    newsId,
    title,
    summary,
    imageUrl,
    author,
    bookmarkedAt,
    category,
    source,
  ];
}
