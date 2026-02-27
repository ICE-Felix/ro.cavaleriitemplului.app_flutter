import 'package:equatable/equatable.dart';
import 'package:app/features/cart/domain/models/cart_item_model.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? salePrice;
  final List<String> images;
  final String? categoryId;
  final int sortOrder;

  bool get onSale => salePrice != null && salePrice! < price;
  double get displayPrice => onSale ? salePrice! : price;
  String? get firstImage => images.isNotEmpty ? images.first : null;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.salePrice,
    this.images = const [],
    this.categoryId,
    this.sortOrder = 0,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      salePrice: json['sale_price'] != null ? (json['sale_price'] as num).toDouble() : null,
      images: json['images'] != null ? List<String>.from(json['images'] as List) : [],
      categoryId: json['category_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  CartItemModel toCartModel({int quantity = 1}) {
    return CartItemModel(
      id: id.hashCode,
      name: name,
      imageUrl: firstImage,
      price: displayPrice.toStringAsFixed(2),
      regularPrice: price.toStringAsFixed(2),
      salePrice: salePrice?.toStringAsFixed(2) ?? '',
      onSale: onSale,
      sku: id,
      quantity: quantity,
      productType: 'product',
    );
  }

  @override
  List<Object?> get props => [id, name, slug, description, price, salePrice, images, categoryId, sortOrder];
}
