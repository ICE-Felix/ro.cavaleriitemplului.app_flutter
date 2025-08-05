import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'notification_badge.dart';

class NotificationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final int notificationCount;

  const NotificationButton({
    super.key,
    this.onPressed,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
            tooltip: 'Notifications',
          ),
          if (notificationCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: NotificationBadge(count: notificationCount),
            ),
        ],
      ),
    );
  }
}
