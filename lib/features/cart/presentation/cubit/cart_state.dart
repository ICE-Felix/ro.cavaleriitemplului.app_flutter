part of 'cart_cubit.dart';

class CartState extends Equatable {
  const CartState({
    required this.cart,
    this.isLoading = false,
    this.isError = false,
    this.message = '',
    this.cartStock,
    this.isCheckoutLoading = false,
  });

  final CartModel cart;
  final bool isLoading;
  final bool isCheckoutLoading;
  final bool isError;
  final String message;
  final CartStockResponseModel? cartStock;

  CartState copyWith({
    CartModel? cart,
    bool? isLoading,
    bool? isError,
    String? message,
    CartStockResponseModel? cartStock,
    bool? isCheckoutLoading,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      cartStock: cartStock ?? this.cartStock,
      isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
    );
  }

  @override
  List<Object?> get props => [
    cart,
    isLoading,
    isError,
    message,
    cartStock,
    isCheckoutLoading,
  ];
}
