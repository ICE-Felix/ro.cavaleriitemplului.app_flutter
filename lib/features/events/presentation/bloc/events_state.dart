part of 'events_bloc.dart';

enum EventsStatus { init, loading, loaded, error }

class EventsState extends Equatable {
  final DateTime selectedDate;
  final bool isCalendarMinimized;
  final List<Event> events;
  final List<Event> allMonthEvents;
  final List<EventType> eventTypes;
  final EventsStatus status;
  final String message;
  final int totalPages;
  final int currentPage;
  final String? selectedEventTypeId;
  final bool nextPageLoading;

  const EventsState({
    required this.selectedDate,
    this.isCalendarMinimized = false,
    this.events = const [],
    this.allMonthEvents = const [],
    this.eventTypes = const [],
    this.status = EventsStatus.init,
    this.message = '',
    this.totalPages = 0,
    this.currentPage = 1,
    this.selectedEventTypeId,
    this.nextPageLoading = false,
  });

  EventsState copyWith({
    DateTime? selectedDate,
    bool? isCalendarMinimized,
    List<Event>? events,
    List<Event>? allMonthEvents,
    List<EventType>? eventTypes,
    EventsStatus? status,
    String? message,
    int? totalPages,
    int? currentPage,
    Nullable<String>? selectedEventTypeId,
    bool? nextPageLoading,
  }) {
    return EventsState(
      selectedDate: selectedDate ?? this.selectedDate,
      isCalendarMinimized: isCalendarMinimized ?? this.isCalendarMinimized,
      events: events ?? this.events,
      allMonthEvents: allMonthEvents ?? this.allMonthEvents,
      eventTypes: eventTypes ?? this.eventTypes,
      status: status ?? this.status,
      message: message ?? this.message,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      selectedEventTypeId:
          selectedEventTypeId != null
              ? selectedEventTypeId.value
              : this.selectedEventTypeId,
      nextPageLoading: nextPageLoading ?? this.nextPageLoading,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    isCalendarMinimized,
    events,
    allMonthEvents,
    eventTypes,
    status,
    message,
    totalPages,
    currentPage,
    selectedEventTypeId,
    nextPageLoading,
  ];
}
