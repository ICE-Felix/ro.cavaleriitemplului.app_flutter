import 'package:flutter/material.dart';
import '../../services/app_settings_service.dart';
import '../../style/app_colors.dart';
import '../../style/app_text_styles.dart';

class TopBarTitle extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;

  const TopBarTitle({super.key, this.title, this.titleWidget});

  @override
  Widget build(BuildContext context) {
    if (titleWidget != null) return titleWidget!;

    final displayTitle = title ?? AppSettingsService.instance.appName;
    if (displayTitle.isEmpty) return const SizedBox.shrink();

    // When showing the app name (no explicit title), use primary + bold style
    final isAppName = title == null;

    return Text(
      displayTitle,
      style: isAppName
          ? AppTextStyles.titleLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            )
          : AppTextStyles.titleLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
    );
  }
}
