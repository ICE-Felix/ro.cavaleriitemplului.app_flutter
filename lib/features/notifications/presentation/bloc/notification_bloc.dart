import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationReceived extends NotificationEvent {
  final RemoteMessage message;

  const NotificationReceived(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationTapped extends NotificationEvent {
  final RemoteMessage message;

  const NotificationTapped(this.message);

  @override
  List<Object> get props => [message];
}

class SubscribeToTopic extends NotificationEvent {
  final String topic;

  const SubscribeToTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

class UnsubscribeFromTopic extends NotificationEvent {
  final String topic;

  const UnsubscribeFromTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationReceiveSuccess extends NotificationState {
  final RemoteMessage message;

  const NotificationReceiveSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationReceived>(_onNotificationReceived);
    on<NotificationTapped>(_onNotificationTapped);
    on<SubscribeToTopic>(_onSubscribeToTopic);
    on<UnsubscribeFromTopic>(_onUnsubscribeFromTopic);
  }

  void _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationReceiveSuccess(event.message));
  }

  void _onNotificationTapped(
    NotificationTapped event,
    Emitter<NotificationState> emit,
  ) {
    // Handle navigation or other actions when notification is tapped
    // You can emit different states based on the message data
    emit(NotificationReceiveSuccess(event.message));
  }

  Future<void> _onSubscribeToTopic(
    SubscribeToTopic event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());
      await FirebaseMessaging.instance.subscribeToTopic(event.topic);
      emit(NotificationInitial());
    } catch (e) {
      emit(NotificationError('Failed to subscribe to topic: ${e.toString()}'));
    }
  }

  Future<void> _onUnsubscribeFromTopic(
    UnsubscribeFromTopic event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());
      await FirebaseMessaging.instance.unsubscribeFromTopic(event.topic);
      emit(NotificationInitial());
    } catch (e) {
      emit(NotificationError('Failed to unsubscribe from topic: ${e.toString()}'));
    }
  }
} 