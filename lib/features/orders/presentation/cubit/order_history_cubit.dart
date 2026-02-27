import 'package:app/core/service_locator.dart';
import 'package:app/features/orders/domain/entities/order_entity.dart';
import 'package:app/features/orders/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(const OrderHistoryState());

  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final orders = await sl<OrderRepository>().getOrders();
      emit(state.copyWith(orders: orders, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
