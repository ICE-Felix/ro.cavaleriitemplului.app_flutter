import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  const LoadNotifications();
}

class LoadMoreNotifications extends NotificationEvent {
  const LoadMoreNotifications();
}

class RefreshUnreadCount extends NotificationEvent {
  const RefreshUnreadCount();
}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {
  const MarkAllAsRead();
}

class FcmNotificationReceived extends NotificationEvent {
  final RemoteMessage message;

  const FcmNotificationReceived(this.message);

  @override
  List<Object?> get props => [message];
}
