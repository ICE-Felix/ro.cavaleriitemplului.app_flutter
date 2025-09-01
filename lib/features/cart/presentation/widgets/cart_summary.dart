import 'package:flutter/material.dart';
import 'package:app/features/cart/domain/models/cart_model.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/core/style/app_text_styles.dart';

class CartSummary extends StatelessWidget {
  final CartModel cart;
  final VoidCallback? onCheckout;
  final VoidCallback? onClearCart;
  final bool isCheckoutLoading;

  const CartSummary({
    super.key,
    required this.cart,
    this.onCheckout,
    this.onClearCart,
    this.isCheckoutLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items (${cart.totalQuantity})',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '${cart.totalPrice.toStringAsFixed(2)} RON',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping', style: AppTextStyles.bodyMedium),
                Text(
                  'FREE',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${cart.totalPrice.toStringAsFixed(2)} RON',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                // Clear Cart Button
                if (cart.isNotEmpty)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClearCart,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Clear Cart',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ),
                  ),

                if (cart.isNotEmpty) const SizedBox(width: 16),

                // Checkout Button
                Expanded(
                  flex: cart.isNotEmpty ? 2 : 1,
                  child: ElevatedButton(
                    onPressed: cart.isNotEmpty
                        ? () {
                            if (isCheckoutLoading) {
                              return;
                            }
                            onCheckout?.call();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      cart.isNotEmpty ? 'Checkout' : 'Cart is Empty',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
