import 'news_model.dart';
import 'pagination_model.dart';

class NewsResponseModel {
  final List<NewsModel> news;
  final PaginationModel pagination;
  final Map<String, dynamic>? filters;

  const NewsResponseModel({
    required this.news,
    required this.pagination,
    this.filters,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle new API structure: data is directly in 'data' array, pagination in 'meta.pagination'
    final newsData = json['data'] as List<dynamic>;
    final metaData = json['meta'] as Map<String, dynamic>;
    final paginationData = metaData['pagination'] as Map<String, dynamic>;
    final filtersData = metaData['filters'] as Map<String, dynamic>?;

    return NewsResponseModel(
      news: newsData.map((newsJson) => NewsModel.fromJson(newsJson)).toList(),
      pagination: PaginationModel.fromJson(paginationData),
      filters: filtersData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': news.map((n) => n.toJson()).toList(),
      'meta': {'pagination': pagination.toJson(), 'filters': filters},
    };
  }
}
