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
  final bool showAllButton;
  final String allButtonText;

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
    this.showAllButton = false,
    this.allButtonText = 'All',
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
  bool _isAllSelected = false;

  @override
  void initState() {
    super.initState();
    numberOfPages = _computePages(_getTotalItems(), widget.itemsPerPage);
    _initializeSelection();
  }

  void _initializeSelection() {
    if (widget.showAllButton) {
      // When All button is shown, default to All selected (no item selected)
      _isAllSelected =
          widget.selectedItem == null && widget.selectedItemId == null;
      _internalSelectedItem = null;
    } else {
      _internalSelectedItem =
          widget.selectedItem ??
          (widget.autoSelectFirstItem ? widget.items.firstOrNull : null);
    }
  }

  @override
  void didUpdateWidget(covariant CategoryHorizontalSlider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newPages = _computePages(_getTotalItems(), widget.itemsPerPage);
    if (newPages != numberOfPages ||
        widget.itemsPerPage != oldWidget.itemsPerPage ||
        widget.showAllButton != oldWidget.showAllButton) {
      numberOfPages = newPages;
      if (currentPage >= numberOfPages) {
        currentPage = numberOfPages == 0 ? 0 : numberOfPages - 1;
      }
    }

    // In uncontrolled mode keep selection valid after items change
    if (widget.selectedItem == null && widget.selectedItemId == null) {
      if (widget.showAllButton) {
        // When All button is shown, check if current selection is still valid
        if (_internalSelectedItem != null &&
            !widget.items.contains(_internalSelectedItem)) {
          _isAllSelected = true;
          _internalSelectedItem = null;
        }
      } else {
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
  }

  int _getTotalItems() {
    // When showAllButton is true, we show the "All" button plus regular items
    // But we need to account for pagination properly
    if (widget.showAllButton) {
      return widget.items.length + 1; // +1 for the "All" button
    }
    return widget.items.length;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && !widget.showAllButton) {
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
                                if (item == null) {
                                  // This is the "All" button
                                  _isAllSelected = true;
                                  _internalSelectedItem = null;
                                } else {
                                  _isAllSelected = false;
                                  _internalSelectedItem =
                                      (isCurrentlySelected &&
                                              widget.canUnselect)
                                          ? null
                                          : item;
                                }
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
                                item == null
                                    ? widget.allButtonText
                                    : widget.getDisplayName(item),
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

  List<T?> _getItemsForPage() {
    final List<T?> items = [];

    if (widget.showAllButton) {
      // When "All" button is shown, it's always the first item
      // and we need to adjust pagination for regular items
      if (currentPage == 0) {
        // First page: show "All" button + some regular items
        items.add(null); // "All" button
        final remainingSlots = widget.itemsPerPage - 1;
        final endIndex = min(remainingSlots, widget.items.length);
        if (endIndex > 0) {
          items.addAll(widget.items.sublist(0, endIndex));
        }
      } else {
        // Subsequent pages: only regular items
        final startIndex =
            (currentPage - 1) * widget.itemsPerPage + (widget.itemsPerPage - 1);
        final endIndex = min(
          startIndex + widget.itemsPerPage,
          widget.items.length,
        );
        if (startIndex < widget.items.length) {
          items.addAll(widget.items.sublist(startIndex, endIndex));
        }
      }
    } else {
      // No "All" button, normal pagination
      final startIndex = currentPage * widget.itemsPerPage;
      final endIndex = min(
        (currentPage + 1) * widget.itemsPerPage,
        widget.items.length,
      );
      if (startIndex < widget.items.length) {
        items.addAll(widget.items.sublist(startIndex, endIndex));
      }
    }

    return items;
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

  bool _isSelected(T? item) {
    // Handle "All" button (null item)
    if (item == null) {
      if (widget.selectedItem == null && widget.selectedItemId == null) {
        return _isAllSelected;
      }
      return false; // "All" is not selected if there's a specific selection
    }

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

    if (widget.showAllButton) {
      // When "All" button is shown, we need special pagination logic
      if (widget.items.isEmpty) return 1; // Just the "All" button

      // First page has "All" button + (perPage - 1) regular items
      // Remaining items need (items.length - (perPage - 1)) / perPage pages
      final remainingItems = widget.items.length - (perPage - 1);
      if (remainingItems <= 0) return 1; // Only first page needed

      return 1 + (remainingItems / perPage).ceil();
    }

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
