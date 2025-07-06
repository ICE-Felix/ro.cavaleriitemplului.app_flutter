class PaginationModel {
  final int total;
  final int limit;
  final int offset;
  final int page;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationModel({
    required this.total,
    required this.limit,
    required this.offset,
    required this.page,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 1,
      offset: json['offset'] ?? 0,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'offset': offset,
      'page': page,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }

  @override
  String toString() {
    return 'PaginationModel(total: $total, page: $page/$totalPages, hasNext: $hasNext)';
  }
}
