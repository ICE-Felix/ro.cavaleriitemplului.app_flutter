import 'package:app/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:app/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource dataSource;

  OrderRepositoryImpl({required this.dataSource});

  @override
  Future<OrderEntity> placeOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required double total,
    String? note,
    required List<Map<String, dynamic>> items,
  }) => dataSource.placeOrder(
    userId: userId,
    userName: userName,
    userEmail: userEmail,
    total: total,
    note: note,
    items: items,
  );

  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();

  @override
  Future<OrderEntity> getOrderById(String orderId) => dataSource.getOrderById(orderId);
}
