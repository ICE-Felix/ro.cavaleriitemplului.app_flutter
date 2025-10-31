import 'dart:convert';
import 'package:equatable/equatable.dart';
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

  CartModel addItem(CartItemModel item) {
    final updatedItems = List<CartItemModel>.from(items);

    // Check if item already exists in cart (by id and product type)
    final existingIndex = updatedItems.indexWhere(
      (cartItem) =>
          cartItem.id == item.id && cartItem.productType == item.productType,
    );

    if (existingIndex == -1) {
      // Add new item
      updatedItems.add(item);
    } else {
      // Update existing item quantity
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    }

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel removeItem(int itemId, {String? productType}) {
    final updatedItems =
        items
            .where(
              (item) =>
                  item.id != itemId ||
                  (productType != null && item.productType != productType),
            )
            .toList();

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel updateItemQuantity(
    int itemId,
    int newQuantity, {
    String? productType,
  }) {
    if (newQuantity <= 0) {
      return removeItem(itemId, productType: productType);
    }

    final updatedItems =
        items.map((item) {
          if (item.id == itemId &&
              (productType == null || item.productType == productType)) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel increaseItemQuantity(int itemId, {String? productType}) {
    final updatedItems =
        items.map((item) {
          if (item.id == itemId &&
              (productType == null || item.productType == productType)) {
            return item.increaseQuantity();
          }
          return item;
        }).toList();

    return copyWith(
      items: updatedItems,
      lastDateModified: DateTime.now().toIso8601String(),
    );
  }

  CartModel decreaseItemQuantity(int itemId, {String? productType}) {
    final updatedItems =
        items
            .map((item) {
              if (item.id == itemId &&
                  (productType == null || item.productType == productType)) {
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

  CartItemModel? getItem(int itemId, {String? productType}) {
    try {
      return items.firstWhere(
        (item) =>
            item.id == itemId &&
            (productType == null || item.productType == productType),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [items, lastDateModified];
}
