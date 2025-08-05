import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_tag_entity.dart';
import 'package:app/features/shop/presentation/widgets/category_filter_section.dart';
import 'package:app/features/shop/presentation/widgets/tags_filter_section.dart';
import 'package:flutter/material.dart';

class FilterContentSwitcher extends StatelessWidget {
  final String selectedFilterSection;
  final List<ProductCategoryEntity> categories;
  final List<ProductTagEntity> tags;
  final List<int> selectedCategoryIds;
  final List<int> selectedTagIds;
  final Function(List<int>) onCategorySelectionChanged;
  final Function(List<int>) onTagSelectionChanged;

  const FilterContentSwitcher({
    super.key,
    required this.selectedFilterSection,
    required this.categories,
    required this.tags,
    required this.selectedCategoryIds,
    required this.selectedTagIds,
    required this.onCategorySelectionChanged,
    required this.onTagSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedFilterSection) {
      case 'categories':
        return CategoryFilterSection(
          categories: categories,
          selectedIds: selectedCategoryIds,
          onSelectionChanged: onCategorySelectionChanged,
        );
      case 'tags':
        return TagsFilterSection(
          tags: tags,
          selectedIds: selectedTagIds,
          onSelectionChanged: onTagSelectionChanged,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
