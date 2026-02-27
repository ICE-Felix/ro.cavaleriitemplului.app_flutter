import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String status;
  final String? note;
  final double total;
  final String userName;
  final String userEmail;
  final DateTime createdAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.status,
    this.note,
    required this.total,
    required this.userName,
    required this.userEmail,
    required this.createdAt,
    this.items = const [],
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String? ?? 'pending',
      note: json['note'] as String?,
      total: (json['total'] as num).toDouble(),
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: json['shop_order_items'] != null
          ? (json['shop_order_items'] as List)
              .map((item) => OrderItemEntity.fromJson(item))
              .toList()
          : [],
    );
  }

  @override
  List<Object?> get props => [id, userId, status, note, total, userName, userEmail, createdAt, items];
}
