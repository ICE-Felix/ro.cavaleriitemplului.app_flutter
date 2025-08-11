import 'dart:convert';

class OrderResponseModel {
  final bool success;
  final OrderData data;
  final ResponseMeta meta;

  OrderResponseModel({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json['success'] ?? false,
      data: OrderData.fromJson(json['data'] ?? {}),
      meta: ResponseMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson(), 'meta': meta.toJson()};
  }

  OrderResponseModel copyWith({
    bool? success,
    OrderData? data,
    ResponseMeta? meta,
  }) {
    return OrderResponseModel(
      success: success ?? this.success,
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }

  @override
  String toString() {
    return 'OrderResponseModel(success: $success, data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderResponseModel &&
        other.success == success &&
        other.data == data &&
        other.meta == meta;
  }

  @override
  int get hashCode {
    return success.hashCode ^ data.hashCode ^ meta.hashCode;
  }
}

class OrderData {
  final int id;
  final int parentId;
  final String status;
  final String currency;
  final String version;
  final bool pricesIncludeTax;
  final String dateCreated;
  final String dateModified;
  final String discountTotal;
  final String discountTax;
  final String shippingTotal;
  final String shippingTax;
  final String cartTax;
  final String total;
  final String totalTax;
  final int customerId;
  final String orderKey;
  final OrderBilling billing;
  final OrderShipping shipping;
  final String paymentMethod;
  final String paymentMethodTitle;
  final String transactionId;
  final String customerIpAddress;
  final String customerUserAgent;
  final String createdVia;
  final String customerNote;
  final String? dateCompleted;
  final String? datePaid;
  final String cartHash;
  final String number;
  final List<dynamic> metaData;
  final List<OrderLineItem> lineItems;
  final List<dynamic> taxLines;
  final List<dynamic> shippingLines;
  final List<dynamic> feeLines;
  final List<dynamic> couponLines;
  final List<dynamic> refunds;
  final String paymentUrl;
  final bool isEditable;
  final bool needsPayment;
  final bool needsProcessing;
  final String dateCreatedGmt;
  final String dateModifiedGmt;
  final String? dateCompletedGmt;
  final String? datePaidGmt;
  final String currencySymbol;
  final OrderLinks links;

  OrderData({
    required this.id,
    required this.parentId,
    required this.status,
    required this.currency,
    required this.version,
    required this.pricesIncludeTax,
    required this.dateCreated,
    required this.dateModified,
    required this.discountTotal,
    required this.discountTax,
    required this.shippingTotal,
    required this.shippingTax,
    required this.cartTax,
    required this.total,
    required this.totalTax,
    required this.customerId,
    required this.orderKey,
    required this.billing,
    required this.shipping,
    required this.paymentMethod,
    required this.paymentMethodTitle,
    required this.transactionId,
    required this.customerIpAddress,
    required this.customerUserAgent,
    required this.createdVia,
    required this.customerNote,
    this.dateCompleted,
    this.datePaid,
    required this.cartHash,
    required this.number,
    required this.metaData,
    required this.lineItems,
    required this.taxLines,
    required this.shippingLines,
    required this.feeLines,
    required this.couponLines,
    required this.refunds,
    required this.paymentUrl,
    required this.isEditable,
    required this.needsPayment,
    required this.needsProcessing,
    required this.dateCreatedGmt,
    required this.dateModifiedGmt,
    this.dateCompletedGmt,
    this.datePaidGmt,
    required this.currencySymbol,
    required this.links,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      status: json['status'] ?? '',
      currency: json['currency'] ?? '',
      version: json['version'] ?? '',
      pricesIncludeTax: json['prices_include_tax'] ?? false,
      dateCreated: json['date_created'] ?? '',
      dateModified: json['date_modified'] ?? '',
      discountTotal: json['discount_total'] ?? '',
      discountTax: json['discount_tax'] ?? '',
      shippingTotal: json['shipping_total'] ?? '',
      shippingTax: json['shipping_tax'] ?? '',
      cartTax: json['cart_tax'] ?? '',
      total: json['total'] ?? '',
      totalTax: json['total_tax'] ?? '',
      customerId: json['customer_id'] ?? 0,
      orderKey: json['order_key'] ?? '',
      billing: OrderBilling.fromJson(json['billing'] ?? {}),
      shipping: OrderShipping.fromJson(json['shipping'] ?? {}),
      paymentMethod: json['payment_method'] ?? '',
      paymentMethodTitle: json['payment_method_title'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      customerIpAddress: json['customer_ip_address'] ?? '',
      customerUserAgent: json['customer_user_agent'] ?? '',
      createdVia: json['created_via'] ?? '',
      customerNote: json['customer_note'] ?? '',
      dateCompleted: json['date_completed'],
      datePaid: json['date_paid'],
      cartHash: json['cart_hash'] ?? '',
      number: json['number'] ?? '',
      metaData: json['meta_data'] ?? [],
      lineItems:
          (json['line_items'] as List<dynamic>?)
              ?.map((item) => OrderLineItem.fromJson(item))
              .toList() ??
          [],
      taxLines: json['tax_lines'] ?? [],
      shippingLines: json['shipping_lines'] ?? [],
      feeLines: json['fee_lines'] ?? [],
      couponLines: json['coupon_lines'] ?? [],
      refunds: json['refunds'] ?? [],
      paymentUrl: json['payment_url'] ?? '',
      isEditable: json['is_editable'] ?? false,
      needsPayment: json['needs_payment'] ?? false,
      needsProcessing: json['needs_processing'] ?? false,
      dateCreatedGmt: json['date_created_gmt'] ?? '',
      dateModifiedGmt: json['date_modified_gmt'] ?? '',
      dateCompletedGmt: json['date_completed_gmt'],
      datePaidGmt: json['date_paid_gmt'],
      currencySymbol: json['currency_symbol'] ?? '',
      links: OrderLinks.fromJson(json['_links'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'status': status,
      'currency': currency,
      'version': version,
      'prices_include_tax': pricesIncludeTax,
      'date_created': dateCreated,
      'date_modified': dateModified,
      'discount_total': discountTotal,
      'discount_tax': discountTax,
      'shipping_total': shippingTotal,
      'shipping_tax': shippingTax,
      'cart_tax': cartTax,
      'total': total,
      'total_tax': totalTax,
      'customer_id': customerId,
      'order_key': orderKey,
      'billing': billing.toJson(),
      'shipping': shipping.toJson(),
      'payment_method': paymentMethod,
      'payment_method_title': paymentMethodTitle,
      'transaction_id': transactionId,
      'customer_ip_address': customerIpAddress,
      'customer_user_agent': customerUserAgent,
      'created_via': createdVia,
      'customer_note': customerNote,
      'date_completed': dateCompleted,
      'date_paid': datePaid,
      'cart_hash': cartHash,
      'number': number,
      'meta_data': metaData,
      'line_items': lineItems.map((item) => item.toJson()).toList(),
      'tax_lines': taxLines,
      'shipping_lines': shippingLines,
      'fee_lines': feeLines,
      'coupon_lines': couponLines,
      'refunds': refunds,
      'payment_url': paymentUrl,
      'is_editable': isEditable,
      'needs_payment': needsPayment,
      'needs_processing': needsProcessing,
      'date_created_gmt': dateCreatedGmt,
      'date_modified_gmt': dateModifiedGmt,
      'date_completed_gmt': dateCompletedGmt,
      'date_paid_gmt': datePaidGmt,
      'currency_symbol': currencySymbol,
      '_links': links.toJson(),
    };
  }

  OrderData copyWith({
    int? id,
    int? parentId,
    String? status,
    String? currency,
    String? version,
    bool? pricesIncludeTax,
    String? dateCreated,
    String? dateModified,
    String? discountTotal,
    String? discountTax,
    String? shippingTotal,
    String? shippingTax,
    String? cartTax,
    String? total,
    String? totalTax,
    int? customerId,
    String? orderKey,
    OrderBilling? billing,
    OrderShipping? shipping,
    String? paymentMethod,
    String? paymentMethodTitle,
    String? transactionId,
    String? customerIpAddress,
    String? customerUserAgent,
    String? createdVia,
    String? customerNote,
    String? dateCompleted,
    String? datePaid,
    String? cartHash,
    String? number,
    List<dynamic>? metaData,
    List<OrderLineItem>? lineItems,
    List<dynamic>? taxLines,
    List<dynamic>? shippingLines,
    List<dynamic>? feeLines,
    List<dynamic>? couponLines,
    List<dynamic>? refunds,
    String? paymentUrl,
    bool? isEditable,
    bool? needsPayment,
    bool? needsProcessing,
    String? dateCreatedGmt,
    String? dateModifiedGmt,
    String? dateCompletedGmt,
    String? datePaidGmt,
    String? currencySymbol,
    OrderLinks? links,
  }) {
    return OrderData(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      version: version ?? this.version,
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      discountTotal: discountTotal ?? this.discountTotal,
      discountTax: discountTax ?? this.discountTax,
      shippingTotal: shippingTotal ?? this.shippingTotal,
      shippingTax: shippingTax ?? this.shippingTax,
      cartTax: cartTax ?? this.cartTax,
      total: total ?? this.total,
      totalTax: totalTax ?? this.totalTax,
      customerId: customerId ?? this.customerId,
      orderKey: orderKey ?? this.orderKey,
      billing: billing ?? this.billing,
      shipping: shipping ?? this.shipping,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodTitle: paymentMethodTitle ?? this.paymentMethodTitle,
      transactionId: transactionId ?? this.transactionId,
      customerIpAddress: customerIpAddress ?? this.customerIpAddress,
      customerUserAgent: customerUserAgent ?? this.customerUserAgent,
      createdVia: createdVia ?? this.createdVia,
      customerNote: customerNote ?? this.customerNote,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      datePaid: datePaid ?? this.datePaid,
      cartHash: cartHash ?? this.cartHash,
      number: number ?? this.number,
      metaData: metaData ?? this.metaData,
      lineItems: lineItems ?? this.lineItems,
      taxLines: taxLines ?? this.taxLines,
      shippingLines: shippingLines ?? this.shippingLines,
      feeLines: feeLines ?? this.feeLines,
      couponLines: couponLines ?? this.couponLines,
      refunds: refunds ?? this.refunds,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      isEditable: isEditable ?? this.isEditable,
      needsPayment: needsPayment ?? this.needsPayment,
      needsProcessing: needsProcessing ?? this.needsProcessing,
      dateCreatedGmt: dateCreatedGmt ?? this.dateCreatedGmt,
      dateModifiedGmt: dateModifiedGmt ?? this.dateModifiedGmt,
      dateCompletedGmt: dateCompletedGmt ?? this.dateCompletedGmt,
      datePaidGmt: datePaidGmt ?? this.datePaidGmt,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      links: links ?? this.links,
    );
  }

  @override
  String toString() {
    return 'OrderData(id: $id, parentId: $parentId, status: $status, currency: $currency, version: $version, pricesIncludeTax: $pricesIncludeTax, dateCreated: $dateCreated, dateModified: $dateModified, discountTotal: $discountTotal, discountTax: $discountTax, shippingTotal: $shippingTotal, shippingTax: $shippingTax, cartTax: $cartTax, total: $total, totalTax: $totalTax, customerId: $customerId, orderKey: $orderKey, billing: $billing, shipping: $shipping, paymentMethod: $paymentMethod, paymentMethodTitle: $paymentMethodTitle, transactionId: $transactionId, customerIpAddress: $customerIpAddress, customerUserAgent: $customerUserAgent, createdVia: $createdVia, customerNote: $customerNote, dateCompleted: $dateCompleted, datePaid: $datePaid, cartHash: $cartHash, number: $number, metaData: $metaData, lineItems: $lineItems, taxLines: $taxLines, shippingLines: $shippingLines, feeLines: $feeLines, couponLines: $couponLines, refunds: $refunds, paymentUrl: $paymentUrl, isEditable: $isEditable, needsPayment: $needsPayment, needsProcessing: $needsProcessing, dateCreatedGmt: $dateCreatedGmt, dateModifiedGmt: $dateModifiedGmt, dateCompletedGmt: $dateCompletedGmt, datePaidGmt: $datePaidGmt, currencySymbol: $currencySymbol, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderData &&
        other.id == id &&
        other.parentId == parentId &&
        other.status == status &&
        other.currency == currency &&
        other.version == version &&
        other.pricesIncludeTax == pricesIncludeTax &&
        other.dateCreated == dateCreated &&
        other.dateModified == dateModified &&
        other.discountTotal == discountTotal &&
        other.discountTax == discountTax &&
        other.shippingTotal == shippingTotal &&
        other.shippingTax == shippingTax &&
        other.cartTax == cartTax &&
        other.total == total &&
        other.totalTax == totalTax &&
        other.customerId == customerId &&
        other.orderKey == orderKey &&
        other.billing == billing &&
        other.shipping == shipping &&
        other.paymentMethod == paymentMethod &&
        other.paymentMethodTitle == paymentMethodTitle &&
        other.transactionId == transactionId &&
        other.customerIpAddress == customerIpAddress &&
        other.customerUserAgent == customerUserAgent &&
        other.createdVia == createdVia &&
        other.customerNote == customerNote &&
        other.dateCompleted == dateCompleted &&
        other.datePaid == datePaid &&
        other.cartHash == cartHash &&
        other.number == number &&
        other.metaData == metaData &&
        other.lineItems == lineItems &&
        other.taxLines == taxLines &&
        other.shippingLines == shippingLines &&
        other.feeLines == feeLines &&
        other.couponLines == couponLines &&
        other.refunds == refunds &&
        other.paymentUrl == paymentUrl &&
        other.isEditable == isEditable &&
        other.needsPayment == needsPayment &&
        other.needsProcessing == needsProcessing &&
        other.dateCreatedGmt == dateCreatedGmt &&
        other.dateModifiedGmt == dateModifiedGmt &&
        other.dateCompletedGmt == dateCompletedGmt &&
        other.datePaidGmt == datePaidGmt &&
        other.currencySymbol == currencySymbol &&
        other.links == links;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        parentId.hashCode ^
        status.hashCode ^
        currency.hashCode ^
        version.hashCode ^
        pricesIncludeTax.hashCode ^
        dateCreated.hashCode ^
        dateModified.hashCode ^
        discountTotal.hashCode ^
        discountTax.hashCode ^
        shippingTotal.hashCode ^
        shippingTax.hashCode ^
        cartTax.hashCode ^
        total.hashCode ^
        totalTax.hashCode ^
        customerId.hashCode ^
        orderKey.hashCode ^
        billing.hashCode ^
        shipping.hashCode ^
        paymentMethod.hashCode ^
        paymentMethodTitle.hashCode ^
        transactionId.hashCode ^
        customerIpAddress.hashCode ^
        customerUserAgent.hashCode ^
        createdVia.hashCode ^
        customerNote.hashCode ^
        dateCompleted.hashCode ^
        datePaid.hashCode ^
        cartHash.hashCode ^
        number.hashCode ^
        metaData.hashCode ^
        lineItems.hashCode ^
        taxLines.hashCode ^
        shippingLines.hashCode ^
        feeLines.hashCode ^
        couponLines.hashCode ^
        refunds.hashCode ^
        paymentUrl.hashCode ^
        isEditable.hashCode ^
        needsPayment.hashCode ^
        needsProcessing.hashCode ^
        dateCreatedGmt.hashCode ^
        dateModifiedGmt.hashCode ^
        dateCompletedGmt.hashCode ^
        datePaidGmt.hashCode ^
        currencySymbol.hashCode ^
        links.hashCode;
  }
}

class OrderBilling {
  final String firstName;
  final String lastName;
  final String company;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String email;
  final String phone;

  OrderBilling({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.email,
    required this.phone,
  });

  factory OrderBilling.fromJson(Map<String, dynamic> json) {
    return OrderBilling(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      company: json['company'] ?? '',
      address1: json['address_1'] ?? '',
      address2: json['address_2'] ?? '',
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
      'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'email': email,
      'phone': phone,
    };
  }

  OrderBilling copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? email,
    String? phone,
  }) {
    return OrderBilling(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
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
    return 'OrderBilling(firstName: $firstName, lastName: $lastName, company: $company, address1: $address1, address2: $address2, city: $city, state: $state, postcode: $postcode, country: $country, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderBilling &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.company == company &&
        other.address1 == address1 &&
        other.address2 == address2 &&
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
        company.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        city.hashCode ^
        state.hashCode ^
        postcode.hashCode ^
        country.hashCode ^
        email.hashCode ^
        phone.hashCode;
  }
}

class OrderShipping {
  final String firstName;
  final String lastName;
  final String company;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String phone;

  OrderShipping({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.phone,
  });

  factory OrderShipping.fromJson(Map<String, dynamic> json) {
    return OrderShipping(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      company: json['company'] ?? '',
      address1: json['address_1'] ?? '',
      address2: json['address_2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'phone': phone,
    };
  }

  OrderShipping copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? phone,
  }) {
    return OrderShipping(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'OrderShipping(firstName: $firstName, lastName: $lastName, company: $company, address1: $address1, address2: $address2, city: $city, state: $state, postcode: $postcode, country: $country, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderShipping &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.company == company &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.city == city &&
        other.state == state &&
        other.postcode == postcode &&
        other.country == country &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        company.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        city.hashCode ^
        state.hashCode ^
        postcode.hashCode ^
        country.hashCode ^
        phone.hashCode;
  }
}

class OrderLineItem {
  final int id;
  final String name;
  final int productId;
  final int variationId;
  final int quantity;
  final String taxClass;
  final String subtotal;
  final String subtotalTax;
  final String total;
  final String totalTax;
  final List<dynamic> taxes;
  final List<dynamic> metaData;
  final String? sku;
  final num price;
  final ProductImage image;
  final String? parentName;

  OrderLineItem({
    required this.id,
    required this.name,
    required this.productId,
    required this.variationId,
    required this.quantity,
    required this.taxClass,
    required this.subtotal,
    required this.subtotalTax,
    required this.total,
    required this.totalTax,
    required this.taxes,
    required this.metaData,
    this.sku,
    required this.price,
    required this.image,
    this.parentName,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      productId: json['product_id'] ?? 0,
      variationId: json['variation_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      taxClass: json['tax_class'] ?? '',
      subtotal: json['subtotal'] ?? '',
      subtotalTax: json['subtotal_tax'] ?? '',
      total: json['total'] ?? '',
      totalTax: json['total_tax'] ?? '',
      taxes: json['taxes'] ?? [],
      metaData: json['meta_data'] ?? [],
      sku: json['sku'],
      price: json['price'] ?? 0,
      image: ProductImage.fromJson(json['image'] ?? {}),
      parentName: json['parent_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'product_id': productId,
      'variation_id': variationId,
      'quantity': quantity,
      'tax_class': taxClass,
      'subtotal': subtotal,
      'subtotal_tax': subtotalTax,
      'total': total,
      'total_tax': totalTax,
      'taxes': taxes,
      'meta_data': metaData,
      'sku': sku,
      'price': price,
      'image': image.toJson(),
      'parent_name': parentName,
    };
  }

  OrderLineItem copyWith({
    int? id,
    String? name,
    int? productId,
    int? variationId,
    int? quantity,
    String? taxClass,
    String? subtotal,
    String? subtotalTax,
    String? total,
    String? totalTax,
    List<dynamic>? taxes,
    List<dynamic>? metaData,
    String? sku,
    int? price,
    ProductImage? image,
    String? parentName,
  }) {
    return OrderLineItem(
      id: id ?? this.id,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      variationId: variationId ?? this.variationId,
      quantity: quantity ?? this.quantity,
      taxClass: taxClass ?? this.taxClass,
      subtotal: subtotal ?? this.subtotal,
      subtotalTax: subtotalTax ?? this.subtotalTax,
      total: total ?? this.total,
      totalTax: totalTax ?? this.totalTax,
      taxes: taxes ?? this.taxes,
      metaData: metaData ?? this.metaData,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      image: image ?? this.image,
      parentName: parentName ?? this.parentName,
    );
  }

  @override
  String toString() {
    return 'OrderLineItem(id: $id, name: $name, productId: $productId, variationId: $variationId, quantity: $quantity, taxClass: $taxClass, subtotal: $subtotal, subtotalTax: $subtotalTax, total: $total, totalTax: $totalTax, taxes: $taxes, metaData: $metaData, sku: $sku, price: $price, image: $image, parentName: $parentName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderLineItem &&
        other.id == id &&
        other.name == name &&
        other.productId == productId &&
        other.variationId == variationId &&
        other.quantity == quantity &&
        other.taxClass == taxClass &&
        other.subtotal == subtotal &&
        other.subtotalTax == subtotalTax &&
        other.total == total &&
        other.totalTax == totalTax &&
        other.taxes == taxes &&
        other.metaData == metaData &&
        other.sku == sku &&
        other.price == price &&
        other.image == image &&
        other.parentName == parentName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        productId.hashCode ^
        variationId.hashCode ^
        quantity.hashCode ^
        taxClass.hashCode ^
        subtotal.hashCode ^
        subtotalTax.hashCode ^
        total.hashCode ^
        totalTax.hashCode ^
        taxes.hashCode ^
        metaData.hashCode ^
        sku.hashCode ^
        price.hashCode ^
        image.hashCode ^
        parentName.hashCode;
  }
}

class ProductImage {
  final String id;
  final String src;

  ProductImage({required this.id, required this.src});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(id: json['id'] ?? 0, src: json['src'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'src': src};
  }

  ProductImage copyWith({String? id, String? src}) {
    return ProductImage(id: id ?? this.id, src: src ?? this.src);
  }

  @override
  String toString() {
    return 'ProductImage(id: $id, src: $src)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductImage && other.id == id && other.src == src;
  }

  @override
  int get hashCode {
    return id.hashCode ^ src.hashCode;
  }
}

class OrderLinks {
  final List<LinkItem> self;
  final List<LinkItem> collection;
  final List<LinkItem> emailTemplates;

  OrderLinks({
    required this.self,
    required this.collection,
    required this.emailTemplates,
  });

  factory OrderLinks.fromJson(Map<String, dynamic> json) {
    return OrderLinks(
      self:
          (json['self'] as List<dynamic>?)
              ?.map((item) => LinkItem.fromJson(item))
              .toList() ??
          [],
      collection:
          (json['collection'] as List<dynamic>?)
              ?.map((item) => LinkItem.fromJson(item))
              .toList() ??
          [],
      emailTemplates:
          (json['email_templates'] as List<dynamic>?)
              ?.map((item) => LinkItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self': self.map((item) => item.toJson()).toList(),
      'collection': collection.map((item) => item.toJson()).toList(),
      'email_templates': emailTemplates.map((item) => item.toJson()).toList(),
    };
  }

  OrderLinks copyWith({
    List<LinkItem>? self,
    List<LinkItem>? collection,
    List<LinkItem>? emailTemplates,
  }) {
    return OrderLinks(
      self: self ?? this.self,
      collection: collection ?? this.collection,
      emailTemplates: emailTemplates ?? this.emailTemplates,
    );
  }

  @override
  String toString() {
    return 'OrderLinks(self: $self, collection: $collection, emailTemplates: $emailTemplates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderLinks &&
        other.self == self &&
        other.collection == collection &&
        other.emailTemplates == emailTemplates;
  }

  @override
  int get hashCode {
    return self.hashCode ^ collection.hashCode ^ emailTemplates.hashCode;
  }
}

class LinkItem {
  final String href;
  final TargetHints? targetHints;
  final bool? embeddable;

  LinkItem({required this.href, this.targetHints, this.embeddable});

  factory LinkItem.fromJson(Map<String, dynamic> json) {
    return LinkItem(
      href: json['href'] ?? '',
      targetHints:
          json['targetHints'] != null
              ? TargetHints.fromJson(json['targetHints'])
              : null,
      embeddable: json['embeddable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'targetHints': targetHints?.toJson(),
      'embeddable': embeddable,
    };
  }

  LinkItem copyWith({
    String? href,
    TargetHints? targetHints,
    bool? embeddable,
  }) {
    return LinkItem(
      href: href ?? this.href,
      targetHints: targetHints ?? this.targetHints,
      embeddable: embeddable ?? this.embeddable,
    );
  }

  @override
  String toString() {
    return 'LinkItem(href: $href, targetHints: $targetHints, embeddable: $embeddable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LinkItem &&
        other.href == href &&
        other.targetHints == targetHints &&
        other.embeddable == embeddable;
  }

  @override
  int get hashCode {
    return href.hashCode ^ targetHints.hashCode ^ embeddable.hashCode;
  }
}

class TargetHints {
  final List<String> allow;

  TargetHints({required this.allow});

  factory TargetHints.fromJson(Map<String, dynamic> json) {
    return TargetHints(
      allow:
          (json['allow'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'allow': allow};
  }

  TargetHints copyWith({List<String>? allow}) {
    return TargetHints(allow: allow ?? this.allow);
  }

  @override
  String toString() {
    return 'TargetHints(allow: $allow)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TargetHints && other.allow == allow;
  }

  @override
  int get hashCode {
    return allow.hashCode;
  }
}

class ResponseMeta {
  final String message;

  ResponseMeta({required this.message});

  factory ResponseMeta.fromJson(Map<String, dynamic> json) {
    return ResponseMeta(message: json['message'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }

  ResponseMeta copyWith({String? message}) {
    return ResponseMeta(message: message ?? this.message);
  }

  @override
  String toString() {
    return 'ResponseMeta(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResponseMeta && other.message == message;
  }

  @override
  int get hashCode {
    return message.hashCode;
  }
}
