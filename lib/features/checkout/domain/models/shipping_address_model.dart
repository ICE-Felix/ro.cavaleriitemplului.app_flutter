import 'package:equatable/equatable.dart';

class ShippingAddressModel extends Equatable {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String email;
  final String phone;

  const ShippingAddressModel({
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

  factory ShippingAddressModel.empty() {
    return const ShippingAddressModel(
      firstName: '',
      lastName: '',
      address1: '',
      city: '',
      state: '',
      postcode: '',
      country: 'Romania',
      email: '',
      phone: '',
    );
  }

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address1: json['address_1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? 'Romania',
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

  ShippingAddressModel copyWith({
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
    return ShippingAddressModel(
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

  bool get isComplete {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        address1.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        postcode.isNotEmpty &&
        country.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty;
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    address1,
    city,
    state,
    postcode,
    country,
    email,
    phone,
  ];
}
