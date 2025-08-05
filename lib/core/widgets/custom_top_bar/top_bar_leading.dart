import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../style/app_text_styles.dart';

class TopBarLeading extends StatelessWidget {
  final bool showLogo;
  final bool showBackButton;
  final bool showMenuButton;
  final String? logoPath;
  final double logoHeight;
  final double? logoWidth;
  final EdgeInsets? logoPadding;
  final VoidCallback? onLogoTap;
  final VoidCallback? onMenuTap;

  const TopBarLeading({
    super.key,
    this.showLogo = false,
    this.showBackButton = false,
    this.showMenuButton = false,
    this.logoPath = 'assets/images/logo/logo_line.png',
    this.logoHeight = 52,
    this.logoWidth,
    this.logoPadding,
    this.onLogoTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    if (showLogo) {
      final effectivePadding =
          logoPadding ??
          const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0);
      final effectiveWidth = logoWidth ?? (logoHeight * 2);

      return GestureDetector(
        onTap: onLogoTap,
        child: Container(
          width: double.infinity,
          padding: effectivePadding,
          child: Image.asset(
            logoPath!,
            height: logoHeight,
            width: effectiveWidth,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
            errorBuilder: (context, error, stackTrace) {
              // Logo loading failed, show fallback text
              return Container(
                padding: effectivePadding,
                child: Text(
                  'LOGO',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    if (showBackButton) {
      return IconButton(
        onPressed: () => context.pop(),
        icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
        tooltip: 'Back',
      );
    }

    if (showMenuButton) {
      return IconButton(
        onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
        icon: const FaIcon(FontAwesomeIcons.bars, size: 20),
        tooltip: 'Menu',
      );
    }

    return const SizedBox.shrink();
  }
}
