import 'package:app/core/service_locator.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        context: context,
        showBackButton: true,
        showCartButton: true,
        showProfileButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            if (product.images.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: AppColors.inputFill,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          product.images[index].src,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.inputFill,
                ),
                child: _buildPlaceholder(context),
              ),
            const SizedBox(height: 24),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Price
            Row(
              children: [
                Text(
                  'Preț: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  '${product.price} Lei',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stock Status
            Row(
              children: [
                Icon(
                  product.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: product.isAvailable ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 8),
                Text(
                  product.isAvailable
                      ? 'În stoc'
                      : 'Stoc epuizat',
                  style: TextStyle(
                    fontSize: 16,
                    color: product.isAvailable ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Categories
            if (product.categories.isNotEmpty) ...[
              const Text(
                'Categorii:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    product.categories.map((category) {
                      return Chip(
                        label: Text(category.name),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Brands
            if (product.brands.isNotEmpty) ...[
              const Text(
                'Mărci:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    product.brands.map((brand) {
                      return Chip(
                        label: Text(brand.name),
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Description
            if (product.description.isNotEmpty) ...[
              const Text(
                'Descriere:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product.description.replaceAll(
                  RegExp(r'<[^>]*>'),
                  '',
                ), // Remove HTML tags
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
            ],

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    product.isAvailable
                        ? () {
                          sl<CartCubit>().addProduct(
                            product.toCartModel(),
                            onSuccess: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Produs adăugat în coș'),
                                ),
                              );
                            },
                            onError: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Produsul nu a putut fi adăugat în coș'),
                                ),
                              );
                            },
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Adaugă în coș',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.inputFill,
      ),
      child: Center(
        child: Icon(
          Icons.shopping_bag,
          size: 64,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
