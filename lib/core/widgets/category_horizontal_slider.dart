import 'dart:math';

import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryHorizontalSlider<T> extends StatefulWidget {
  final List<T> items;
  final Function(T? item) onSelectionChanged;
  final int itemsPerPage;
  final String Function(T item) getDisplayName;
  final T? selectedItem;
  final String Function(T item)? getItemId;
  final String? selectedItemId;
  final double height;
  final bool canUnselect;
  final bool autoSelectFirstItem;

  const CategoryHorizontalSlider({
    super.key,
    required this.items,
    required this.getDisplayName,
    required this.onSelectionChanged,
    this.itemsPerPage = 5,
    this.selectedItem,
    this.getItemId,
    this.selectedItemId,
    this.height = 32,
    this.canUnselect = false,
    this.autoSelectFirstItem = true,
  });

  @override
  State<CategoryHorizontalSlider<T>> createState() =>
      _CategoryHorizontalSliderState<T>();
}

class _CategoryHorizontalSliderState<T>
    extends State<CategoryHorizontalSlider<T>> {
  int currentPage = 0;
  T? _internalSelectedItem;
  late int numberOfPages;

  @override
  void initState() {
    super.initState();
    numberOfPages = _computePages(widget.items.length, widget.itemsPerPage);
    _internalSelectedItem =
        widget.selectedItem ??
        (widget.autoSelectFirstItem ? widget.items.firstOrNull : null);
  }

  @override
  void didUpdateWidget(covariant CategoryHorizontalSlider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newPages = _computePages(widget.items.length, widget.itemsPerPage);
    if (newPages != numberOfPages ||
        widget.itemsPerPage != oldWidget.itemsPerPage) {
      numberOfPages = newPages;
      if (currentPage >= numberOfPages) {
        currentPage = numberOfPages == 0 ? 0 : numberOfPages - 1;
      }
    }

    // In uncontrolled mode keep selection valid after items change
    if (widget.selectedItem == null && widget.selectedItemId == null) {
      if (_internalSelectedItem != null &&
          !widget.items.contains(_internalSelectedItem)) {
        _internalSelectedItem =
            widget.autoSelectFirstItem ? widget.items.firstOrNull : null;
      } else if (_internalSelectedItem == null &&
          widget.autoSelectFirstItem &&
          widget.items.isNotEmpty) {
        // Auto-select first item if no selection and autoSelectFirstItem is true
        _internalSelectedItem = widget.items.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink(child: Center(child: Text('No items')));
    }
    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          _NavButton(icon: Icons.chevron_left, onTap: _onPreviousPage),
          Expanded(
            child: Row(
              children:
                  _getItemsForPage().map((item) {
                    final isSelected = _isSelected(item);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            final isCurrentlySelected = _isSelected(item);

                            // If item is already selected and canUnselect is false, do nothing
                            if (isCurrentlySelected && !widget.canUnselect) {
                              return;
                            }

                            if (widget.selectedItem == null &&
                                widget.selectedItemId == null) {
                              // Uncontrolled mode: toggle selection (only if canUnselect allows it)
                              setState(() {
                                _internalSelectedItem =
                                    (isCurrentlySelected && widget.canUnselect)
                                        ? null
                                        : item;
                              });
                            }

                            // Call callback with null if deselecting (and canUnselect is true), item if selecting
                            widget.onSelectionChanged(
                              (isCurrentlySelected && widget.canUnselect)
                                  ? null
                                  : item,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade300,
                              ),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Center(
                              child: Text(
                                widget.getDisplayName(item),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          _NavButton(icon: Icons.chevron_right, onTap: _onNextPage),
        ],
      ),
    );
  }

  List<T> _getItemsForPage() {
    return widget.items.sublist(
      currentPage * widget.itemsPerPage,
      min((currentPage + 1) * widget.itemsPerPage, widget.items.length),
    );
  }

  void _onNextPage() {
    _changePage(currentPage + 1);
  }

  void _onPreviousPage() {
    _changePage(currentPage - 1);
  }

  void _changePage(int page) {
    if (page < 0) {
      setState(() {
        currentPage = numberOfPages - 1;
      });
    } else if (page >= numberOfPages) {
      setState(() {
        currentPage = 0;
      });
    } else {
      setState(() {
        currentPage = page;
      });
    }
  }

  bool _isSelected(T item) {
    if (widget.selectedItemId != null && widget.getItemId != null) {
      return widget.getItemId!(item) == widget.selectedItemId;
    }
    if (widget.selectedItem != null) {
      return widget.selectedItem == item;
    }
    return _internalSelectedItem != null && _internalSelectedItem == item;
  }

  int _computePages(int totalItems, int perPage) {
    if (perPage <= 0) return 0;
    return (totalItems / perPage).ceil();
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}
