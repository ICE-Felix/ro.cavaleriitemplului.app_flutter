import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class LocationFilterButton extends StatelessWidget {
  final int selectedFiltersCount;
  final VoidCallback onTap;

  const LocationFilterButton({
    super.key,
    required this.selectedFiltersCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                selectedFiltersCount > 0
                    ? AppColors.primary
                    : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color:
              selectedFiltersCount > 0
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 18,
              color:
                  selectedFiltersCount > 0
                      ? AppColors.primary
                      : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              context.getString(label: 'locations.filters'),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                    selectedFiltersCount > 0
                        ? AppColors.primary
                        : Colors.grey.shade700,
              ),
            ),
            if (selectedFiltersCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedFiltersCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
