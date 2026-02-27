import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/supabase_client.dart';
import 'package:app/features/events/data/events_datasource.dart';
import 'package:app/features/events/data/model/events_search_responce.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

class EventsDatasourceSupabase implements EventsDatasource {
  final SupabaseClient _supabaseClient;

  EventsDatasourceSupabase() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  @override
  Future<EventsSearchResponse> getEventsSearch({
    required String? eventTypeId,
    required int page,
    required int limit,
    required String date,
    String? query,
  }) async {
    try {
      final offset = (page - 1) * limit;

      // Build count query
      var countQuery = _client
          .from('events')
          .select('id')
          .isFilter('deleted_at', null);

      if (eventTypeId != null && eventTypeId.isNotEmpty) {
        countQuery = countQuery.eq('event_type_id', eventTypeId);
      }

      if (query != null && query.isNotEmpty) {
        countQuery = countQuery.or('title.ilike.%$query%,description.ilike.%$query%');
      }

      if (date.isNotEmpty) {
        if (date.length == 7) {
          // Month format: YYYY-MM → filter entire month
          final monthStart = '${date}-01T00:00:00';
          final year = int.parse(date.substring(0, 4));
          final month = int.parse(date.substring(5, 7));
          final lastDay = DateTime(year, month + 1, 0).day;
          final monthEnd = '${date}-${lastDay.toString().padLeft(2, '0')}T23:59:59';
          countQuery = countQuery
              .gte('start_time', monthStart)
              .lte('start_time', monthEnd);
        } else {
          // Day format: YYYY-MM-DD → filter exact day
          final dateStart = '${date}T00:00:00';
          final dateEnd = '${date}T23:59:59';
          countQuery = countQuery
              .gte('start_time', dateStart)
              .lte('start_time', dateEnd);
        }
      }

      final countResponse = await countQuery.count(
        supabase_flutter.CountOption.exact,
      );
      final total = countResponse.count;

      // Build data query
      var dataQuery = _client
          .from('events')
          .select('*, event_types(name)')
          .isFilter('deleted_at', null);

      if (eventTypeId != null && eventTypeId.isNotEmpty) {
        dataQuery = dataQuery.eq('event_type_id', eventTypeId);
      }

      if (query != null && query.isNotEmpty) {
        dataQuery = dataQuery.or('title.ilike.%$query%,description.ilike.%$query%');
      }

      if (date.isNotEmpty) {
        if (date.length == 7) {
          final monthStart = '${date}-01T00:00:00';
          final year = int.parse(date.substring(0, 4));
          final month = int.parse(date.substring(5, 7));
          final lastDay = DateTime(year, month + 1, 0).day;
          final monthEnd = '${date}-${lastDay.toString().padLeft(2, '0')}T23:59:59';
          dataQuery = dataQuery
              .gte('start_time', monthStart)
              .lte('start_time', monthEnd);
        } else {
          final dateStart = '${date}T00:00:00';
          final dateEnd = '${date}T23:59:59';
          dataQuery = dataQuery
              .gte('start_time', dateStart)
              .lte('start_time', dateEnd);
        }
      }

      final data = await dataQuery
          .order('start_time', ascending: true)
          .range(offset, offset + limit - 1);

      final events = (data as List).map((json) {
        // Map DB columns to Event model expected keys
        final mapped = _mapEventJson(json);
        return Event.fromJson(mapped);
      }).toList();

      final totalPages = total > 0 ? (total / limit).ceil() : 1;

      return EventsSearchResponse(
        data: events,
        meta: Meta(
          pagination: Pagination(
            total: total,
            limit: limit,
            offset: offset,
            page: page,
            totalPages: totalPages,
            hasNext: page < totalPages,
            hasPrevious: page > 1,
          ),
          filters: {},
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<EventType>> getEventTypes() async {
    try {
      final data = await _client
          .from('event_types')
          .select()
          .isFilter('deleted_at', null)
          .eq('is_active', true)
          .order('name');

      return (data as List)
          .map((json) => EventType.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Event> getEventById(String eventId) async {
    try {
      // Increment read count
      await _client.rpc(
        'increment_event_read_count',
        params: {'event_id': eventId},
      );

      final data = await _client
          .from('events')
          .select('*, event_types(name)')
          .eq('id', eventId)
          .single();

      return Event.fromJson(_mapEventJson(data));
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Maps DB column names to what Event.fromJson expects
  Map<String, dynamic> _mapEventJson(Map<String, dynamic> json) {
    final eventTypeName =
        json['event_types'] != null ? json['event_types']['name'] ?? '' : '';

    return {
      'id': json['id']?.toString() ?? '',
      'created_at': json['created_at']?.toString() ?? '',
      'updated_at': json['updated_at']?.toString(),
      'deleted_at': json['deleted_at']?.toString(),
      'title': json['title'] ?? '',
      'description': json['description'] ?? '',
      'event_type_id': json['event_type_id']?.toString() ?? '',
      'venue_id': json['venue_id']?.toString() ?? '',
      'venue_name': json['venue_name'] ?? '',
      'start': json['start_time']?.toString() ?? '',
      'end': json['end_time']?.toString() ?? '',
      'schedule_type': json['schedule_type'] ?? 'once',
      'theme': json['theme'] ?? '',
      'agenda': json['agenda'] ?? '',
      'price': json['price']?.toString() ?? '0',
      'contact_person': json['contact_person'] ?? '',
      'phone_no': json['phone_no'] ?? '',
      'email': json['email'] ?? '',
      'age': json['age']?.toString(),
      'capacity': json['capacity']?.toString() ?? '',
      'status': json['status']?.toString(),
      'event_image_id': json['event_image_id']?.toString(),
      'location_latitude': json['location_latitude']?.toString() ?? '',
      'location_longitude': json['location_longitude']?.toString() ?? '',
      'address': json['address'] ?? '',
      'event_type_name': eventTypeName,
    };
  }
}
