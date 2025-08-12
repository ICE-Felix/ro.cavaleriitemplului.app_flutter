import 'dart:convert';

class OrderRequestModel {
  final String currency;
  final String paymentMethod;
  final String paymentMethodTitle;
  final bool setPaid;
  final Billing billing;
  final Shipping shipping;
  final List<LineItem> lineItems;
  final String customerNote;

  OrderRequestModel({
    required this.currency,
     this.paymentMethod ='',
     this.paymentMethodTitle ='',
    required this.setPaid,
    required this.billing,
    required this.shipping,
    required this.lineItems,
    required this.customerNote,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderRequestModel(
      currency: json['currency'] ?? 'RON',
      paymentMethod: json['payment_method'] ?? '',
      paymentMethodTitle: json['payment_method_title'] ?? '',
      setPaid: json['set_paid'] ?? false,
      billing: Billing.fromJson(json['billing'] ?? {}),
      shipping: Shipping.fromJson(json['shipping'] ?? {}),
      lineItems:
          (json['line_items'] as List<dynamic>?)
              ?.map((item) => LineItem.fromJson(item))
              .toList() ??
          [],
      customerNote: json['customer_note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'payment_method': paymentMethod,
      'payment_method_title': paymentMethodTitle,
      'set_paid': setPaid,
      'status': 'pending',
      'billing': billing.toJson(),
      'shipping': shipping.toJson(),
      'line_items': lineItems.map((item) => item.toJson()).toList(),
      'customer_note': customerNote,
    };
  }

  OrderRequestModel copyWith({
    int? customerId,
    String? status,
    String? currency,
    String? paymentMethod,
    String? paymentMethodTitle,
    bool? setPaid,
    Billing? billing,
    Shipping? shipping,
    List<LineItem>? lineItems,
    String? customerNote,
  }) {
    return OrderRequestModel(
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodTitle: paymentMethodTitle ?? this.paymentMethodTitle,
      setPaid: setPaid ?? this.setPaid,
      billing: billing ?? this.billing,
      shipping: shipping ?? this.shipping,
      lineItems: lineItems ?? this.lineItems,
      customerNote: customerNote ?? this.customerNote,
    );
  }

  @override
  String toString() {
    return 'OrderRequestModel(currency: $currency, paymentMethod: $paymentMethod, paymentMethodTitle: $paymentMethodTitle, setPaid: $setPaid, billing: $billing, shipping: $shipping, lineItems: $lineItems, customerNote: $customerNote, )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderRequestModel &&
        other.currency == currency &&
        other.paymentMethod == paymentMethod &&
        other.paymentMethodTitle == paymentMethodTitle &&
        other.setPaid == setPaid &&
        other.billing == billing &&
        other.shipping == shipping &&
        other.lineItems == lineItems &&
        other.customerNote == customerNote;
  }

  @override
  int get hashCode {
    return currency.hashCode ^
        paymentMethod.hashCode ^
        paymentMethodTitle.hashCode ^
        setPaid.hashCode ^
        billing.hashCode ^
        shipping.hashCode ^
        lineItems.hashCode ^
        customerNote.hashCode;
  }
}

class Billing {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String email;
  final String phone;

  Billing({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.email,
    required this.phone,
  });

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address1: json['address_1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address_1': address1,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'email': email,
      'phone': phone,
    };
  }

  Billing copyWith({
    String? firstName,
    String? lastName,
    String? address1,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? email,
    String? phone,
  }) {
    return Billing(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address1: address1 ?? this.address1,
      city: city ?? this.city,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'Billing(firstName: $firstName, lastName: $lastName, address1: $address1, city: $city, state: $state, postcode: $postcode, country: $country, ';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Billing &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address1 == address1 &&
        other.city == city &&
        other.state == state &&
        other.postcode == postcode &&
        other.country == country &&
    other.email == email &&
    other.phone == phone;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        address1.hashCode ^
        city.hashCode ^
        state.hashCode ^
        postcode.hashCode ^
        country.hashCode ^
        email.hashCode ^
        phone.hashCode;
  }
}

class Shipping {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String state;
  final String postcode;
  final String country;

  Shipping({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address1: json['address_1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address_1': address1,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
    };
  }

  Shipping copyWith({
    String? firstName,
    String? lastName,
    String? address1,
    String? city,
    String? state,
    String? postcode,
    String? country,
  }) {
    return Shipping(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address1: address1 ?? this.address1,
      city: city ?? this.city,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
    );
  }

  @override
  String toString() {
    return 'Shipping(firstName: $firstName, lastName: $lastName, address1: $address1, city: $city, state: $state, postcode: $postcode, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Shipping &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address1 == address1 &&
        other.city == city &&
        other.state == state &&
        other.postcode == postcode &&
        other.country == country;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        address1.hashCode ^
        city.hashCode ^
        state.hashCode ^
        postcode.hashCode ^
        country.hashCode;
  }
}

class LineItem {
  final int productId;
  final int quantity;

  LineItem({required this.productId, required this.quantity});

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }

  LineItem copyWith({int? productId, int? quantity}) {
    return LineItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'LineItem(productId: $productId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LineItem &&
        other.productId == productId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return productId.hashCode ^ quantity.hashCode;
  }
}
