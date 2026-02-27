part of 'order_cubit.dart';

class OrderState extends Equatable {
  final bool isLoading;
  final OrderEntity? order;
  final String? error;

  const OrderState({
    this.isLoading = false,
    this.order,
    this.error,
  });

  OrderState copyWith({
    bool? isLoading,
    OrderEntity? order,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, order, error];
}
