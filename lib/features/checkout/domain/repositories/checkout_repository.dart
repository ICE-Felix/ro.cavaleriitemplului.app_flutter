import '../models/checkout_model.dart';
import '../models/billing_address_model.dart';
import '../models/shipping_address_model.dart';
import '../models/payment_method_model.dart';
import '../../data/datasources/checkout_remote_data_source.dart';

abstract class CheckoutRepository {
  Future<CheckoutModel> getCheckout();
  Future<void> updateBilling(BillingAddressModel billing);
  Future<void> updateShipping(ShippingAddressModel shipping);
  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod);
  Future<void> updateBillingSameAsShipping(bool value);
  Future<void> saveCheckout(CheckoutModel checkout);
  Future<void> clearCheckout();
}

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource _remoteDataSource;

  CheckoutRepositoryImpl(this._remoteDataSource);

  @override
  Future<CheckoutModel> getCheckout() async {
    try {
      final checkout = await _remoteDataSource.getCheckout();
      return checkout ?? CheckoutModel.empty();
    } catch (e) {
      throw Exception('Failed to get checkout data: $e');
    }
  }

  @override
  Future<void> updateBilling(BillingAddressModel billing) async {
    try {
      await _remoteDataSource.updateBilling(billing);
    } catch (e) {
      throw Exception('Failed to update billing address: $e');
    }
  }

  @override
  Future<void> updateShipping(ShippingAddressModel shipping) async {
    try {
      await _remoteDataSource.updateShipping(shipping);
    } catch (e) {
      throw Exception('Failed to update shipping address: $e');
    }
  }

  @override
  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      await _remoteDataSource.updatePaymentMethod(paymentMethod);
    } catch (e) {
      throw Exception('Failed to update payment method: $e');
    }
  }

  @override
  Future<void> updateBillingSameAsShipping(bool value) async {
    try {
      final currentCheckout = await getCheckout();
      final updatedCheckout = currentCheckout.updateBillingSameAsShipping(
        value,
      );
      await _remoteDataSource.saveCheckout(updatedCheckout);
    } catch (e) {
      throw Exception('Failed to update billing same as shipping: $e');
    }
  }

  @override
  Future<void> saveCheckout(CheckoutModel checkout) async {
    try {
      await _remoteDataSource.saveCheckout(checkout);
    } catch (e) {
      throw Exception('Failed to save checkout: $e');
    }
  }

  @override
  Future<void> clearCheckout() async {
    try {
      await _remoteDataSource.deleteCheckout();
    } catch (e) {
      throw Exception('Failed to clear checkout: $e');
    }
  }
}
