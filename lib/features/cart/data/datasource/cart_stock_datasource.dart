import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/dio_client.dart';
import 'package:app/features/cart/data/request/cart_stock_request.dart';
import 'package:app/features/cart/domain/models/cart_stock_response_model.dart';

abstract class CartStockDatasource {
  Future<CartStockResponseModel> verifyStock(CartStockRequest request);
}

class CartStockDatasourceImpl implements CartStockDatasource {
  final DioClient dio;
  CartStockDatasourceImpl({required this.dio});

  @override
  Future<CartStockResponseModel> verifyStock(CartStockRequest request) async {
    try {
      final response = await dio.post(
        '/woo_stock_check',
        data: request.toJson(),
      );

      if (response['success'] != true) {
        throw ServerException(
          message: response['error']?['message'] ?? 'Unknown error',
        );
      }

      return CartStockResponseModel.fromJson(response['data']);
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
