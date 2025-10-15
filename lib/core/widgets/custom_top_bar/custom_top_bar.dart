import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'location_header.dart';
import 'search_bar_bottom.dart';
import 'top_bar_actions.dart';
import 'top_bar_leading.dart';
import 'top_bar_title.dart';

/// A modern, customizable top app bar following Material Design 3 principles
class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String? title;
  final Widget? titleWidget;
  final bool showSearchBar;
  final bool showLocationButton;
  final bool showProfileButton;
  final bool showNotificationButton;
  final bool showCartButton;
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
    required this.context,
    this.title,
    this.titleWidget,
    this.showSearchBar = false,
    this.showLocationButton = false,
    this.showProfileButton = true,
    this.showNotificationButton = true,
    this.showCartButton = false,
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

  /// Handle automatic cart navigation
  void _handleCartTap() {
    context.pushNamed(AppRoutesNames.cart.name);
  }

  /// Handle automatic profile navigation
  void _handleProfileTap() {
    context.pushNamed(AppRoutesNames.profile.name);
  }

  /// Factory constructor for a simple top bar with cart button
  factory CustomTopBar.withCart({
    required BuildContext context,
    String? title,
    bool showLogo = false,
    String? logoPath,
    double logoHeight = 52,
    double? logoWidth,
    EdgeInsets? logoPadding,
    bool showBackButton = false,
    bool showNotificationButton = true,
    int notificationCount = 0,
    VoidCallback? onNotificationTap,
    VoidCallback? onLogoTap,
    List<Widget>? customActions,
    Widget? customRightWidget,
  }) {
    return CustomTopBar(
      context: context,
      title: title,
      showCartButton: true,
      showProfileButton: false,
      showBackButton: showBackButton,
      showNotificationButton: showNotificationButton,
      showLogo: showLogo,
      logoPath: logoPath,
      logoHeight: logoHeight,
      logoWidth: logoWidth,
      logoPadding: logoPadding,
      notificationCount: notificationCount,
      onNotificationTap: onNotificationTap,
      onLogoTap: onLogoTap,
      customActions: customActions,
      customRightWidget: customRightWidget,
    );
  }

  /// Factory constructor for a simple top bar with profile button
  factory CustomTopBar.withProfile({
    required BuildContext context,
    String? title,
    bool showLogo = false,
    String? logoPath,
    double logoHeight = 52,
    double? logoWidth,
    EdgeInsets? logoPadding,
    bool showBackButton = false,
    bool showNotificationButton = true,
    int notificationCount = 0,
    VoidCallback? onNotificationTap,
    VoidCallback? onProfileTap,
    VoidCallback? onLogoTap,
    List<Widget>? customActions,
    Widget? customRightWidget,
  }) {
    return CustomTopBar(
      context: context,
      title: title,
      showCartButton: false,
      showProfileButton: true,
      showBackButton: showBackButton,
      showNotificationButton: showNotificationButton,
      showLogo: showLogo,
      logoPath: logoPath,
      logoHeight: logoHeight,
      logoWidth: logoWidth,
      logoPadding: logoPadding,
      notificationCount: notificationCount,
      onNotificationTap: onNotificationTap,
      onProfileTap: onProfileTap,
      onLogoTap: onLogoTap,
      customActions: customActions,
      customRightWidget: customRightWidget,
    );
  }

  /// Factory constructor for a search-enabled top bar with cart
  factory CustomTopBar.withSearchAndCart({
    required BuildContext context,
    String? title,
    String? searchHint,
    TextEditingController? searchController,
    Function(String)? onSearchChanged,
    VoidCallback? onSearchSubmitted,
    bool showLogo = false,
    String? logoPath,
    double logoHeight = 52,
    double? logoWidth,
    EdgeInsets? logoPadding,
    bool showBackButton = false,
    bool showNotificationButton = true,
    int notificationCount = 0,
    VoidCallback? onNotificationTap,
    VoidCallback? onLogoTap,
    List<Widget>? customActions,
    Widget? customRightWidget,
  }) {
    return CustomTopBar(
      context: context,
      title: title,
      showSearchBar: true,
      showCartButton: true,
      showProfileButton: false,
      showBackButton: showBackButton,
      showNotificationButton: showNotificationButton,
      showLogo: showLogo,
      logoPath: logoPath,
      logoHeight: logoHeight,
      logoWidth: logoWidth,
      logoPadding: logoPadding,
      searchHint: searchHint,
      searchController: searchController,
      onSearchChanged: onSearchChanged,
      onSearchSubmitted: onSearchSubmitted,
      notificationCount: notificationCount,
      onNotificationTap: onNotificationTap,
      onLogoTap: onLogoTap,
      customActions: customActions,
      customRightWidget: customRightWidget,
    );
  }

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
          showCartButton: showCartButton,
          notificationCount: notificationCount,
          onNotificationTap: onNotificationTap,
          onProfileTap:
              onProfileTap ?? (showProfileButton ? _handleProfileTap : null),
          onCartTap: showCartButton ? _handleCartTap : null,
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
