import 'package:app/core/network/dio_client.dart';
import 'package:app/core/error/exceptions.dart';
import '../../domain/models/checkout_model.dart';
import '../../domain/models/billing_address_model.dart';
import '../../domain/models/shipping_address_model.dart';
import '../../domain/models/payment_method_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<CheckoutModel?> getCheckout();
  Future<void> saveCheckout(CheckoutModel checkout);
  Future<void> deleteCheckout();
  Future<void> updateBilling(BillingAddressModel billing);
  Future<void> updateShipping(ShippingAddressModel shipping);
  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final DioClient dio;

  CheckoutRemoteDataSourceImpl({required this.dio});

  @override
  Future<CheckoutModel?> getCheckout() async {
    try {
      final response = await dio.get('/checkout');

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic>? checkoutData =
          response['data'] as Map<String, dynamic>?;

      if (checkoutData != null) {
        return CheckoutModel.fromJson(checkoutData);
      }

      return null;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> saveCheckout(CheckoutModel checkout) async {
    try {
      final response = await dio.post('/checkout', data: checkout.toJson());

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteCheckout() async {
    try {
      final response = await dio.delete('/checkout');

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateBilling(BillingAddressModel billing) async {
    try {
      final response = await dio.put(
        '/checkout/billing',
        data: billing.toJson(),
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateShipping(ShippingAddressModel shipping) async {
    try {
      final response = await dio.put(
        '/checkout/shipping',
        data: shipping.toJson(),
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      final response = await dio.put(
        '/checkout/payment-method',
        data: paymentMethod.toJson(),
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
