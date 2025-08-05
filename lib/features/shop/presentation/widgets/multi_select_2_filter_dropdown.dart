import 'package:app/core/utils/string_operations.dart';
import 'package:flutter/material.dart';

class MultiSelect2FilterDropdown<ValueType, ReturnType> extends StatefulWidget {
  final List<ValueType> items;
  final List<ReturnType> selectedValues;
  final Widget Function(ValueType value) builderFunction;
  final ReturnType Function(ValueType value) valueExtractor;
  final String Function(ValueType value) searchExtractor;
  final ValueChanged<List<ReturnType>>? onChanged;
  final String? filterText;
  final String? searchHintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? maxHeight;
  final double? overlayWidth;
  final EdgeInsets? padding;
  final TextStyle? filterTextStyle;
  final TextStyle? selectedTextStyle;
  final TextStyle? searchTextStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? buttonColor;
  final double borderRadius;
  final bool enabled;
  final bool showSelectedCount;

  const MultiSelect2FilterDropdown({
    super.key,
    required this.items,
    required this.builderFunction,
    required this.valueExtractor,
    required this.searchExtractor,
    this.selectedValues = const [],
    this.onChanged,
    this.filterText,
    this.searchHintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxHeight = 300.0,
    this.overlayWidth,
    this.padding,
    this.filterTextStyle,
    this.selectedTextStyle,
    this.searchTextStyle,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.buttonColor,
    this.borderRadius = 8.0,
    this.enabled = true,
    this.showSelectedCount = true,
  });

  @override
  State<MultiSelect2FilterDropdown<ValueType, ReturnType>> createState() =>
      _MultiSelect2FilterDropdownState<ValueType, ReturnType>();
}

class _MultiSelect2FilterDropdownState<ValueType, ReturnType>
    extends State<MultiSelect2FilterDropdown<ValueType, ReturnType>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final UniqueKey _tapRegionKey = UniqueKey();
  bool _isOpen = false;
  late List<ReturnType> _selectedValues;
  List<ValueType> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues);
    _filteredItems = List.from(widget.items);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(
    MultiSelect2FilterDropdown<ValueType, ReturnType> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValues != oldWidget.selectedValues) {
      _selectedValues = List.from(widget.selectedValues);
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = List.from(widget.items);
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = StringOperations.normalize(
      _searchController.text.toLowerCase(),
    );
    setState(() {
      _filteredItems =
          widget.items.where((item) {
            final searchText = StringOperations.normalize(
              widget.searchExtractor(item).toLowerCase(),
            );
            return searchText.contains(query);
          }).toList();
    });
    _updateOverlay();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_overlayEntry != null) return;

    _searchController.clear();
    _filteredItems = List.from(widget.items);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });

    // Focus the search field after a brief delay to ensure the overlay is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchFocusNode.unfocus();
    if (context.mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final overlayWidth =
        widget.overlayWidth ?? (size.width * 1.5).clamp(250.0, 400.0);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: overlayWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 4.0),
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: widget.maxHeight ?? 300.0,
                      ),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        border: Border.all(
                          color: widget.borderColor ?? Colors.grey[300]!,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TapRegion(
                        groupId: _tapRegionKey,
                        onTapOutside: (_) {
                          _closeDropdown();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Search box at the top of overlay
                              _buildSearchBox(),
                              // Divider
                              Divider(height: 1, color: Colors.grey[300]),
                              // Items list
                              Flexible(
                                child: _buildDropdownItems(setOverlayState),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: widget.searchHintText ?? 'Search...',
          hintStyle:
              widget.searchTextStyle?.copyWith(color: Colors.grey[600]) ??
              TextStyle(color: Colors.grey[600], fontSize: 14.0),
          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          isDense: true,
        ),
        style: widget.searchTextStyle ?? const TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _buildDropdownItems([StateSetter? setOverlayState]) {
    if (_filteredItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No items found',
          style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final value = widget.valueExtractor(item);
        final isSelected = _selectedValues.contains(value);

        return InkWell(
          onTap: () => _toggleSelection(value, setOverlayState),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.1) : null,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleSelection(value, setOverlayState),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8.0),
                Expanded(child: widget.builderFunction(item)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleSelection(ReturnType value, [StateSetter? setOverlayState]) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        _selectedValues.add(value);
      }
    });

    // Also update the overlay state to immediately reflect checkbox changes
    setOverlayState?.call(() {});

    widget.onChanged?.call(List.from(_selectedValues));
  }

  String _getButtonText() {
    if (_selectedValues.isEmpty) {
      return widget.filterText ?? 'Filters';
    }

    if (!widget.showSelectedCount) {
      return widget.filterText ?? 'Filters';
    }

    final count = _selectedValues.length;
    final filterText = widget.filterText ?? 'Filters';
    if (count == 1) {
      return '1 $filterText Applied';
    } else {
      return '$count $filterText Applied';
    }
  }

  Widget _getButtonIcon() {
    return widget.prefixIcon ?? const Icon(Icons.filter_list, size: 18);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TapRegion(
        groupId: _tapRegionKey,
        onTapOutside: (_) => _closeDropdown,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.enabled ? _toggleDropdown : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color:
                    widget.buttonColor ??
                    (_selectedValues.isNotEmpty
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey[100]),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color:
                      _isOpen
                          ? (widget.focusedBorderColor ?? Colors.blue)
                          : (widget.borderColor ??
                              (_selectedValues.isNotEmpty
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey[300]!)),
                  width: _isOpen ? 2.0 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getButtonIcon(),
                  const SizedBox(width: 6.0),
                  Text(
                    _getButtonText(),
                    style:
                        _selectedValues.isEmpty
                            ? (widget.filterTextStyle ??
                                TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ))
                            : (widget.selectedTextStyle ??
                                const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                )),
                  ),
                  const SizedBox(width: 4.0),
                  widget.suffixIcon ??
                      AnimatedRotation(
                        turns: _isOpen ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              _selectedValues.isNotEmpty
                                  ? Colors.blue
                                  : Colors.grey,
                          size: 18,
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
