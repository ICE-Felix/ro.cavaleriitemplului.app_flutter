import 'package:app/features/events/domain/model/events.dart';

class EventsSearchResponse {
  final List<Event> data;
  final Meta meta;

  const EventsSearchResponse({
    required this.data,
    required this.meta,
  });

  factory EventsSearchResponse.fromJson(Map<String, dynamic> json) {
    return EventsSearchResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Event.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}


class Meta {
  final Pagination pagination;
  final Map<String, dynamic> filters;

  const Meta({required this.pagination, required this.filters});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      filters: json['filters'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {'pagination': pagination.toJson(), 'filters': filters};
  }
}

class Pagination {
  final int total;
  final int limit;
  final int offset;
  final int page;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const Pagination({
    required this.total,
    required this.limit,
    required this.offset,
    required this.page,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
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
}
