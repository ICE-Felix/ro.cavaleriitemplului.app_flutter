import 'package:app/features/events/data/events_datasource.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';
import 'package:app/features/events/domain/repository/events_repository.dart';

class EventsRepositoryMock extends EventsRepository {
  final int limit = 10;

  EventsRepositoryMock({
    required super.eventsDatasource,
  });

  @override
  Future<({List<Event> events, int totalPages})> getEventsSearch({
    required String? eventTypeId,
    required int page,
    required String date,
  }) async {
    // No network check - directly use datasource for mock data
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
  }

  @override
  Future<List<EventType>> getEventTypes() async {
    // No network check - directly use datasource for mock data
    return await eventsDatasource.getEventTypes();
  }

  @override
  Future<Event> getEventById(String eventId) async {
    // No network check - directly use datasource for mock data
    return await eventsDatasource.getEventById(eventId);
  }
}
