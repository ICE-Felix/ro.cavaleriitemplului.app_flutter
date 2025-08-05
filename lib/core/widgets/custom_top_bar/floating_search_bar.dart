import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../style/app_text_styles.dart';

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
              color: colorScheme.shadow.withValues(alpha: 0.1),
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
