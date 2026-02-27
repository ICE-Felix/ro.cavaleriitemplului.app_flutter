import 'package:bloc/bloc.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  static const int _pageSize = 20;

  NotificationBloc({required this.repository})
      : super(const NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<LoadMoreNotifications>(_onLoadMore);
    on<RefreshUnreadCount>(_onRefreshUnreadCount);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<FcmNotificationReceived>(_onFcmReceived);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading(unreadCount: state.unreadCount));
      final notifications = await repository.getNotifications(page: 1, limit: _pageSize);
      final unreadCount = await repository.getUnreadCount();
      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
        hasMore: notifications.length >= _pageSize,
        currentPage: 1,
      ));
    } catch (e) {
      emit(NotificationError(e.toString(), unreadCount: state.unreadCount));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded || !currentState.hasMore) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final moreNotifications =
          await repository.getNotifications(page: nextPage, limit: _pageSize);
      emit(NotificationLoaded(
        notifications: [...currentState.notifications, ...moreNotifications],
        unreadCount: currentState.unreadCount,
        hasMore: moreNotifications.length >= _pageSize,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(NotificationError(e.toString(), unreadCount: state.unreadCount));
    }
  }

  Future<void> _onRefreshUnreadCount(
    RefreshUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final unreadCount = await repository.getUnreadCount();
      final currentState = state;
      if (currentState is NotificationLoaded) {
        emit(NotificationLoaded(
          notifications: currentState.notifications,
          unreadCount: unreadCount,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
        ));
      } else {
        emit(NotificationInitial(unreadCount: unreadCount));
      }
    } catch (_) {
      // Silently fail for badge refresh
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.markAsRead(event.notificationId);
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updated = currentState.notifications.map((n) {
          if (n.id == event.notificationId && !n.isRead) {
            return NotificationEntity(
              id: n.id,
              title: n.title,
              body: n.body,
              targetType: n.targetType,
              targetUserId: n.targetUserId,
              data: n.data,
              createdAt: n.createdAt,
              isRead: true,
            );
          }
          return n;
        }).toList();
        final newUnread = (currentState.unreadCount - 1).clamp(0, 999);
        emit(NotificationLoaded(
          notifications: updated,
          unreadCount: newUnread,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
        ));
      }
    } catch (e) {
      emit(NotificationError(e.toString(), unreadCount: state.unreadCount));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.markAllAsRead();
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updated = currentState.notifications
            .map((n) => NotificationEntity(
                  id: n.id,
                  title: n.title,
                  body: n.body,
                  targetType: n.targetType,
                  targetUserId: n.targetUserId,
                  data: n.data,
                  createdAt: n.createdAt,
                  isRead: true,
                ))
            .toList();
        emit(NotificationLoaded(
          notifications: updated,
          unreadCount: 0,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
        ));
      } else {
        emit(const NotificationInitial(unreadCount: 0));
      }
    } catch (e) {
      emit(NotificationError(e.toString(), unreadCount: state.unreadCount));
    }
  }

  Future<void> _onFcmReceived(
    FcmNotificationReceived event,
    Emitter<NotificationState> emit,
  ) async {
    // Refresh the unread count and reload notifications if already loaded
    try {
      final unreadCount = await repository.getUnreadCount();
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final notifications =
            await repository.getNotifications(page: 1, limit: _pageSize);
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
          hasMore: notifications.length >= _pageSize,
          currentPage: 1,
        ));
      } else {
        emit(NotificationInitial(unreadCount: unreadCount));
      }
    } catch (_) {
      // Silently fail
    }
  }
}
