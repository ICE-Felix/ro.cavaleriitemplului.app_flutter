import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final String price;
  final String regularPrice;
  final String salePrice;
  final bool onSale;
  final String sku;
  final int quantity;
  final String
  productType; // We put here what we want, to know where was this product added from

  const CartItemModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    required this.sku,
    required this.quantity,
    this.productType = 'product',
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      price: json['price'] as String,
      regularPrice: json['regularPrice'] as String? ?? json['price'] as String,
      salePrice: json['salePrice'] as String? ?? '',
      onSale: json['onSale'] as bool? ?? false,
      sku: json['sku'] as String,
      quantity: json['quantity'] as int,
      productType: json['productType'] as String? ?? 'product',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'regularPrice': regularPrice,
      'salePrice': salePrice,
      'onSale': onSale,
      'sku': sku,
      'quantity': quantity,
      'productType': productType,
    };
  }

  CartItemModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? price,
    String? regularPrice,
    String? salePrice,
    bool? onSale,
    String? sku,
    int? quantity,
    String? productType,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      onSale: onSale ?? this.onSale,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      productType: productType ?? this.productType,
    );
  }

  CartItemModel increaseQuantity() {
    return copyWith(quantity: quantity + 1);
  }

  CartItemModel decreaseQuantity() {
    if (quantity <= 1) return this;
    return copyWith(quantity: quantity - 1);
  }

  double get totalPrice {
    final priceValue = double.tryParse(price) ?? 0.0;
    return priceValue * quantity;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    price,
    regularPrice,
    salePrice,
    onSale,
    sku,
    quantity,
    productType,
  ];
}
