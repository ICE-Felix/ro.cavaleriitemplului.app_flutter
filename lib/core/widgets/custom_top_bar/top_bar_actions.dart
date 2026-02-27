import 'package:app/core/navigation/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'notification_button.dart';
import 'profile_button.dart';
import 'cart_button.dart';
import '../../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../../../features/notifications/presentation/bloc/notification_state.dart';

class TopBarActions extends StatelessWidget {
  final bool showNotificationButton;
  final bool showProfileButton;
  final bool showCartButton;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onCartTap;
  final List<Widget>? customActions;
  final Widget? customRightWidget;

  const TopBarActions({
    super.key,
    this.showNotificationButton = true,
    this.showProfileButton = true,
    this.showCartButton = false,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onProfileTap,
    this.onCartTap,
    this.customActions,
    this.customRightWidget,
  });

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    // Add custom actions first
    if (customActions != null) {
      actions.addAll(customActions!);
    }

    // Add custom right widget
    if (customRightWidget != null) {
      actions.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: customRightWidget!,
        ),
      );
    }

    // Add notification button with live unread count from BLoC
    if (showNotificationButton) {
      actions.add(
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return NotificationButton(
              onPressed: onNotificationTap ??
                  () => context.pushNamed(AppRoutesNames.notifications.name),
              notificationCount: state.unreadCount,
            );
          },
        ),
      );
    }

    // Add cart button (only visible when cart has items)
    if (showCartButton) {
      actions.add(CartButton(onPressed: onCartTap));
    }

    // Add profile button
    if (showProfileButton) {
      actions.add(ProfileButton(onPressed: onProfileTap));
    }

    return Row(mainAxisSize: MainAxisSize.min, children: actions);
  }
}
