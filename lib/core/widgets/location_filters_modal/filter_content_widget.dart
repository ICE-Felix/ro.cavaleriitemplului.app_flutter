import 'package:app/core/style/app_colors.dart';
import 'package:app/features/locations/data/datasources/locations_remote_data_source.dart';
import 'package:flutter/material.dart';

class FilterContentWidget extends StatelessWidget {
  final String selectedFilterSection;
  final Map<String, List<AttributeFilterOption>> attributeFilters;
  final List<String> selectedAttributeIds;
  final Function(List<String> attributeIds) onAttributeSelectionChanged;

  const FilterContentWidget({
    super.key,
    required this.selectedFilterSection,
    required this.attributeFilters,
    required this.selectedAttributeIds,
    required this.onAttributeSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sectionOptions = attributeFilters[selectedFilterSection] ?? [];

    // Sort options alphabetically by value
    final sortedOptions = List<AttributeFilterOption>.from(sectionOptions)
      ..sort((a, b) => a.value.compareTo(b.value));

    return ListView.builder(
      itemCount: sortedOptions.length,
      itemBuilder: (context, index) {
        final option = sortedOptions[index];
        final isSelected = selectedAttributeIds.contains(option.uuid);

        return CheckboxListTile(
          title: Text(option.value, style: const TextStyle(fontSize: 16)),
          value: isSelected,
          onChanged: (bool? value) {
            final newSelectedIds = List<String>.from(selectedAttributeIds);
            if (value == true) {
              newSelectedIds.add(option.uuid);
            } else {
              newSelectedIds.remove(option.uuid);
            }
            onAttributeSelectionChanged(newSelectedIds);
          },
          activeColor: AppColors.primary,
        );
      },
    );
  }
}
