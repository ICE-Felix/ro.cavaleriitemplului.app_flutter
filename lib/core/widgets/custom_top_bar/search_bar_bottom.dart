import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../style/app_colors.dart';

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
  Size get preferredSize => const Size.fromHeight(72);
}

class _SearchBarBottomState extends State<SearchBarBottom> {
  late final TextEditingController _controller;
  bool _isSearchActive = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
    _controller.addListener(() {
      final active = _controller.text.isNotEmpty;
      if (_isSearchActive != active) {
        setState(() {
          _isSearchActive = active;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.searchController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      widget.onSearchChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        onSubmitted: (_) => widget.onSearchSubmitted?.call(),
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 15, height: 1.3),
        decoration: InputDecoration(
          hintText: widget.searchHint ?? 'Caută articole...',
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey[400],
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 16,
              color: _isSearchActive ? AppColors.primary : Colors.grey[400],
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 0,
          ),
          suffixIcon: _isSearchActive
              ? GestureDetector(
                  onTap: () {
                    _controller.clear();
                    _debounceTimer?.cancel();
                    widget.onSearchChanged?.call('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey[200],
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 0,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
