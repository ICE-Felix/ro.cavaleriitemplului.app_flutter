import 'package:equatable/equatable.dart';

enum PaymentMethodType { netopia, cash }

class PaymentMethodModel extends Equatable {
  final PaymentMethodType type;
  final String id;
  final String name;
  final String description;
  final bool isEnabled;

  const PaymentMethodModel({
    required this.type,
    required this.id,
    required this.name,
    required this.description,
    this.isEnabled = true,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PaymentMethodType.cash,
      ),
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isEnabled: json['is_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'id': id,
      'name': name,
      'description': description,
      'is_enabled': isEnabled,
    };
  }

  PaymentMethodModel copyWith({
    PaymentMethodType? type,
    String? id,
    String? name,
    String? description,
    bool? isEnabled,
  }) {
    return PaymentMethodModel(
      type: type ?? this.type,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  static List<PaymentMethodModel> getDefaultPaymentMethods() {
    return [
      const PaymentMethodModel(
        type: PaymentMethodType.netopia,
        id: 'netopia',
        name: 'Netopia',
        description: 'Pay with Netopia',
      ),
      const PaymentMethodModel(
        type: PaymentMethodType.cash,
        id: 'cash',
        name: 'Cash',
        description: 'Pay with cash',
      ),
    ];
  }

  @override
  List<Object?> get props => [type, id, name, description, isEnabled];
}
