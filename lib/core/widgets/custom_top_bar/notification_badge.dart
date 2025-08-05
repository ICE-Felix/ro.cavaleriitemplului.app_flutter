import 'package:flutter/material.dart';
import '../../style/app_text_styles.dart';

class NotificationBadge extends StatelessWidget {
  final int count;

  const NotificationBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.surface, width: 2),
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
