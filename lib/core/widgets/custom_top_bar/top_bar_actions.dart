import 'package:flutter/material.dart';
import 'notification_button.dart';
import 'profile_button.dart';
import 'cart_button.dart';

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

    // Add notification button
    if (showNotificationButton) {
      actions.add(
        NotificationButton(
          onPressed: onNotificationTap,
          notificationCount: notificationCount,
        ),
      );
    }

    // Add cart button
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
