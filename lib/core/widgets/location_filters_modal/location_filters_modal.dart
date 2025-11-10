import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/core/utils/map_utils.dart';
import 'package:app/features/locations/data/datasources/locations_remote_data_source.dart';
import 'package:app/core/widgets/location_filters_modal/filter_section_item.dart';
import 'package:app/core/widgets/location_filters_modal/filter_content_widget.dart';
import 'package:flutter/material.dart';

class LocationFiltersModal extends StatefulWidget {
  final Map<String, List<AttributeFilterOption>> attributeFilters;
  final List<String> selectedAttributeIds;
  final int radiusKm;
  final Function(List<String> attributeIds) onApplyFilters;
  final Function(int radiusKm) onRadiusChanged;
  final VoidCallback onClearFilters;

  const LocationFiltersModal({
    super.key,
    required this.attributeFilters,
    required this.selectedAttributeIds,
    required this.radiusKm,
    required this.onApplyFilters,
    required this.onRadiusChanged,
    required this.onClearFilters,
  });

  @override
  State<LocationFiltersModal> createState() => _LocationFiltersModalState();
}

class _LocationFiltersModalState extends State<LocationFiltersModal> {
  late List<String> _selectedAttributeIds;
  late int _radiusKm;
  String _selectedFilterSection = 'range';

  @override
  void initState() {
    super.initState();
    _selectedAttributeIds = List.from(widget.selectedAttributeIds);
    _radiusKm = widget.radiusKm;
    // Set range as default section
    _selectedFilterSection = 'range';
  }

  int get _totalSelectedFilters => _selectedAttributeIds.length;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _ModalHeader(onClose: () => Navigator.of(context).pop()),
          Expanded(
            child: Row(
              children: [
                _FilterSidebar(
                  attributeFilters: widget.attributeFilters,
                  selectedAttributeIds: _selectedAttributeIds,
                  selectedFilterSection: _selectedFilterSection,
                  radiusKm: _radiusKm,
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
                  radiusKm: _radiusKm,
                  onAttributeSelectionChanged: (attributeIds) {
                    setState(() {
                      _selectedAttributeIds = attributeIds;
                    });
                  },
                  onRadiusChanged: (radiusKm) {
                    setState(() {
                      _radiusKm = radiusKm;
                    });
                    widget.onRadiusChanged(radiusKm);
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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.getString(label: 'locations.filters'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  final int radiusKm;
  final Function(String sectionKey) onSectionSelected;

  const _FilterSidebar({
    required this.attributeFilters,
    required this.selectedAttributeIds,
    required this.selectedFilterSection,
    required this.radiusKm,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Range section (always first)
          FilterSectionItem(
            sectionId: 'range',
            title: context.getString(label: 'locations.range'),
            selectedCount: radiusKm != 30 ? 1 : 0,
            isSelected: selectedFilterSection == 'range',
            onTap: () => onSectionSelected('range'),
          ),
          // Other attribute filter sections
          ...attributeFilters.keys.map((sectionKey) {
            final sectionOptions = attributeFilters[sectionKey] ?? [];
            final selectedCount =
                selectedAttributeIds
                    .where(
                      (id) => sectionOptions.any((option) => option.uuid == id),
                    )
                    .length;

            return FilterSectionItem(
              sectionId: sectionKey,
              title: _getSectionTitle(context, sectionKey),
              selectedCount: selectedCount,
              isSelected: selectedFilterSection == sectionKey,
              onTap: () => onSectionSelected(sectionKey),
            );
          }),
        ],
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
  final int radiusKm;
  final Function(List<String> attributeIds) onAttributeSelectionChanged;
  final Function(int radiusKm) onRadiusChanged;

  const _FilterContentArea({
    required this.selectedFilterSection,
    required this.attributeFilters,
    required this.selectedAttributeIds,
    required this.radiusKm,
    required this.onAttributeSelectionChanged,
    required this.onRadiusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child:
            selectedFilterSection.isNotEmpty
                ? selectedFilterSection == 'range'
                    ? _RangeFilterWidget(
                      radiusKm: radiusKm,
                      onRadiusChanged: onRadiusChanged,
                    )
                    : FilterContentWidget(
                      selectedFilterSection: selectedFilterSection,
                      attributeFilters: attributeFilters,
                      selectedAttributeIds: selectedAttributeIds,
                      onAttributeSelectionChanged: onAttributeSelectionChanged,
                    )
                : const Center(child: Text('Select a filter category')),
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
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onClearFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                totalSelectedFilters > 0
                    ? context
                        .getString(label: 'locations.viewResults')
                        .replaceAll('{count}', totalSelectedFilters.toString())
                    : context.getString(label: 'locations.viewAllResults'),
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeFilterWidget extends StatelessWidget {
  final int radiusKm;
  final Function(int radiusKm) onRadiusChanged;

  const _RangeFilterWidget({
    required this.radiusKm,
    required this.onRadiusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.getString(label: 'locations.range'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          context.getString(label: 'locations.rangeDescription'),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              '${radiusKm}km',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Slider(
                value: radiusKm.toDouble(),
                min: MapUtils.minRadiusFilterValue.toDouble(),
                max: MapUtils.maxRadiusFilterValue.toDouble(),
                divisions: MapUtils.radiusFilterDivisions, // 5km increments (100/5 = 20)
                activeColor: AppColors.primary,
                inactiveColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                onChanged: (value) {
                  onRadiusChanged(value.round());
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0km',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            Text(
              '100km',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
