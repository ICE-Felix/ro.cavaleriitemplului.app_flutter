import 'package:app/features/events/data/model/events_search_responce.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';

abstract class EventsDatasource {
  Future<EventsSearchResponse> getEventsSearch({
    required String? eventTypeId,
    required int page,
    required int limit,
    required String date,
  });
  Future<List<EventType>> getEventTypes();
  Future<Event> getEventById(String eventId);
}
