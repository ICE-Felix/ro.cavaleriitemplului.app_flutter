import 'package:flutter/material.dart';
import 'location_header.dart';
import 'search_bar_bottom.dart';
import 'top_bar_actions.dart';
import 'top_bar_leading.dart';
import 'top_bar_title.dart';

/// A modern, customizable top app bar following Material Design 3 principles
class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showSearchBar;
  final bool showLocationButton;
  final bool showProfileButton;
  final bool showNotificationButton;
  final bool showMenuButton;
  final bool showBackButton;
  final bool showLogo;
  final String? logoPath;
  final double logoHeight;
  final double? logoWidth;
  final EdgeInsets? logoPadding;
  final int notificationCount;
  final String? locationText;
  final String? searchHint;
  final VoidCallback? onLocationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final TextEditingController? searchController;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final List<Widget>? customActions;
  final Widget? customRightWidget;

  const CustomTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showSearchBar = false,
    this.showLocationButton = false,
    this.showProfileButton = true,
    this.showNotificationButton = true,
    this.showMenuButton = false,
    this.showBackButton = false,
    this.showLogo = false,
    this.logoPath = 'assets/images/logo/logo_line.png',
    this.logoHeight = 52,
    this.logoWidth,
    this.logoPadding,
    this.notificationCount = 0,
    this.locationText,
    this.searchHint = 'Search...',
    this.onLocationTap,
    this.onProfileTap,
    this.onNotificationTap,
    this.onMenuTap,
    this.onLogoTap,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchController,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
    this.customActions,
    this.customRightWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate dynamic leading width for logo
    double? dynamicLeadingWidth;
    if (showLogo) {
      final effectiveWidth = logoWidth ?? (logoHeight * 2);
      final effectivePadding =
          logoPadding ??
          const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0);
      dynamicLeadingWidth =
          effectiveWidth +
          effectivePadding.left +
          effectivePadding.right +
          20; // Extra space
    }

    return AppBar(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: colorScheme.surfaceTint,
      automaticallyImplyLeading: showMenuButton && !showLogo,
      leading: TopBarLeading(
        showLogo: showLogo,
        showBackButton: showBackButton,
        showMenuButton: showMenuButton,
        logoPath: logoPath,
        logoHeight: logoHeight,
        logoWidth: logoWidth,
        logoPadding: logoPadding,
        onLogoTap: onLogoTap,
        onMenuTap: onMenuTap,
      ),
      leadingWidth: dynamicLeadingWidth,
      centerTitle: centerTitle,
      title:
          showSearchBar
              ? null
              : TopBarTitle(title: title, titleWidget: titleWidget),
      actions: [
        TopBarActions(
          showNotificationButton: showNotificationButton,
          showProfileButton: showProfileButton,
          notificationCount: notificationCount,
          onNotificationTap: onNotificationTap,
          onProfileTap: onProfileTap,
          customActions: customActions,
          customRightWidget: customRightWidget,
        ),
      ],
      bottom:
          showSearchBar
              ? SearchBarBottom(
                searchController: searchController,
                onSearchChanged: onSearchChanged,
                onSearchSubmitted: onSearchSubmitted,
                searchHint: searchHint,
              )
              : null,
      flexibleSpace:
          showLocationButton
              ? LocationHeader(
                locationText: locationText,
                onLocationTap: onLocationTap,
              )
              : null,
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (showSearchBar) height += 80;
    if (showLocationButton) height += 32;
    return Size.fromHeight(height);
  }
}
