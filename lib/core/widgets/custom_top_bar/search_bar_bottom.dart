import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../style/app_text_styles.dart';

class SearchBarBottom extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final String? searchHint;

  const SearchBarBottom({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHint,
  });

  @override
  State<SearchBarBottom> createState() => _SearchBarBottomState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SearchBarBottomState extends State<SearchBarBottom> {
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
