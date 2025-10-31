import 'package:app/features/cart/data/datasource/cart_stock_datasource.dart';
import 'package:app/features/cart/data/request/cart_stock_request.dart';
import 'package:app/features/cart/data/services/cart_service.dart';
import 'package:app/features/cart/domain/models/cart_item_model.dart';
import 'package:app/features/cart/domain/models/cart_model.dart';
import 'package:app/features/cart/domain/models/cart_stock_response_model.dart';

/// Abstract repository defining cart operations
abstract class CartRepository {
  Future<CartModel> getCart();
  Future<bool> saveCart(CartModel cart);
  Future<bool> clearCart();
  Future<CartModel> addProductToCart(CartItemModel item);
  Future<CartModel> removeProductFromCart(int productId);
  Future<CartModel> updateProductQuantity(int productId, int quantity);
  Future<CartModel> increaseProductQuantity(int productId);
  Future<CartModel> decreaseProductQuantity(int productId);
  Future<bool> hasCart();
  Future<CartStockResponseModel> verifyStock(CartStockRequest request);
}

/// Implementation of CartRepository
class CartRepositoryImpl implements CartRepository {
  final CartService _cartService;
  final CartStockDatasource _cartStockDatasource;

  CartRepositoryImpl(this._cartService, this._cartStockDatasource);

  @override
  Future<CartModel> getCart() async {
    final cart = await _cartService.loadCart();
    return cart ?? CartModel.empty();
  }

  @override
  Future<bool> saveCart(CartModel cart) async {
    return await _cartService.saveCart(cart);
  }

  @override
  Future<bool> clearCart() async {
    return await _cartService.deleteCart();
  }

  @override
  Future<CartModel> addProductToCart(CartItemModel item) async {
    final currentCart = await getCart();
    final updatedCart = currentCart.addItem(item);

    await saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartModel> removeProductFromCart(int productId) async {
    final currentCart = await getCart();
    final updatedCart = currentCart.removeItem(productId);

    await saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartModel> updateProductQuantity(int productId, int quantity) async {
    final currentCart = await getCart();
    final updatedCart = currentCart.updateItemQuantity(productId, quantity);

    await saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartModel> increaseProductQuantity(int productId) async {
    final currentCart = await getCart();
    final updatedCart = currentCart.increaseItemQuantity(productId);

    await saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartModel> decreaseProductQuantity(int productId) async {
    final currentCart = await getCart();
    final updatedCart = currentCart.decreaseItemQuantity(productId);

    await saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<bool> hasCart() async {
    return await _cartService.hasCart();
  }

  @override
  Future<CartStockResponseModel> verifyStock(CartStockRequest request) async {
    return await _cartStockDatasource.verifyStock(request);
  }
}
