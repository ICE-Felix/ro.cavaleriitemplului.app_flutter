import 'package:app/core/service_locator.dart';
import 'package:app/features/checkout/domain/models/checkout_model.dart';
import 'package:app/features/checkout/domain/models/billing_address_model.dart';
import 'package:app/features/checkout/domain/models/shipping_address_model.dart';
import 'package:app/features/checkout/domain/models/payment_method_model.dart';
import 'package:app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutState(checkout: CheckoutModel.empty()));

  Future<void> loadCheckout() async {
    emit(state.copyWith(isLoading: true, isError: false, message: ''));

    try {
      final repository = sl<CheckoutRepository>();
      final checkout = await repository.getCheckout();
      final paymentMethods = PaymentMethodModel.getDefaultPaymentMethods();

      emit(
        state.copyWith(
          checkout: checkout,
          availablePaymentMethods: paymentMethods,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          message: 'Failed to load checkout data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> updateBilling(BillingAddressModel billing) async {
    try {
      final repository = sl<CheckoutRepository>();
      await repository.updateBilling(billing);

      final updatedCheckout = state.checkout.copyWith(billing: billing);
      emit(state.copyWith(checkout: updatedCheckout));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to update billing address: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> updateShipping(ShippingAddressModel shipping) async {
    try {
      final repository = sl<CheckoutRepository>();
      await repository.updateShipping(shipping);

      final updatedCheckout = state.checkout.copyWith(shipping: shipping);
      emit(state.copyWith(checkout: updatedCheckout));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to update shipping address: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      final repository = sl<CheckoutRepository>();
      await repository.updatePaymentMethod(paymentMethod);

      final updatedCheckout = state.checkout.copyWith(
        selectedPaymentMethod: paymentMethod,
      );
      emit(state.copyWith(checkout: updatedCheckout));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to update payment method: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> updateBillingSameAsShipping(bool value) async {
    try {
      final repository = sl<CheckoutRepository>();
      await repository.updateBillingSameAsShipping(value);

      final updatedCheckout = state.checkout.updateBillingSameAsShipping(value);
      emit(state.copyWith(checkout: updatedCheckout));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          message: 'Failed to update billing same as shipping: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> clearCheckout() async {
    emit(state.copyWith(isLoading: true, isError: false, message: ''));

    try {
      final repository = sl<CheckoutRepository>();
      await repository.clearCheckout();

      emit(
        state.copyWith(
          checkout: CheckoutModel.empty(),
          isLoading: false,
          message: 'Checkout cleared successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          message: 'Failed to clear checkout: ${e.toString()}',
        ),
      );
    }
  }

  void clearError() {
    emit(state.copyWith(isError: false, message: ''));
  }
}
