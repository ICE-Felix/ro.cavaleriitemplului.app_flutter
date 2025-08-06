import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/domain/models/cart_model.dart';
import 'package:app/features/cart/domain/repositories/cart_repository.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(cart: CartModel.empty()));

  Future<void> loadCart() async {
    emit(state.copyWith(isLoading: true, isError: false));
    try {
      final cart = await sl.get<CartRepository>().getCart();
      emit(state.copyWith(cart: cart, isLoading: false, isError: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          message: 'Failed to load cart: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> addProduct(ProductEntity product, {int quantity = 1}) async {
    try {
      final updatedCart = await sl.get<CartRepository>().addProductToCart(
        product,
        quantity: quantity,
      );
      emit(
        state.copyWith(
          cart: updatedCart,
          isError: false,
          message: 'Product added to cart',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to add product: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> removeProduct(int productId) async {
    try {
      final updatedCart = await sl.get<CartRepository>().removeProductFromCart(
        productId,
      );
      emit(
        state.copyWith(
          cart: updatedCart,
          isError: false,
          message: 'Product removed from cart',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to remove product: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      final updatedCart = await sl.get<CartRepository>().updateProductQuantity(
        productId,
        quantity,
      );
      emit(state.copyWith(cart: updatedCart, isError: false));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to update quantity: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> increaseQuantity(int productId) async {
    try {
      final updatedCart = await sl
          .get<CartRepository>()
          .increaseProductQuantity(productId);
      emit(state.copyWith(cart: updatedCart, isError: false));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to increase quantity: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> decreaseQuantity(int productId) async {
    try {
      final updatedCart = await sl
          .get<CartRepository>()
          .decreaseProductQuantity(productId);
      emit(state.copyWith(cart: updatedCart, isError: false));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to decrease quantity: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> clearCart() async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl.get<CartRepository>().clearCart();
      emit(
        state.copyWith(
          cart: CartModel.empty(),
          isLoading: false,
          isError: false,
          message: 'Cart cleared',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          message: 'Failed to clear cart: ${e.toString()}',
        ),
      );
    }
  }
}
