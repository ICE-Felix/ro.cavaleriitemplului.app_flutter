import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';

class CategoryCard extends StatelessWidget {
  final ProductCategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Category Image
            Expanded(
              flex: 3,
              child: Container(
                // height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child:
                    category.image != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            category.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder();
                            },
                          ),
                        )
                        : _buildPlaceholder(),
              ),
            ),
            const SizedBox(height: 12),

            // Category Name
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.primary,
      ),
      child: Center(
        child: Image.asset('assets/images/logo/logo.png', fit: BoxFit.cover),
      ),
    );
  }
}
