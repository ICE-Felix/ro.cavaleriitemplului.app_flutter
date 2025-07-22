import 'package:flutter/material.dart';

class MultiSelectDropdown<ValueType, ReturnType> extends StatefulWidget {
  final List<ValueType> items;
  final List<ReturnType> selectedValues;
  final Widget Function(ValueType value) builderFunction;
  final ReturnType Function(ValueType value) valueExtractor;
  final ValueChanged<List<ReturnType>>? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? maxHeight;
  final EdgeInsets? padding;
  final TextStyle? hintStyle;
  final TextStyle? selectedTextStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final bool enabled;
  final String? selectedItemsText;
  final int? maxSelectedDisplay;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.builderFunction,
    required this.valueExtractor,
    this.selectedValues = const [],
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxHeight = 300.0,
    this.padding,
    this.hintStyle,
    this.selectedTextStyle,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 8.0,
    this.enabled = true,
    this.selectedItemsText,
    this.maxSelectedDisplay = 3,
  });

  @override
  State<MultiSelectDropdown<ValueType, ReturnType>> createState() =>
      _MultiSelectDropdownState<ValueType, ReturnType>();
}

class _MultiSelectDropdownState<ValueType, ReturnType>
    extends State<MultiSelectDropdown<ValueType, ReturnType>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final UniqueKey _tapRegionKey = UniqueKey();
  bool _isOpen = false;
  late List<ReturnType> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(MultiSelectDropdown<ValueType, ReturnType> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValues != oldWidget.selectedValues) {
      _selectedValues = List.from(widget.selectedValues);
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
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

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (context.mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
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
                          child: _buildDropdownItems(setOverlayState),
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

  Widget _buildDropdownItems([StateSetter? setOverlayState]) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final value = widget.valueExtractor(item);
        final isSelected = _selectedValues.contains(value);

        return InkWell(
          onTap: () => _toggleSelection(value, setOverlayState),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
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

  String _getDisplayText() {
    if (_selectedValues.isEmpty) {
      return widget.hintText ?? 'Select items';
    }

    if (widget.selectedItemsText != null) {
      return widget.selectedItemsText!;
    }

    final maxDisplay = widget.maxSelectedDisplay ?? 3;
    if (_selectedValues.length <= maxDisplay) {
      return '${_selectedValues.length} item${_selectedValues.length > 1 ? 's' : ''} selected';
    }

    return '${_selectedValues.length} items selected';
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TapRegion(
        groupId: _tapRegionKey,
        onTapOutside: (_) => _closeDropdown,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color:
                    _isOpen
                        ? (widget.focusedBorderColor ?? Colors.blue)
                        : (widget.borderColor ?? Colors.grey[300]!),
                width: _isOpen ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  widget.prefixIcon!,
                  const SizedBox(width: 8.0),
                ],
                Expanded(
                  child: Text(
                    _getDisplayText(),
                    style:
                        _selectedValues.isEmpty
                            ? (widget.hintStyle ??
                                TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16.0,
                                ))
                            : (widget.selectedTextStyle ??
                                const TextStyle(fontSize: 16.0)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.suffixIcon != null)
                  widget.suffixIcon!
                else
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
