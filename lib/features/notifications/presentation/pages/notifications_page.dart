import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/service_locator.dart';
import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationBloc>()..add(const LoadNotifications()),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomTopBar.withProfile(
        context: context,
        title: 'Notificari',
        showBackButton: true,
        showNotificationButton: false,
        onNotificationTap: () =>
            context.pushNamed(AppRoutesNames.notifications.name),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Eroare la incarcarea notificarilor',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => context
                        .read<NotificationBloc>()
                        .add(const LoadNotifications()),
                    child: const Text('Reincearca'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none,
                        size: 64, color: colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('Nu ai notificari',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.outline,
                        )),
                  ],
                ),
              );
            }

            return Column(
              children: [
                if (state.unreadCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.unreadCount} necitite',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context
                              .read<NotificationBloc>()
                              .add(const MarkAllAsRead()),
                          child: const Text('Marcheaza toate ca citite'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<NotificationBloc>()
                          .add(const LoadNotifications());
                    },
                    child: ListView.builder(
                      itemCount: state.notifications.length +
                          (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.notifications.length) {
                          // Load more trigger
                          context
                              .read<NotificationBloc>()
                              .add(const LoadMoreNotifications());
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child:
                                Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _NotificationTile(
                          notification: state.notifications[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const _NotificationTile({required this.notification});

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'acum';
    if (diff.inMinutes < 60) return 'acum ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'acum ${diff.inHours} ore';
    if (diff.inDays < 7) return 'acum ${diff.inDays} zile';
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: notification.isRead
          ? null
          : colorScheme.primaryContainer.withValues(alpha: 0.15),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: notification.isRead
              ? colorScheme.surfaceContainerHighest
              : colorScheme.primary,
          child: Icon(
            Icons.notifications,
            color: notification.isRead
                ? colorScheme.outline
                : Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimeAgo(notification.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            context
                .read<NotificationBloc>()
                .add(MarkAsRead(notification.id));
          }
        },
      ),
    );
  }
}
