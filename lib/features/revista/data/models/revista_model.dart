import '../../domain/entities/revista_entity.dart';

class RevistaModel extends RevistaEntity {
  const RevistaModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.pdfUrl,
    required super.publishedAt,
    super.pageCount,
    super.issueNumber,
  });

  factory RevistaModel.fromJson(Map<String, dynamic> json) {
    return RevistaModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      pdfUrl: json['pdf_url'] ?? json['pdfUrl'] ?? '',
      publishedAt: DateTime.tryParse(
        json['published_at'] ?? json['publishedAt'] ?? '',
      ) ?? DateTime.now(),
      pageCount: json['page_count'] ?? json['pageCount'] ?? 0,
      issueNumber: json['issue_number'] ?? json['issueNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'pdf_url': pdfUrl,
      'published_at': publishedAt.toIso8601String(),
      'page_count': pageCount,
      'issue_number': issueNumber,
    };
  }
}
