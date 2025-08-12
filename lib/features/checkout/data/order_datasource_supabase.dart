import 'package:app/core/error/exceptions.dart';
import 'package:app/core/network/dio_client.dart';
import 'package:app/features/checkout/data/order_datasource.dart';
import 'package:app/features/checkout/domain/models/order_request_model.dart';
import 'package:app/features/checkout/domain/models/order_response_model.dart';

class OrderDataSourceSupabase implements OrderDataSource {
  final DioClient dio;
  OrderDataSourceSupabase({required this.dio});

  @override
  Future<OrderResponseModel> createOrder(OrderRequestModel orderRequest) async {
    try {
      final response = await dio.post('/woo_orders', data: orderRequest.toJson());

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
      return OrderResponseModel.fromJson(response);
    } catch (e,str) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
