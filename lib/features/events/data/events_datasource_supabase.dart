import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/dio_client.dart';
import 'package:app/features/events/data/events_datasource.dart';
import 'package:app/features/events/data/model/events_search_responce.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';

class EventsDatasourceSupabase implements EventsDatasource {
  final DioClient dio;
  EventsDatasourceSupabase({required this.dio});
  @override
  Future<EventsSearchResponse> getEventsSearch({
    required String? eventTypeId,
    required int page,
    required int limit,
    required String date,
  }) async {
    try {
      final response = await dio.get(
        '/events',
        queryParameters: {
          if (eventTypeId != null) 'event_type_id': eventTypeId,
          'page': page,
          'limit': limit,
          'date': date,
        },
      );
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      return EventsSearchResponse.fromJson(response);
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<EventType>> getEventTypes() async {
    try {
      final response = await dio.get('/event_types');
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      return (response['data'] as List<dynamic>)
          .map((e) => EventType.fromJson(e))
          .toList();
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Event> getEventById(String eventId) async {
    try {
      final response = await dio.get('/events/$eventId');
      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      return Event.fromJson(response['data']);
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
