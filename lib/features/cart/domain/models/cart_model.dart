import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'cart_item_model.dart';

class CartModel extends Equatable {
  final List<CartItemModel> items;
  final String lastDateModified;

  const CartModel({required this.items, required this.lastDateModified});

  factory CartModel.empty() {
    return CartModel(
      items: const [],
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((itemJson) => CartItemModel.fromJson(itemJson))
              .toList() ??
          [],
      lastDateModified:
          json['lastDateModified'] as String? ??
          DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'lastDateModified': lastDateModified,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory CartModel.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return CartModel.fromJson(json);
  }

  CartModel copyWith({List<CartItemModel>? items, String? lastDateModified}) {
    return CartModel(
      items: items ?? this.items,
      lastDateModified: lastDateModified ?? this.lastDateModified,
    );
  }

  CartModel addProduct(ProductEntity product, {int quantity = 1}) {
    final updatedItems = List<CartItemModel>.from(items);

    // Check if product already exists in cart
    final existingIndex = updatedItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      // Add new item
      updatedItems.add(CartItemModel(product: product, quantity: quantity));
    } else {
      // Update existing item quantity
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    }

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel removeProduct(int productId) {
    final updatedItems =
        items.where((item) => item.product.id != productId).toList();

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel updateProductQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeProduct(productId);
    }

    final updatedItems =
        items.map((item) {
          if (item.product.id == productId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel increaseProductQuantity(int productId) {
    final updatedItems =
        items.map((item) {
          if (item.product.id == productId) {
            return item.increaseQuantity();
          }
          return item;
        }).toList();

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel decreaseProductQuantity(int productId) {
    final updatedItems =
        items
            .map((item) {
              if (item.product.id == productId) {
                final updatedItem = item.decreaseQuantity();
                // If quantity becomes 0, remove the item
                return updatedItem.quantity > 0 ? updatedItem : null;
              }
              return item;
            })
            .where((item) => item != null)
            .cast<CartItemModel>()
            .toList();

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get itemCount => items.length;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  CartItemModel? getItem(int productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [items, lastDateModified];
}
