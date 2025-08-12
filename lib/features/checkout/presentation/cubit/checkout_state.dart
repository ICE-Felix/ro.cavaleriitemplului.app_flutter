part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.checkout,
    this.availablePaymentMethods = const [],
    this.isLoading = false,
    this.isError = false,
    this.redirectUrl = '',
    this.isPayReady = false,
    this.closeCheckout = false,
    this.message = '',
  });

  final CheckoutModel checkout;
  final List<PaymentMethodModel> availablePaymentMethods;
  final bool isLoading;
  final bool isError;
  final bool isPayReady;
  final String redirectUrl;
  final bool closeCheckout;
  final String message;

  CheckoutState copyWith({
    CheckoutModel? checkout,
    List<PaymentMethodModel>? availablePaymentMethods,
    bool? isLoading,
    bool? isError,
    bool? isPayReady,
    String? redirectUrl,
    bool? closeCheckout,
    String? message,
  }) {
    return CheckoutState(
      checkout: checkout ?? this.checkout,
      availablePaymentMethods:
          availablePaymentMethods ?? this.availablePaymentMethods,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isPayReady: isPayReady ?? this.isPayReady,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      closeCheckout: closeCheckout ?? this.closeCheckout,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    checkout,
    availablePaymentMethods,
    isLoading,
    isError,
    isPayReady,
    redirectUrl,
    closeCheckout,
    message,
  ];
}
