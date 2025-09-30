import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';
import 'package:app/features/events/domain/repository/events_repository.dart';

class EventsRepositorySupabase extends EventsRepository {
  final NetworkInfo networkInfo;
  final int limit = 10;
  EventsRepositorySupabase({
    required this.networkInfo,
    required super.eventsDatasource,
  });

  @override
  Future<({List<Event> events, int totalPages})> getEventsSearch({
    required String? eventTypeId,
    required int page,
    required String date,
  }) async {
    if (await networkInfo.isConnected) {
      final response = await eventsDatasource.getEventsSearch(
        eventTypeId: eventTypeId,
        page: page,
        date: date,
        limit: limit,
      );
      return (
        events: response.data,
        totalPages: response.meta.pagination.totalPages,
      );
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<List<EventType>> getEventTypes() async {
    if (await networkInfo.isConnected) {
      return await eventsDatasource.getEventTypes();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<Event> getEventById(String eventId) async {
    if (await networkInfo.isConnected) {
      return await eventsDatasource.getEventById(eventId);
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }
}
