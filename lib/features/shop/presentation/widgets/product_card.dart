import 'package:app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child:
                    product.images.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            product.images.first.src,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder();
                            },
                          ),
                        )
                        : _buildPlaceholder(),
              ),
              const SizedBox(height: 12),

              // Product Name
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Price
              Row(
                children: [
                  const Text(
                    'Price: ', // TODO: Use localized string
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '${product.price} lei',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Stock Status
              Row(
                children: [
                  Icon(
                    product.stockStatus == 'instock'
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 16,
                    color:
                        product.stockStatus == 'instock'
                            ? Colors.green
                            : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.stockStatus == 'instock'
                        ? 'In Stock' // TODO: Use localized string
                        : 'Out of Stock', // TODO: Use localized string
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          product.stockStatus == 'instock'
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Short Description (if available)
              if (product.shortDescription.isNotEmpty)
                Text(
                  product.shortDescription.replaceAll(
                    RegExp(r'<[^>]*>'),
                    '',
                  ), // Remove HTML tags
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),

              // View Product Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: onTap,
              //     child: const Text(
              //       'View Details',
              //     ), // TODO: Use localized string
              //   ),
              // ),
            ],
          ),
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
        child: Image.asset('assets/images/logo/logo.png'),
        // child: Icon(Icons.shopping_bag, size: 48, color: Colors.grey),
      ),
    );
  }
}
