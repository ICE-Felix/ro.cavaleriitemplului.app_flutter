import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  final int unreadCount;

  const NotificationState({this.unreadCount = 0});

  @override
  List<Object?> get props => [unreadCount];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial({super.unreadCount});
}

class NotificationLoading extends NotificationState {
  const NotificationLoading({super.unreadCount});
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final int currentPage;

  const NotificationLoaded({
    required this.notifications,
    required super.unreadCount,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, hasMore, currentPage];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message, {super.unreadCount});

  @override
  List<Object?> get props => [message, unreadCount];
}
