import 'package:equatable/equatable.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';

class CartItemModel extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemModel({required this.product, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductEntity(
        id: json['product']['id'] as int,
        name: json['product']['name'] as String,
        slug: json['product']['slug'] as String,
        permalink: json['product']['permalink'] as String,
        dateCreated: json['product']['dateCreated'] as String,
        dateModified: json['product']['dateModified'] as String,
        type: json['product']['type'] as String,
        status: json['product']['status'] as String,
        featured: json['product']['featured'] as bool,
        catalogVisibility: json['product']['catalogVisibility'] as String,
        description: json['product']['description'] as String,
        shortDescription: json['product']['shortDescription'] as String,
        sku: json['product']['sku'] as String,
        price: json['product']['price'] as String,
        regularPrice: json['product']['regularPrice'] as String,
        salePrice: json['product']['salePrice'] as String,
        onSale: json['product']['onSale'] as bool,
        purchasable: json['product']['purchasable'] as bool,
        totalSales: json['product']['totalSales'] as int,
        virtual: json['product']['virtual'] as bool,
        downloadable: json['product']['downloadable'] as bool,
        manageStock: json['product']['manageStock'] as bool,
        stockQuantity: json['product']['stockQuantity'] as int?,
        stockStatus: json['product']['stockStatus'] as String,
        hasOptions: json['product']['hasOptions'] as bool,
        images: [], // Simplified for cart storage
        categories: [], // Simplified for cart storage
        brands: [], // Simplified for cart storage
        priceHtml: json['product']['priceHtml'] as String,
        relatedIds: [], // Simplified for cart storage
      ),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'name': product.name,
        'slug': product.slug,
        'permalink': product.permalink,
        'dateCreated': product.dateCreated,
        'dateModified': product.dateModified,
        'type': product.type,
        'status': product.status,
        'featured': product.featured,
        'catalogVisibility': product.catalogVisibility,
        'description': product.description,
        'shortDescription': product.shortDescription,
        'sku': product.sku,
        'price': product.price,
        'regularPrice': product.regularPrice,
        'salePrice': product.salePrice,
        'onSale': product.onSale,
        'purchasable': product.purchasable,
        'totalSales': product.totalSales,
        'virtual': product.virtual,
        'downloadable': product.downloadable,
        'manageStock': product.manageStock,
        'stockQuantity': product.stockQuantity,
        'stockStatus': product.stockStatus,
        'hasOptions': product.hasOptions,
        'priceHtml': product.priceHtml,
      },
      'quantity': quantity,
    };
  }

  CartItemModel copyWith({ProductEntity? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
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
    final price = double.tryParse(product.price) ?? 0.0;
    return price * quantity;
  }

  @override
  List<Object?> get props => [product, quantity];
}
