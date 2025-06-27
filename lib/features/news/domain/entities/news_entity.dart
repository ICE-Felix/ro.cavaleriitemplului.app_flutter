import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final String summary;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;
  final String category;
  final String source;
  final int views;
  final List<String> tags;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.category,
    required this.source,
    this.views = 0,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    summary,
    imageUrl,
    author,
    publishedAt,
    category,
    source,
    views,
    tags,
  ];
}
