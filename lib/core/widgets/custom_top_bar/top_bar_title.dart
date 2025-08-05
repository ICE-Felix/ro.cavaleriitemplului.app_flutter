import 'package:flutter/material.dart';
import '../../style/app_text_styles.dart';

class TopBarTitle extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;

  const TopBarTitle({super.key, this.title, this.titleWidget});

  @override
  Widget build(BuildContext context) {
    if (titleWidget != null) return titleWidget!;
    if (title == null) return const SizedBox.shrink();

    return Text(
      title!,
      style: AppTextStyles.titleLarge.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
