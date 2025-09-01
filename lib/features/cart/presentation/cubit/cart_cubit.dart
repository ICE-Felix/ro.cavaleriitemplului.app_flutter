import 'dart:ui';

import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/data/request/cart_stock_request.dart';
import 'package:app/features/cart/domain/models/cart_model.dart';
import 'package:app/features/cart/domain/models/cart_stock_response_model.dart';
import 'package:app/features/cart/domain/repositories/cart_repository.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(cart: CartModel.empty()));

  Future<void> loadCart() async {
    emit(state.copyWith(isLoading: true, isError: false));
    try {
      final cart = await sl.get<CartRepository>().getCart();
      final cartStock = await sl.get<CartRepository>().verifyStock(
        CartStockRequest.fromCart(cart),
      );
      emit(
        state.copyWith(
          cart: cart,
          isLoading: false,
          isError: false,
          cartStock: cartStock,
        ),
      );
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

  Future<void> addProduct(
    ProductEntity product, {
    int quantity = 1,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final updatedCart = await sl.get<CartRepository>().addProductToCart(
        product,
        quantity: quantity,
      );
      final cartStock = await sl.get<CartRepository>().verifyStock(
        CartStockRequest.fromCart(updatedCart),
      );
      emit(
        state.copyWith(cart: updatedCart, isError: false, cartStock: cartStock),
      );
      onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isError: true));
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      onError?.call();
    }
  }

  Future<void> removeProduct(
    int productId, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final updatedCart = await sl.get<CartRepository>().removeProductFromCart(
        productId,
      );
      final newState = await _getStockRemovedState(
        emitState: state.copyWith(cart: updatedCart, isError: false),
        cart: updatedCart,
      );
      emit(newState);
      onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isError: true));
      onError?.call();
    }
  }

  Future<void> updateQuantity(
    int productId,
    int quantity, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final updatedCart = await sl.get<CartRepository>().updateProductQuantity(
        productId,
        quantity,
      );

      emit(state.copyWith(cart: updatedCart, isError: false));
      onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isError: true));
      onError?.call();
    }
  }

  Future<void> increaseQuantity(
    int productId, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final updatedCart = await sl
          .get<CartRepository>()
          .increaseProductQuantity(productId);
      emit(state.copyWith(cart: updatedCart, isError: false));
      onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isError: true));
      onError?.call();
    }
  }

  Future<void> decreaseQuantity(
    int productId, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final updatedCart = await sl
          .get<CartRepository>()
          .decreaseProductQuantity(productId);
      final newState = await _getStockRemovedState(
        emitState: state.copyWith(cart: updatedCart, isError: false),
        cart: updatedCart,
      );
      emit(newState);
      onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isError: true));
      onError?.call();
    }
  }

  Future<void> clearCart({
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sl.get<CartRepository>().clearCart();
      emit(
        state.copyWith(
          cart: CartModel.empty(),
          cartStock: CartStockResponseModel.empty(),
          isLoading: false,
          isError: false,
        ),
      );
      onSuccess?.call();
    } catch (e) {
      emit(state.copyWith(isLoading: false, isError: true));
      onError?.call();
    }
  }

  Future<(bool, String?)> checkCurrentStock() async {
    emit(state.copyWith(isCheckoutLoading: true));
    final cartStock = await sl.get<CartRepository>().verifyStock(
      CartStockRequest.fromCart(state.cart),
    );
    emit(state.copyWith(cartStock: cartStock, isCheckoutLoading: false));
    return (cartStock.allAvailable, 'Not all items are in stock!');
  }

  Future<CartState> _getStockRemovedState({
    required CartState emitState,
    required CartModel cart,
  }) async {
    if (emitState.cartStock == null ||
        emitState.cartStock!.allAvailable == false) {
      final cartStock = await sl.get<CartRepository>().verifyStock(
        CartStockRequest.fromCart(cart),
      );
      return emitState.copyWith(cartStock: cartStock);
    } else {
      return emitState;
    }
  }
}
