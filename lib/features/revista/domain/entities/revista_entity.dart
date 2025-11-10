import 'package:equatable/equatable.dart';

class RevistaEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String pdfUrl; // Google Drive file ID or URL
  final DateTime publishedAt;
  final int pageCount;
  final String issueNumber;

  const RevistaEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pdfUrl,
    required this.publishedAt,
    this.pageCount = 0,
    this.issueNumber = '',
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    pdfUrl,
    publishedAt,
    pageCount,
    issueNumber,
  ];
}
