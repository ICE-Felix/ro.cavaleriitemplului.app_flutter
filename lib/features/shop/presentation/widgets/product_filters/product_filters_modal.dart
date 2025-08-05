import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_tag_entity.dart';
import 'package:app/features/shop/presentation/widgets/product_filters/filter_content_switcher.dart';
import 'package:app/features/shop/presentation/widgets/product_filters/filter_section_item.dart';
import 'package:flutter/material.dart';

class ProductFiltersModal extends StatefulWidget {
  final List<ProductCategoryEntity> categories;
  final List<ProductTagEntity> tags;
  final List<int> selectedCategoryIds;
  final List<int> selectedTagIds;
  final Function(List<int> categoryIds, List<int> tagIds) onApplyFilters;
  final VoidCallback onClearFilters;

  const ProductFiltersModal({
    super.key,
    required this.categories,
    required this.tags,
    required this.selectedCategoryIds,
    required this.selectedTagIds,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<ProductFiltersModal> createState() => _ProductFiltersModalState();
}

class _ProductFiltersModalState extends State<ProductFiltersModal> {
  late List<int> _selectedCategoryIds;
  late List<int> _selectedTagIds;
  String _selectedFilterSection = 'categories'; // 'categories' or 'tags'

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = List.from(widget.selectedCategoryIds);
    _selectedTagIds = List.from(widget.selectedTagIds);
  }

  int get _totalSelectedFilters =>
      _selectedCategoryIds.length + _selectedTagIds.length;

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
          // Header
          Container(
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
                  context.getString(label: 'shop.filters') ?? 'Filtreaza',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Row(
              children: [
                // Left sidebar - Filter categories
                Container(
                  width: 150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    border: Border(
                      right: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      FilterSectionItem(
                        sectionId: 'categories',
                        title:
                            context.getString(label: 'shop.categories') ??
                            'Categorie',
                        selectedCount: _selectedCategoryIds.length,
                        isSelected: _selectedFilterSection == 'categories',
                        onTap: () {
                          setState(() {
                            _selectedFilterSection = 'categories';
                          });
                        },
                      ),
                      FilterSectionItem(
                        sectionId: 'tags',
                        title: context.getString(label: 'shop.tags') ?? 'Tags',
                        selectedCount: _selectedTagIds.length,
                        isSelected: _selectedFilterSection == 'tags',
                        onTap: () {
                          setState(() {
                            _selectedFilterSection = 'tags';
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Right content - Filter options
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: FilterContentSwitcher(
                      selectedFilterSection: _selectedFilterSection,
                      categories: widget.categories,
                      tags: widget.tags,
                      selectedCategoryIds: _selectedCategoryIds,
                      selectedTagIds: _selectedTagIds,
                      onCategorySelectionChanged: (selectedIds) {
                        setState(() {
                          _selectedCategoryIds = selectedIds;
                        });
                      },
                      onTagSelectionChanged: (selectedIds) {
                        setState(() {
                          _selectedTagIds = selectedIds;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryIds.clear();
                        _selectedTagIds.clear();
                      });
                      widget.onClearFilters();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    child: Text(
                      context.getString(label: 'shop.clearFilters') ??
                          'Sterge filtre',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(
                        _selectedCategoryIds,
                        _selectedTagIds,
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      _totalSelectedFilters > 0
                          ? (context
                                  .getString(label: 'shop.viewResults')
                                  ?.replaceAll(
                                    '{count}',
                                    _totalSelectedFilters.toString(),
                                  ) ??
                              'Vezi $_totalSelectedFilters rezultate')
                          : (context.getString(label: 'shop.viewAllResults') ??
                              'Vezi toate rezultatele'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
