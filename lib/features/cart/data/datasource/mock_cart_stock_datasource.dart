import 'package:app/features/cart/data/datasource/cart_stock_datasource.dart';
import 'package:app/features/cart/data/request/cart_stock_request.dart';
import 'package:app/features/cart/domain/models/cart_stock_response_model.dart';
import 'package:app/features/shop/data/mock/mock_products.dart';

/// Mock implementation of CartStockDatasource for development and testing
/// Verifies stock against mock product data
class MockCartStockDatasource implements CartStockDatasource {
  @override
  Future<CartStockResponseModel> verifyStock(CartStockRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final allProducts = MockProducts.getMockProducts();
    final productStockInfoList = <ProductStockInfo>[];

    int availableCount = 0;
    int unavailableCount = 0;

    for (final item in request.products) {
      // Find the product in mock data
      final product = allProducts.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => throw Exception('Product not found: ${item.productId}'),
      );

      final bool isAvailable = product.stockStatus == 'instock' &&
          (product.stockQuantity == null ||
              product.stockQuantity! >= item.quantity);

      final stockInfo = ProductStockInfo(
        productId: product.id,
        productName: product.name,
        available: isAvailable,
        error: isAvailable
            ? null
            : (product.stockStatus != 'instock'
                ? 'Product is out of stock'
                : 'Insufficient stock: requested ${item.quantity}, available ${product.stockQuantity}'),
        requestedQuantity: item.quantity,
        availableQuantity: product.stockQuantity,
        stockStatus: product.stockStatus,
        manageStock: product.manageStock,
      );

      productStockInfoList.add(stockInfo);

      if (isAvailable) {
        availableCount++;
      } else {
        unavailableCount++;
      }
    }

    final bool allAvailable = unavailableCount == 0;

    return CartStockResponseModel(
      success: true,
      allAvailable: allAvailable,
      products: productStockInfoList,
      summary: StockSummary(
        totalProducts: productStockInfoList.length,
        availableProducts: availableCount,
        unavailableProducts: unavailableCount,
      ),
    );
  }
}
