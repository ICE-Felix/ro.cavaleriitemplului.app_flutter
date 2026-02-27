import 'package:app/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> placeOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required double total,
    String? note,
    required List<Map<String, dynamic>> items,
  });
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrderById(String orderId);
}
