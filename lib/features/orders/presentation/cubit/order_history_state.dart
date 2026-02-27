part of 'order_history_cubit.dart';

class OrderHistoryState extends Equatable {
  final List<OrderEntity> orders;
  final bool isLoading;
  final String? error;

  const OrderHistoryState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrderHistoryState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, error];
}
