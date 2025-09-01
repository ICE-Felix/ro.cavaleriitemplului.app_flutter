import 'package:collection/collection.dart';

class CartStockResponseModel {
  final bool success;
  final bool allAvailable;
  final List<ProductStockInfo> products;
  final StockSummary summary;

  const CartStockResponseModel({
    required this.success,
    required this.allAvailable,
    required this.products,
    required this.summary,
  });

  ProductStockInfo? getProductStockInfo(int productId) {
    return products.firstWhereOrNull((product) => product.productId == productId);
  }

  factory CartStockResponseModel.empty() {
    return const CartStockResponseModel(
      success: true,
      allAvailable: true,
      products: [],
      summary: StockSummary(
        totalProducts: 0,
        availableProducts: 0,
        unavailableProducts: 0,
      ),
    );
  }

  factory CartStockResponseModel.fromJson(Map<String, dynamic> json) {
    return CartStockResponseModel(
      success: json['success'] as bool,
      allAvailable: json['all_available'] as bool,
      products:
          (json['products'] as List<dynamic>)
              .map(
                (product) =>
                    ProductStockInfo.fromJson(product as Map<String, dynamic>),
              )
              .toList(),
      summary: StockSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'all_available': allAvailable,
      'products': products.map((product) => product.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }
}

class ProductStockInfo {
  final int productId;
  final String productName;
  final bool available;
  final String? error;
  final int requestedQuantity;
  final int? availableQuantity;
  final String stockStatus;
  final bool manageStock;

  const ProductStockInfo({
    required this.productId,
    required this.productName,
    required this.available,
    this.error,
    required this.requestedQuantity,
    this.availableQuantity,
    required this.stockStatus,
    required this.manageStock,
  });

  factory ProductStockInfo.fromJson(Map<String, dynamic> json) {
    return ProductStockInfo(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      available: json['available'] as bool,
      error: json['error'] as String?,
      requestedQuantity: json['requested_quantity'] as int,
      availableQuantity: json['available_quantity'] as int?,
      stockStatus: json['stock_status'] as String,
      manageStock: json['manage_stock'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'available': available,
      'error': error,
      'requested_quantity': requestedQuantity,
      'available_quantity': availableQuantity,
      'stock_status': stockStatus,
      'manage_stock': manageStock,
    };
  }
}

class StockSummary {
  final int totalProducts;
  final int availableProducts;
  final int unavailableProducts;

  const StockSummary({
    required this.totalProducts,
    required this.availableProducts,
    required this.unavailableProducts,
  });

  factory StockSummary.fromJson(Map<String, dynamic> json) {
    return StockSummary(
      totalProducts: json['total_products'] as int,
      availableProducts: json['available_products'] as int,
      unavailableProducts: json['unavailable_products'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_products': totalProducts,
      'available_products': availableProducts,
      'unavailable_products': unavailableProducts,
    };
  }
}
