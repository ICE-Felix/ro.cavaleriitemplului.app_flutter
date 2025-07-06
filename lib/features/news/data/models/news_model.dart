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
    // Handle both old format (mock data) and new API format
    final content = json['body'] ?? json['content'] ?? '';
    final summary = json['summary'] ?? _createSummary(content);
    final tags = _parseTags(json['keywords'] ?? json['tags'] ?? '');

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: content,
      summary: summary,
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      author: json['partner_company_name'] ?? json['author'] ?? '',
      publishedAt:
          DateTime.tryParse(json['created_at'] ?? json['published_at'] ?? '') ??
          DateTime.now(),
      category: json['news_category_title'] ?? json['category'] ?? '',
      source: json['partner_company_name'] ?? json['source'] ?? '',
      views: json['read_count'] ?? json['views'] ?? 0,
      tags: tags,
    );
  }

  // Helper method to create summary from content
  static String _createSummary(String content) {
    if (content.isEmpty) return '';
    // Take first 100 characters or until first sentence
    final sentences = content.split(RegExp(r'[.!?]'));
    if (sentences.isNotEmpty && sentences[0].length <= 100) {
      return sentences[0].trim() + (sentences.length > 1 ? '.' : '');
    }
    return content.length <= 100
        ? content
        : content.substring(0, 100).trim() + '...';
  }

  // Helper method to parse keywords string into tags array
  static List<String> _parseTags(dynamic tagsInput) {
    if (tagsInput is List) {
      return List<String>.from(tagsInput);
    } else if (tagsInput is String) {
      if (tagsInput.isEmpty) return [];
      return tagsInput
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
    }
    return [];
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
