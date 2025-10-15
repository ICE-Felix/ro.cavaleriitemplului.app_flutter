import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/presentation/cubit/cart_cubit.dart';

class CartButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CartButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: BlocProvider.value(
        value: sl<CartCubit>(),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final totalItems = state.cart.items.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            );

            return IconButton(
              onPressed: onPressed,
              icon: Stack(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  if (totalItems > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            totalItems.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              tooltip: 'Cart',
            );
          },
        ),
      ),
    );
  }
}
