import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:app/features/cart/presentation/widgets/empty_cart_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CartCubit>()..loadCart(),
      child: const CartPageView(),
    );
  }
}

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(
        title: 'Shopping Cart',
        showBackButton: true,
        showNotificationButton: false,
        showProfileButton: false,
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state.isError && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (!state.isError && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.cart.isEmpty) {
            return EmptyCartWidget(
              onContinueShopping: () {
                // Navigate back to shop
                context.pop();
              },
            );
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.cart.items.length,
                  itemBuilder: (context, index) {
                    final item = state.cart.items[index];
                    return CartItemCard(
                      item: item,
                      onRemove: () {
                        _showRemoveConfirmation(
                          context,
                          item.product.name,
                          () => context.read<CartCubit>().removeProduct(
                            item.product.id,
                          ),
                        );
                      },
                      onIncrease: () {
                        context.read<CartCubit>().increaseQuantity(
                          item.product.id,
                        );
                      },
                      onDecrease: () {
                        context.read<CartCubit>().decreaseQuantity(
                          item.product.id,
                        );
                      },
                    );
                  },
                ),
              ),

              // Cart Summary
              CartSummary(
                cart: state.cart,
                onCheckout: () {
                  _showCheckoutDialog(context);
                },
                onClearCart: () {
                  _showClearCartConfirmation(
                    context,
                    () => context.read<CartCubit>().clearCart(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRemoveConfirmation(
    BuildContext context,
    String productName,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: Text(
            'Are you sure you want to remove "$productName" from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCartConfirmation(
    BuildContext context,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: const Text(
            'Checkout functionality will be implemented in future updates.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
