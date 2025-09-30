part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class InitEventsEvent extends EventsEvent {
  const InitEventsEvent();
}

class SelectDateEvent extends EventsEvent {
  final DateTime date;

  const SelectDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class ToggleCalendarMinimizedEvent extends EventsEvent {
  const ToggleCalendarMinimizedEvent();
}

class LoadEventsEvent extends EventsEvent {
  final String? eventType;
  final int page;
  final String date;

  const LoadEventsEvent({
    required this.eventType,
    required this.page,
    required this.date,
  });

  @override
  List<Object?> get props => [eventType, page, date];
}

class LoadEventsForDateEvent extends EventsEvent {
  final DateTime date;

  const LoadEventsForDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class LoadMoreEventsEvent extends EventsEvent {
  const LoadMoreEventsEvent();
}
