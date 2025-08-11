import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class ProductsFilterButton extends StatelessWidget {
  final int selectedFiltersCount;
  final VoidCallback onTap;

  const ProductsFilterButton({
    super.key,
    required this.selectedFiltersCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    selectedFiltersCount > 0
                        ? AppColors.primary
                        : Colors.grey.shade300,
                width: selectedFiltersCount > 0 ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color:
                  selectedFiltersCount > 0
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 20,
                      color:
                          selectedFiltersCount > 0
                              ? AppColors.primary
                              : Colors.grey.shade600,
                    ),
                    if (selectedFiltersCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            selectedFiltersCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                Text(
                  selectedFiltersCount > 0
                      ? (context
                              .getString(label: 'shop.filtersApplied')
                              .replaceAll(
                                '{count}',
                                selectedFiltersCount.toString(),
                              ) ??
                          '$selectedFiltersCount Filtre aplicate')
                      : (context.getString(label: 'shop.filters') ?? 'Filtre'),
                  style: TextStyle(
                    fontWeight:
                        selectedFiltersCount > 0
                            ? FontWeight.w600
                            : FontWeight.normal,
                    color:
                        selectedFiltersCount > 0
                            ? AppColors.primary
                            : Colors.grey.shade700,
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
