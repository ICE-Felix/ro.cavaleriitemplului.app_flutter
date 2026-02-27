import 'package:app/core/service_locator.dart';
import 'package:app/core/utils/nullable.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/events/domain/repository/events_repository.dart';
import 'package:app/core/error/exceptions.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(EventsState(selectedDate: DateTime.now())) {
    on<InitEventsEvent>(_onInitEvents);
    on<SelectDateEvent>(_onSelectDate);
    on<ToggleCalendarMinimizedEvent>(_onToggleCalendarMinimized);
    on<LoadEventsEvent>(_onLoadEvents);
    on<LoadEventsForDateEvent>(_onLoadEventsForDate);
    on<LoadMoreEventsEvent>(_onLoadMoreEvents);
    on<LoadMonthEventsEvent>(_onLoadMonthEvents);
    on<SearchEventsEvent>(_onSearchEvents);
    on<ClearSearchEventsEvent>(_onClearSearchEvents);
  }

  Future<void> _onInitEvents(
    InitEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(status: EventsStatus.loading));

    try {
      // First, get event types
      print('EventsBloc: Loading event types...');
      final eventTypes = await sl<EventsRepository>().getEventTypes();
      print('EventsBloc: Got ${eventTypes.length} event types');

      if (eventTypes.isNotEmpty) {
        // Get today's date in the required format
        final today = DateTime.now();
        final todayString =
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

        // Load events for today
        print('EventsBloc: Loading events for $todayString');
        final result = await sl<EventsRepository>().getEventsSearch(
          eventTypeId: null,
          page: 1,
          date: todayString,
        );
        print('EventsBloc: Got ${result.events.length} events');

        emit(
          state.copyWith(
            eventTypes: eventTypes,
            events: result.events,
            totalPages: result.totalPages,
            currentPage: 1,
            status: EventsStatus.loaded,
            message: '',
            selectedEventTypeId: Nullable(value: null),
          ),
        );

        // Load month events for calendar markers
        add(LoadMonthEventsEvent(today));
      } else {
        // No event types available
        emit(
          state.copyWith(
            eventTypes: eventTypes,
            status: EventsStatus.loaded,
            message: 'No event types available',
          ),
        );
      }
    } on ServerException catch (e) {
      emit(state.copyWith(status: EventsStatus.error, message: e.message));
    } on AuthException catch (e) {
      emit(state.copyWith(status: EventsStatus.error, message: e.message));
    } catch (e) {
      print('EventsBloc: ERROR: $e');
      emit(
        state.copyWith(
          status: EventsStatus.error,
          message: 'An unexpected error occurred: $e',
        ),
      );
    }
  }

  void _onSelectDate(SelectDateEvent event, Emitter<EventsState> emit) {
    emit(state.copyWith(selectedDate: event.date));
    // Automatically load events for the selected date
    add(LoadEventsForDateEvent(event.date));
  }

  void _onToggleCalendarMinimized(
    ToggleCalendarMinimizedEvent event,
    Emitter<EventsState> emit,
  ) {
    emit(state.copyWith(isCalendarMinimized: !state.isCalendarMinimized));
  }

  Future<void> _onLoadEvents(
    LoadEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(status: EventsStatus.loading));

    try {
      final result = await sl<EventsRepository>().getEventsSearch(
        eventTypeId: event.eventType,
        page: event.page,
        date: event.date,
        query: (event.query ?? state.searchQuery).isEmpty ? null : (event.query ?? state.searchQuery),
      );

      emit(
        state.copyWith(
          events: result.events,
          totalPages: result.totalPages,
          currentPage: 1,
          status: EventsStatus.loaded,
          message: '',
          selectedEventTypeId: Nullable(value: event.eventType),
        ),
      );
    } on ServerException catch (e) {
      emit(state.copyWith(status: EventsStatus.error, message: e.message));
    } on AuthException catch (e) {
      emit(state.copyWith(status: EventsStatus.error, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: EventsStatus.error,
          message: 'An unexpected error occurred: $e',
        ),
      );
    }
  }

  Future<void> _onLoadEventsForDate(
    LoadEventsForDateEvent event,
    Emitter<EventsState> emit,
  ) async {
    // Format date to string for API call
    final dateString =
        '${event.date.year}-${event.date.month.toString().padLeft(2, '0')}-${event.date.day.toString().padLeft(2, '0')}';

    // Load events for the selected date with current event type
    add(
      LoadEventsEvent(
        eventType: state.selectedEventTypeId,
        page: 1, // Start with first page
        date: dateString,
      ),
    );
  }

  Future<void> _onLoadMoreEvents(
    LoadMoreEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    // Don't load more if we're already at the last page or currently loading
    if (state.currentPage >= state.totalPages ||
        state.status == EventsStatus.loading ||
        state.nextPageLoading) {
      return;
    }

    emit(state.copyWith(nextPageLoading: true));

    final nextPage = state.currentPage + 1;

    // When searching, don't filter by date
    final dateString = state.searchQuery.isNotEmpty
        ? ''
        : '${state.selectedDate.year}-${state.selectedDate.month.toString().padLeft(2, '0')}-${state.selectedDate.day.toString().padLeft(2, '0')}';

    try {
      final result = await sl<EventsRepository>().getEventsSearch(
        eventTypeId: state.selectedEventTypeId,
        page: nextPage,
        date: dateString,
        query: state.searchQuery.isEmpty ? null : state.searchQuery,
      );

      // Append new events to existing ones
      final updatedEvents = [...state.events, ...result.events];

      emit(
        state.copyWith(
          events: updatedEvents,
          currentPage: nextPage,
          status: EventsStatus.loaded,
          message: '',
          nextPageLoading: false,
        ),
      );
    } on ServerException catch (e) {
      emit(state.copyWith(status: EventsStatus.error, message: e.message));
    } on AuthException catch (e) {
      emit(state.copyWith(status: EventsStatus.error, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: EventsStatus.error,
          message: 'An unexpected error occurred: $e',
        ),
      );
    }
  }

  Future<void> _onLoadMonthEvents(
    LoadMonthEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    // Format as YYYY-MM to load all events for the month
    final monthString =
        '${event.month.year}-${event.month.month.toString().padLeft(2, '0')}';

    try {
      // Load all events for the month (large limit for calendar markers)
      final result = await sl<EventsRepository>().getEventsSearch(
        eventTypeId: null,
        page: 1,
        date: monthString,
      );

      // Update only the allMonthEvents field
      emit(state.copyWith(allMonthEvents: result.events));
    } catch (e) {
      // Silently fail for month events to not disrupt the main flow
    }
  }

  Future<void> _onSearchEvents(
    SearchEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, status: EventsStatus.loading));

    try {
      final result = await sl<EventsRepository>().getEventsSearch(
        eventTypeId: state.selectedEventTypeId,
        page: 1,
        date: '',
        query: event.query,
      );

      emit(
        state.copyWith(
          events: result.events,
          totalPages: result.totalPages,
          currentPage: 1,
          status: EventsStatus.loaded,
          message: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EventsStatus.error,
          message: 'An unexpected error occurred: $e',
        ),
      );
    }
  }

  void _onClearSearchEvents(
    ClearSearchEventsEvent event,
    Emitter<EventsState> emit,
  ) {
    emit(state.copyWith(searchQuery: ''));
    add(LoadEventsForDateEvent(state.selectedDate));
  }
}
