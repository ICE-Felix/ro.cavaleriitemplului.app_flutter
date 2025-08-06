import 'package:flutter/material.dart';
import 'package:app/features/cart/domain/models/cart_item_model.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/core/style/app_text_styles.dart';
import 'quantity_controls.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final hasImage = product.images.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child:
                    hasImage
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.images.first.src,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.grey.shade400,
                          size: 32,
                        ),
              ),

              const SizedBox(width: 16),

              // Product Details - Flexible to handle overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Name and Delete Button Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Remove Button
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red.shade400,
                          tooltip: 'Remove from cart',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // SKU
                    if (product.sku.isNotEmpty)
                      Text(
                        'SKU: ${product.sku}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Price Row
                    Row(
                      children: [
                        if (product.onSale &&
                            product.salePrice != product.regularPrice) ...[
                          Text(
                            '\$${product.regularPrice}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${product.salePrice}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else
                          Text(
                            '\$${product.price}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Quantity Controls and Total - Wrap to prevent overflow
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuantityControls(
                          quantity: item.quantity,
                          onIncrease: onIncrease,
                          onDecrease: onDecrease,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: \$${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
