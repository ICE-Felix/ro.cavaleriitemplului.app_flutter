import 'package:app/core/service_locator.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/repository/events_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  EventDetailsCubit() : super(EventDetailsState());

  Future<void> getEventDetails(String eventId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final event = await sl.get<EventsRepository>().getEventById(eventId);
      emit(state.copyWith(isLoading: false, event: event));
    } catch (e) {
      emit(state.copyWith(isError: true, errorMessage: e.toString()));
    }
  }
}
