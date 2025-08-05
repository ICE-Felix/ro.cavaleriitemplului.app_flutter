import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class FilterSectionItem extends StatelessWidget {
  final String sectionId;
  final String title;
  final int selectedCount;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterSectionItem({
    super.key,
    required this.sectionId,
    required this.title,
    required this.selectedCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border:
              isSelected
                  ? const Border(
                    right: BorderSide(color: AppColors.primary, width: 2),
                  )
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
            ),
            if (selectedCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selectedCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
