import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../style/app_text_styles.dart';

/// Compact app bar for simpler layouts
class CompactTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double? elevation;
  final VoidCallback? onBackPressed;

  const CompactTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: colorScheme.surfaceTint,
      centerTitle: centerTitle,
      leading:
          leading ??
          (ModalRoute.of(context)?.canPop == true
              ? IconButton(
                onPressed: onBackPressed ?? () => context.pop(),
                icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
                tooltip: 'Back',
              )
              : null),
      title:
          titleWidget ??
          (title != null
              ? Text(
                title!,
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
