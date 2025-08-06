import 'package:app/core/service_locator.dart';
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
      appBar: CustomTopBar(showBackButton: true),
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
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          product.images[index].src,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
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
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[200],
                ),
                child: _buildPlaceholder(),
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
                const Text(
                  'Price: ', // TODO: Use localized string
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '${product.price} lei',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stock Status
            Row(
              children: [
                Icon(
                  product.stockStatus == 'instock'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color:
                      product.stockStatus == 'instock'
                          ? Colors.green
                          : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  product.stockStatus == 'instock'
                      ? 'In Stock' // TODO: Use localized string
                      : 'Out of Stock', // TODO: Use localized string
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        product.stockStatus == 'instock'
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Categories
            if (product.categories.isNotEmpty) ...[
              const Text(
                'Categories:', // TODO: Use localized string
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
                        backgroundColor: Colors.blue.shade100,
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Brands
            if (product.brands.isNotEmpty) ...[
              const Text(
                'Brands:', // TODO: Use localized string
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
                        backgroundColor: Colors.orange.shade100,
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Description
            if (product.description.isNotEmpty) ...[
              const Text(
                'Description:', // TODO: Use localized string
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
                    product.stockStatus == 'instock'
                        ? () {
                          sl<CartCubit>().addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product added to cart'),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add to Cart', // TODO: Use localized string
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey[300],
      ),
      child: const Center(
        child: Icon(Icons.shopping_bag, size: 64, color: Colors.grey),
      ),
    );
  }
}
