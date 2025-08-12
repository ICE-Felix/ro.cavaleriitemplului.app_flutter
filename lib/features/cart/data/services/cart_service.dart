import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/cart_model.dart';

/// Abstract class defining cart service operations
abstract class CartService {
  Future<CartModel?> loadCart();
  Future<bool> saveCart(CartModel cart);
  Future<bool> deleteCart();
  Future<bool> hasCart();
}

/// Implementation of CartService using SharedPreferences
class CartServiceImpl implements CartService {
  static const String _cartKey = 'user_cart';

  @override
  Future<CartModel?> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJsonString = prefs.getString(_cartKey);

      if (cartJsonString == null || cartJsonString.isEmpty) {
        return null;
      }

      return CartModel.fromJsonString(cartJsonString);
    } catch (e) {
      // If there's an error loading the cart, return null
      return null;
    }
  }

  @override
  Future<bool> saveCart(CartModel cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJsonString = cart.toJsonString();

      return await prefs.setString(_cartKey, cartJsonString);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_cartKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cartKey);
    } catch (e) {
      return false;
    }
  }
}
