import 'package:flutter/material.dart';
import 'package:app/features/cart/domain/models/cart_model.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/core/style/app_text_styles.dart';
import 'package:app/core/localization/localization_inherited_widget.dart';

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
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
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
                  context.getString(label: 'cart.items').replaceAll('{count}', '${cart.totalQuantity}'),
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
                Text(context.getString(label: 'cart.shipping'), style: AppTextStyles.bodyMedium),
                Text(
                  context.getString(label: 'cart.free'),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
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
                  context.getString(label: 'cart.total'),
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
                        side: BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        context.getString(label: 'cart.clearCart'),
                        style: TextStyle(color: AppColors.error),
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
                      cart.isNotEmpty ? context.getString(label: 'cart.checkout') : context.getString(label: 'cart.cartIsEmpty'),
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
