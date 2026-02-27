import 'package:app/core/network/supabase_client.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

class OrderRemoteDataSource {
  final SupabaseClient _supabaseClient;

  OrderRemoteDataSource() : _supabaseClient = SupabaseClient();

  supabase_flutter.SupabaseClient get _client => _supabaseClient.client;

  Future<OrderEntity> placeOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required double total,
    String? note,
    required List<Map<String, dynamic>> items,
  }) async {
    // Insert order
    final orderResponse = await _client
        .from('shop_orders')
        .insert({
          'user_id': userId,
          'user_name': userName,
          'user_email': userEmail,
          'total': total,
          'note': note,
        })
        .select()
        .single();

    final orderId = orderResponse['id'] as String;

    // Insert order items
    final orderItems = items.map((item) => {
      ...item,
      'order_id': orderId,
    }).toList();

    await _client.from('shop_order_items').insert(orderItems);

    // Call edge function to send email (non-blocking, order succeeds even if email fails)
    try {
      await _client.functions.invoke(
        'send-order-email',
        body: {'order_id': orderId},
      );
    } catch (_) {
      // Email notification is best-effort
    }

    // Return the created order with items
    return getOrderById(orderId);
  }

  Future<List<OrderEntity>> getOrders() async {
    final response = await _client
        .from('shop_orders')
        .select('*, shop_order_items(*)')
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => OrderEntity.fromJson(json))
        .toList();
  }

  Future<OrderEntity> getOrderById(String orderId) async {
    final response = await _client
        .from('shop_orders')
        .select('*, shop_order_items(*)')
        .eq('id', orderId)
        .single();
    return OrderEntity.fromJson(response);
  }
}
