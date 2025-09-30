part of 'event_details_cubit.dart';

class EventDetailsState extends Equatable {
  const EventDetailsState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.event,
  });
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final Event? event;

  EventDetailsState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    Event? event,
  }) {
    return EventDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      event: event ?? this.event,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage, event];
}
