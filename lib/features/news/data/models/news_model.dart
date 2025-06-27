import '../../domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.summary,
    required super.imageUrl,
    required super.author,
    required super.publishedAt,
    required super.category,
    required super.source,
    super.views,
    super.tags,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      imageUrl: json['image_url'] ?? '',
      author: json['author'] ?? '',
      publishedAt:
          DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
      category: json['category'] ?? '',
      source: json['source'] ?? '',
      views: json['views'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'image_url': imageUrl,
      'author': author,
      'published_at': publishedAt.toIso8601String(),
      'category': category,
      'source': source,
      'views': views,
      'tags': tags,
    };
  }
}
