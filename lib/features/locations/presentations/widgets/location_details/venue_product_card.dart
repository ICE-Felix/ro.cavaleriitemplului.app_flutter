import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:app/features/locations/data/models/venue_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class VenueProductCard extends StatelessWidget {
  const VenueProductCard({super.key, required this.product});

  final VenueProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image and Basic Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image - Larger
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade200,
                    child:
                        product.mainImageUrl != null
                            ? Image.network(
                              product.mainImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                );
                              },
                            )
                            : const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                  ),
                ),
                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.wooName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Categories
                      if (product.venueProductCategoriesName.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children:
                              product.venueProductCategoriesName
                                  .take(2)
                                  .map(
                                    (category) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        category,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      const SizedBox(height: 12),

                      // Price Row
                      Row(
                        children: [
                          Text(
                            '${product.displayPrice} RON',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                            ),
                          ),
                          if (product.isOnSale) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${product.wooPrice} RON',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Product Details Row (Capacity, Price Type, Stock Status)
            Row(
              children: [
                // Max Capacity
                if (product.maxCapacity > 0) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 18,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Max ${product.maxCapacity}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],

                // Price Type
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatPriceType(product.priceType),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Stock Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        product.isAvailable
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          product.isAvailable
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              product.isAvailable
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.isAvailable
                            ? 'In Stock'
                            : 'Out of Stock',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              product.isAvailable
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Product Full Description (HTML) - No background
            if (product.wooDescription.isNotEmpty) ...[
              const SizedBox(height: 16),
              Html(
                data: product.wooDescription,
                style: {
                  'body': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(14),
                    lineHeight: const LineHeight(1.6),
                    color: Colors.grey.shade800,
                  ),
                  'p': Style(margin: Margins.only(bottom: 10)),
                  'h1, h2, h3, h4, h5, h6': Style(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                    margin: Margins.only(bottom: 8, top: 12),
                  ),
                  'ul, ol': Style(margin: Margins.only(left: 16, bottom: 10)),
                  'li': Style(margin: Margins.only(bottom: 6)),
                  'strong, b': Style(fontWeight: FontWeight.bold),
                  'em, i': Style(fontStyle: FontStyle.italic),
                },
              ),
            ],

            // Add to Cart Button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    product.isAvailable
                        ? () {
                          sl<CartCubit>().addProduct(
                            product.toCartModel(),
                            onSuccess: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product added to cart'),
                                ),
                              );
                            },
                            onError: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product not added to cart'),
                                ),
                              );
                            },
                          );
                        }
                        : null,
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: product.wooStockStatus == 'instock' ? 2 : 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPriceType(String priceType) {
    switch (priceType.toLowerCase()) {
      case 'per_day':
        return 'Per Day';
      case 'per_hour':
        return 'Per Hour';
      case 'per_person':
        return 'Per Person';
      default:
        return priceType;
    }
  }
}
