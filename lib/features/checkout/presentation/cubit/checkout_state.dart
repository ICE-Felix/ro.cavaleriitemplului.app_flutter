part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.checkout,
    this.availablePaymentMethods = const [],
    this.isLoading = false,
    this.isError = false,
    this.message = '',
  });

  final CheckoutModel checkout;
  final List<PaymentMethodModel> availablePaymentMethods;
  final bool isLoading;
  final bool isError;
  final String message;

  CheckoutState copyWith({
    CheckoutModel? checkout,
    List<PaymentMethodModel>? availablePaymentMethods,
    bool? isLoading,
    bool? isError,
    String? message,
  }) {
    return CheckoutState(
      checkout: checkout ?? this.checkout,
      availablePaymentMethods:
          availablePaymentMethods ?? this.availablePaymentMethods,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    checkout,
    availablePaymentMethods,
    isLoading,
    isError,
    message,
  ];
}
