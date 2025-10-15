import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/features/locations/data/datasources/locations_remote_data_source.dart';
import 'package:app/core/widgets/location_filters_modal/filter_section_item.dart';
import 'package:app/core/widgets/location_filters_modal/filter_content_widget.dart';
import 'package:flutter/material.dart';

class LocationFiltersModal extends StatefulWidget {
  final Map<String, List<AttributeFilterOption>> attributeFilters;
  final List<String> selectedAttributeIds;
  final Function(List<String> attributeIds) onApplyFilters;
  final VoidCallback onClearFilters;

  const LocationFiltersModal({
    super.key,
    required this.attributeFilters,
    required this.selectedAttributeIds,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<LocationFiltersModal> createState() => _LocationFiltersModalState();
}

class _LocationFiltersModalState extends State<LocationFiltersModal> {
  late List<String> _selectedAttributeIds;
  String _selectedFilterSection = '';

  @override
  void initState() {
    super.initState();
    _selectedAttributeIds = List.from(widget.selectedAttributeIds);
    // Set the first available section as default
    if (widget.attributeFilters.isNotEmpty) {
      _selectedFilterSection = widget.attributeFilters.keys.first;
    }
  }

  int get _totalSelectedFilters => _selectedAttributeIds.length;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _ModalHeader(
            onClose: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Row(
              children: [
                _FilterSidebar(
                  attributeFilters: widget.attributeFilters,
                  selectedAttributeIds: _selectedAttributeIds,
                  selectedFilterSection: _selectedFilterSection,
                  onSectionSelected: (sectionKey) {
                    setState(() {
                      _selectedFilterSection = sectionKey;
                    });
                  },
                ),
                _FilterContentArea(
                  selectedFilterSection: _selectedFilterSection,
                  attributeFilters: widget.attributeFilters,
                  selectedAttributeIds: _selectedAttributeIds,
                  onAttributeSelectionChanged: (attributeIds) {
                    setState(() {
                      _selectedAttributeIds = attributeIds;
                    });
                  },
                ),
              ],
            ),
          ),
          _ModalFooter(
            totalSelectedFilters: _totalSelectedFilters,
            onClearFilters: () {
              setState(() {
                _selectedAttributeIds.clear();
              });
              widget.onClearFilters();
            },
            onApplyFilters: () {
              widget.onApplyFilters(_selectedAttributeIds);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _ModalHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.getString(label: 'locations.filters'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _FilterSidebar extends StatelessWidget {
  final Map<String, List<AttributeFilterOption>> attributeFilters;
  final List<String> selectedAttributeIds;
  final String selectedFilterSection;
  final Function(String sectionKey) onSectionSelected;

  const _FilterSidebar({
    required this.attributeFilters,
    required this.selectedAttributeIds,
    required this.selectedFilterSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border(
          right: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Column(
        children: attributeFilters.keys.map((sectionKey) {
          final sectionOptions = attributeFilters[sectionKey] ?? [];
          final selectedCount = selectedAttributeIds
              .where(
                (id) => sectionOptions.any(
                  (option) => option.uuid == id,
                ),
              )
              .length;

          return FilterSectionItem(
            sectionId: sectionKey,
            title: _getSectionTitle(context, sectionKey),
            selectedCount: selectedCount,
            isSelected: selectedFilterSection == sectionKey,
            onTap: () => onSectionSelected(sectionKey),
          );
        }).toList(),
      ),
    );
  }

  String _getSectionTitle(BuildContext context, String sectionKey) {
    switch (sectionKey.toLowerCase()) {
      case 'amenity':
        return context.getString(label: 'locations.amenities');
      case 'size':
        return context.getString(label: 'locations.size');
      default:
        return sectionKey.toUpperCase();
    }
  }
}

class _FilterContentArea extends StatelessWidget {
  final String selectedFilterSection;
  final Map<String, List<AttributeFilterOption>> attributeFilters;
  final List<String> selectedAttributeIds;
  final Function(List<String> attributeIds) onAttributeSelectionChanged;

  const _FilterContentArea({
    required this.selectedFilterSection,
    required this.attributeFilters,
    required this.selectedAttributeIds,
    required this.onAttributeSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: selectedFilterSection.isNotEmpty
            ? FilterContentWidget(
                selectedFilterSection: selectedFilterSection,
                attributeFilters: attributeFilters,
                selectedAttributeIds: selectedAttributeIds,
                onAttributeSelectionChanged: onAttributeSelectionChanged,
              )
            : const Center(
                child: Text('Select a filter category'),
              ),
      ),
    );
  }
}

class _ModalFooter extends StatelessWidget {
  final int totalSelectedFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onApplyFilters;

  const _ModalFooter({
    required this.totalSelectedFilters,
    required this.onClearFilters,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onClearFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppColors.primary),
              ),
              child: Text(
                context.getString(label: 'locations.clearFilters'),
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onApplyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                totalSelectedFilters > 0
                    ? context
                        .getString(label: 'locations.viewResults')
                        .replaceAll(
                          '{count}',
                          totalSelectedFilters.toString(),
                        )
                    : context.getString(label: 'locations.viewAllResults'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
