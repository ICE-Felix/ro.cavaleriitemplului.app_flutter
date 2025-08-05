import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryFilterSection extends StatefulWidget {
  final List<ProductCategoryEntity> categories;
  final List<int> selectedIds;
  final Function(List<int>) onSelectionChanged;

  const CategoryFilterSection({
    super.key,
    required this.categories,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  State<CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<CategoryFilterSection> {
  String _searchQuery = '';

  List<ProductCategoryEntity> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return widget.categories;
    }
    return widget.categories
        .where(
          (category) =>
              category.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Caută categorii',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Categories list
        Expanded(
          child:
              _filteredCategories.isEmpty
                  ? const Center(
                    child: Text(
                      'Nu s-au găsit categorii',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = _filteredCategories[index];
                      final isSelected = widget.selectedIds.contains(
                        category.id,
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              final newSelectedIds = List<int>.from(
                                widget.selectedIds,
                              );
                              if (isSelected) {
                                newSelectedIds.remove(category.id);
                              } else {
                                newSelectedIds.add(category.id);
                              }
                              widget.onSelectionChanged(newSelectedIds);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? AppColors.primary
                                                : Colors.grey,
                                        width: 2,
                                      ),
                                      color:
                                          isSelected
                                              ? AppColors.primary
                                              : Colors.transparent,
                                    ),
                                    child:
                                        isSelected
                                            ? const Icon(
                                              Icons.check,
                                              size: 14,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      category.name,
                                      style: TextStyle(
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                        color:
                                            isSelected
                                                ? AppColors.primary
                                                : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${category.count ?? 0}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
