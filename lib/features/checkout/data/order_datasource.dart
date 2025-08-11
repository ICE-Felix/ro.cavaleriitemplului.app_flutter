import 'package:app/features/checkout/domain/models/order_request_model.dart';
import 'package:app/features/checkout/domain/models/order_response_model.dart';

abstract class OrderDataSource {
  Future<OrderResponseModel> createOrder(OrderRequestModel orderRequest);
}
