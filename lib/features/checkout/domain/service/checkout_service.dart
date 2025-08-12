import 'dart:convert';

import 'package:app/features/checkout/domain/models/checkout_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CheckoutService {
  Future<void> saveInfo(CheckoutModel checkout);
  Future<void> clearCheckout();
  Future<CheckoutModel?> getCheckout();
}

class CheckoutServiceImpl implements CheckoutService {
  final String _checkoutKey = 'checkout';
  @override
  Future<void> saveInfo(CheckoutModel checkout) async {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(checkout.toJson());
      await prefs.setString(_checkoutKey, json);
  }

  @override
  Future<void> clearCheckout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkoutKey);
  }

  @override
  Future<CheckoutModel?> getCheckout() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_checkoutKey);
    if (json == null) {
      return null;
    }
    return CheckoutModel.fromJson(jsonDecode(json));
  }
}
