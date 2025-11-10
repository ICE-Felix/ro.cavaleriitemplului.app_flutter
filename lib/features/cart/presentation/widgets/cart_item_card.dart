import 'package:app/features/cart/domain/models/cart_stock_response_model.dart';
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
  final ProductStockInfo? stockInfo;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
    this.stockInfo,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = item.imageUrl;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: stockInfo?.available == false ? AppColors.error : AppColors.border,
          width: 1,
        ),
      ),
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
                  color: AppColors.inputFill,
                ),
                child:
                    item.imageUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.shopping_bag_outlined,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
                            item.name,
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
                          color: AppColors.error,
                          tooltip: 'Remove from cart',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Price Row
                    Row(
                      children: [
                        if (item.onSale &&
                            item.salePrice != item.regularPrice) ...[
                          Text(
                            '\$${item.regularPrice}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.salePrice} RON',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else
                          Text(
                            '${item.price} RON',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
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
                              'Total: ${item.totalPrice.toStringAsFixed(2)} RON',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (stockInfo?.available == false) Spacer(),
                        if (stockInfo?.available == false)
                          Tooltip(
                            message:
                                '${stockInfo?.error}. Only ${stockInfo?.availableQuantity} left in stock.',
                            triggerMode: TooltipTriggerMode.tap,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.info,
                                color: AppColors.error,
                              ),
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
