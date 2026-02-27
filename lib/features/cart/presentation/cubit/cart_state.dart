part of 'cart_cubit.dart';

class CartState extends Equatable {
  const CartState({
    required this.cart,
    this.isLoading = false,
    this.isError = false,
    this.message = '',
  });

  final CartModel cart;
  final bool isLoading;
  final bool isError;
  final String message;

  CartState copyWith({
    CartModel? cart,
    bool? isLoading,
    bool? isError,
    String? message,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [cart, isLoading, isError, message];
}
