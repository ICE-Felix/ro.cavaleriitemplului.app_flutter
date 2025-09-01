import 'package:app/features/cart/domain/models/cart_model.dart';

class CartStockRequest {
  final List<CartStockEntry> products;

  CartStockRequest({required this.products});

  static fromCart(CartModel cart) {
    final products = cart.items.map((item) => CartStockEntry(
          productId: item.product.id,
          quantity: item.quantity,
        )).toList();
    return CartStockRequest(products: products);
  }

  Map<String, dynamic> toJson() {
    return {'items': products.map((product) => product.toJson()).toList()};
  }
}

class CartStockEntry {
  final int productId;
  final int quantity;

  CartStockEntry({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }
}
