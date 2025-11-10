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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: isSelected
              ? Border(left: BorderSide(color: AppColors.primary, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
                    ),
                  ),
                  if (selectedCount > 0)
                    Text(
                      '$selectedCount selected',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primary
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
