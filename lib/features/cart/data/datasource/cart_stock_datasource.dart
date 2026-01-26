import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/woocommerce_api_client.dart';
import 'package:app/features/cart/data/request/cart_stock_request.dart';
import 'package:app/features/cart/domain/models/cart_stock_response_model.dart';
import 'package:flutter/foundation.dart';

abstract class CartStockDatasource {
  Future<CartStockResponseModel> verifyStock(CartStockRequest request);
}

class CartStockDatasourceImpl implements CartStockDatasource {
  final WooCommerceApiClient wooCommerce;
  CartStockDatasourceImpl({required this.wooCommerce});

  @override
  Future<CartStockResponseModel> verifyStock(CartStockRequest request) async {
    try {
      if (kDebugMode) {
        print('🛒 CartStockDatasource: Verifying stock for ${request.products.length} products');
      }

      // If cart is empty, return empty response
      if (request.products.isEmpty) {
        return CartStockResponseModel.empty();
      }

      // Fetch product details from WooCommerce for each product in cart
      final List<ProductStockInfo> productStockInfos = [];

      for (final cartEntry in request.products) {
        try {
          if (kDebugMode) {
            print('🛒 CartStockDatasource: Fetching product ${cartEntry.productId}');
          }

          final response = await wooCommerce.get('/products/${cartEntry.productId}');

          if (response is! Map<String, dynamic>) {
            throw ServerException(message: 'Invalid product response for ID ${cartEntry.productId}');
          }

          final product = response;
          final stockStatus = product['stock_status'] as String? ?? 'outofstock';
          final manageStock = product['manage_stock'] as bool? ?? false;
          final stockQuantity = product['stock_quantity'] as int?;

          // Determine if product is available in requested quantity
          bool available = false;
          String? error;

          if (stockStatus == 'instock') {
            if (manageStock && stockQuantity != null) {
              // Check if requested quantity is available
              available = cartEntry.quantity <= stockQuantity;
              if (!available) {
                error = 'Only $stockQuantity available';
              }
            } else {
              // Stock not managed, assume available
              available = true;
            }
          } else {
            error = 'Product out of stock';
          }

          productStockInfos.add(
            ProductStockInfo(
              productId: cartEntry.productId,
              productName: product['name'] as String? ?? 'Unknown',
              available: available,
              error: error,
              requestedQuantity: cartEntry.quantity,
              availableQuantity: stockQuantity,
              stockStatus: stockStatus,
              manageStock: manageStock,
            ),
          );

          if (kDebugMode) {
            print('✅ CartStockDatasource: Product ${cartEntry.productId} - available: $available, stock: $stockStatus');
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ CartStockDatasource: Error fetching product ${cartEntry.productId}: $e');
          }

          // Add product with error
          productStockInfos.add(
            ProductStockInfo(
              productId: cartEntry.productId,
              productName: 'Unknown',
              available: false,
              error: 'Product not found: ${cartEntry.productId}',
              requestedQuantity: cartEntry.quantity,
              availableQuantity: null,
              stockStatus: 'outofstock',
              manageStock: false,
            ),
          );
        }
      }

      // Calculate summary
      final availableProducts = productStockInfos.where((p) => p.available).length;
      final unavailableProducts = productStockInfos.length - availableProducts;
      final allAvailable = unavailableProducts == 0;

      final response = CartStockResponseModel(
        success: true,
        allAvailable: allAvailable,
        products: productStockInfos,
        summary: StockSummary(
          totalProducts: productStockInfos.length,
          availableProducts: availableProducts,
          unavailableProducts: unavailableProducts,
        ),
      );

      if (kDebugMode) {
        print('✅ CartStockDatasource: Stock verification complete - All available: $allAvailable');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ CartStockDatasource: Error verifying stock: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
