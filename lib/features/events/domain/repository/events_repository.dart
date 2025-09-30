import 'package:app/features/events/data/events_datasource.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';

abstract class EventsRepository {
  final EventsDatasource eventsDatasource;
  EventsRepository({required this.eventsDatasource});
  Future<({List<Event> events, int totalPages})> getEventsSearch({
    required String? eventTypeId,
    required int page,
    required String date,
  });
  Future<List<EventType>> getEventTypes();
  Future<Event> getEventById(String eventId);
}
