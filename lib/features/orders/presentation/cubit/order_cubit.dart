import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/domain/models/cart_model.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:app/features/orders/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  Future<void> placeOrder({
    required CartModel cart,
    String? note,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = Supabase.instance.client.auth.currentUser!;
      final userName = user.userMetadata?['full_name'] as String? ??
          user.userMetadata?['name'] as String? ??
          user.email ?? 'Unknown';
      final userEmail = user.email ?? '';

      final items = cart.items.map((item) => {
        'product_id': item.sku, // sku holds the UUID
        'product_name': item.name,
        'product_price': double.tryParse(item.price) ?? 0.0,
        'quantity': item.quantity,
      }).toList();

      final order = await sl<OrderRepository>().placeOrder(
        userId: user.id,
        userName: userName,
        userEmail: userEmail,
        total: cart.totalPrice,
        note: note,
        items: items,
      );

      emit(state.copyWith(isLoading: false, order: order));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
