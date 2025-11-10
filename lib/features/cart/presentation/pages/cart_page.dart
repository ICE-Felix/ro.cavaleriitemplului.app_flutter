import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/localization/localization_inherited_widget.dart';
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
      appBar: CustomTopBar(
        context: context,
        title: context.getString(label: 'cart.title'),
        showBackButton: true,
        showNotificationButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
        showProfileButton: false,
        showCartButton: false,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.cart.isEmpty) {
            return EmptyCartWidget(
              onContinueShopping: () {
                // Navigate back to shop
                context.pushNamed(AppRoutesNames.shop.name);
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
                      stockInfo: state.cartStock?.getProductStockInfo(
                        item.id,
                      ),
                      onRemove: () {
                        _showRemoveConfirmation(
                          context,
                          item.name,
                          () => context.read<CartCubit>().removeProduct(
                            item.id,
                            onSuccess: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.getString(label: 'cart.productRemoved')),
                                ),
                              );
                            },
                            onError: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.getString(label: 'cart.productNotRemoved'),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      onIncrease: () {
                        context.read<CartCubit>().increaseQuantity(
                          item.id,
                        );
                      },
                      onDecrease: () {
                        context.read<CartCubit>().decreaseQuantity(
                          item.id,
                        );
                      },
                    );
                  },
                ),
              ),

              // Cart Summary
              CartSummary(
                cart: state.cart,
                isCheckoutLoading: state.isCheckoutLoading,
                onCheckout: () async {
                  final (allInStock, errorMessage) =
                      await context.read<CartCubit>().checkCurrentStock();
                  if (allInStock) {
                    context.pushNamed(AppRoutesNames.checkout.name);
                  } else {
                    _showErrorDialog(
                      context,
                      errorMessage ?? 'Unknown cart error',
                    );
                  }
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
          title: Text(context.getString(label: 'cart.removeItem')),
          content: Text(
            context.getString(label: 'cart.removeItemConfirm').replaceAll('{productName}', productName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.getString(label: 'cart.cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(context.getString(label: 'cart.remove')),
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
          title: Text(context.getString(label: 'cart.clearCart')),
          content: Text(
            context.getString(label: 'cart.clearCartConfirm'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.getString(label: 'cart.cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(context.getString(label: 'cart.clearAll')),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.getString(label: 'cart.checkoutError')),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.getString(label: 'cart.ok')),
            ),
          ],
        );
      },
    );
  }
}
