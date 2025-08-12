import 'package:app/features/checkout/data/order_datasource.dart';
import 'package:app/features/checkout/domain/models/order_request_model.dart';

abstract class OrderRepository {
  final OrderDataSource orderDataSource;
  Future<String> createOrder(OrderRequestModel orderRequest);

  OrderRepository({required this.orderDataSource});
}

class OrderRepositoryImpl extends OrderRepository {
  OrderRepositoryImpl({required super.orderDataSource});

  @override
  Future<String> createOrder(OrderRequestModel orderRequest) async {
    final result = await orderDataSource.createOrder(orderRequest);

    return result.data.paymentUrl;
  }
}
