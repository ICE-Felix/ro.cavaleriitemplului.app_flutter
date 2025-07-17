import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../style/app_colors.dart';
import '../style/app_text_styles.dart';

/// A modern, customizable top app bar following Material Design 3 principles
class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showSearchBar;
  final bool showLocationButton;
  final bool showProfileButton;
  final bool showNotificationButton;
  final bool showMenuButton;
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

  const CustomTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showSearchBar = false,
    this.showLocationButton = false,
    this.showProfileButton = true,
    this.showNotificationButton = true,
    this.showMenuButton = false,
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
      leading: _buildLeading(context),
      leadingWidth: dynamicLeadingWidth,
      centerTitle: centerTitle,
      title: showSearchBar ? null : _buildTitle(context),
      actions: _buildAllActions(context),
      bottom:
          showSearchBar
              ? _SearchBarBottom(
                searchController: searchController,
                onSearchChanged: onSearchChanged,
                onSearchSubmitted: onSearchSubmitted,
                searchHint: searchHint,
              )
              : null,
      flexibleSpace: showLocationButton ? _buildLocationHeader(context) : null,
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;

    return Text(
      title!,
      style: AppTextStyles.titleLarge.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
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
              print('Logo error: $error'); // Debug info
              print('Logo path: $logoPath'); // Debug info
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
    if (showMenuButton) {
      return IconButton(
        onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
        icon: const FaIcon(FontAwesomeIcons.bars, size: 20),
        tooltip: 'Menu',
      );
    }
    return null;
  }

  List<Widget> _buildAllActions(BuildContext context) {
    final actions = <Widget>[];

    if (customActions != null) {
      actions.addAll(customActions!);
    }

    if (showNotificationButton) {
      actions.add(_buildNotificationButton(context));
    }

    if (showProfileButton) {
      actions.add(_buildProfileButton(context));
    }

    return actions;
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: onNotificationTap,
            icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
            tooltip: 'Notifications',
          ),
          if (notificationCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: _NotificationBadge(count: notificationCount),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: IconButton(
        onPressed: onProfileTap,
        icon: CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: FaIcon(
            FontAwesomeIcons.user,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        tooltip: 'Profile',
      ),
    );
  }

  Widget _buildLocationHeader(BuildContext context) {
    if (!showLocationButton) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: onLocationTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    locationText ?? 'Location',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

/// Modern search bar implementation
class _SearchBarBottom extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final String? searchHint;

  const _SearchBarBottom({
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHint,
  });

  @override
  State<_SearchBarBottom> createState() => _SearchBarBottomState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SearchBarBottomState extends State<_SearchBarBottom> {
  late final TextEditingController _controller;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
    _controller.addListener(() {
      setState(() {
        _isSearchActive = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SearchBar(
          controller: _controller,
          hintText: widget.searchHint,
          leading: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18),
          trailing:
              _isSearchActive
                  ? [
                    IconButton(
                      onPressed: () {
                        _controller.clear();
                        widget.onSearchChanged?.call('');
                      },
                      icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                      tooltip: 'Clear search',
                    ),
                  ]
                  : null,
          onChanged: widget.onSearchChanged,
          onSubmitted: (_) => widget.onSearchSubmitted?.call(),
          backgroundColor: WidgetStateProperty.all(
            colorScheme.surfaceContainer,
          ),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          textStyle: WidgetStateProperty.all(
            AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
          ),
          hintStyle: WidgetStateProperty.all(
            AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// Notification badge widget
class _NotificationBadge extends StatelessWidget {
  final int count;

  const _NotificationBadge({required this.count});

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
              color: colorScheme.surface.withOpacity(0.8),
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

/// Floating search bar for overlay search functionality
class FloatingSearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final VoidCallback? onClose;
  final String? hint;
  final bool autoFocus;

  const FloatingSearchBar({
    super.key,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onClose,
    this.hint = 'Search...',
    this.autoFocus = true,
  });

  @override
  State<FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<FloatingSearchBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          autofocus: widget.autoFocus,
          onChanged: widget.onSearchChanged,
          onSubmitted: (_) => widget.onSearchSubmitted?.call(),
          style: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(16),
              child: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: widget.onClose,
              icon: FaIcon(
                FontAwesomeIcons.xmark,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              tooltip: 'Close search',
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}
