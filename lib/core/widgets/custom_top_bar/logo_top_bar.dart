import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../style/app_text_styles.dart';

/// Logo-centered app bar for detail pages
class LogoTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? logoPath;
  final double logoHeight;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final double? elevation;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSharePressed;
  final bool showShareButton;
  final bool isTransparent;
  final bool hasBlur;

  const LogoTopBar({
    super.key,
    this.logoPath = 'assets/images/logo/logo_line.png',
    this.logoHeight = 52,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation,
    this.onBackPressed,
    this.onSharePressed,
    this.showShareButton = true,
    this.isTransparent = false,
    this.hasBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final appBar = AppBar(
      backgroundColor:
          isTransparent
              ? Colors.transparent
              : backgroundColor ?? colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: isTransparent ? 0 : 1,
      surfaceTintColor:
          isTransparent ? Colors.transparent : colorScheme.surfaceTint,
      centerTitle: true,
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
          logoPath != null
              ? Image.asset(
                logoPath!,
                height: logoHeight,
                // fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Logo',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              )
              : null,
      actions: actions ?? _buildDefaultActions(context),
    );

    if (hasBlur && isTransparent) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.8),
            ),
            child: appBar,
          ),
        ),
      );
    }

    return appBar;
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    final actions = <Widget>[];

    if (showShareButton) {
      actions.add(
        IconButton(
          onPressed: onSharePressed,
          icon: const FaIcon(FontAwesomeIcons.share, size: 18),
          tooltip: 'Share',
        ),
      );
    }

    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
