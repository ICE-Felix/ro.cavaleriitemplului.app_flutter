import 'package:equatable/equatable.dart';

class SupportRequestModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final SupportCategory category;
  final DateTime createdAt;

  const SupportRequestModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SupportRequestModel.fromJson(Map<String, dynamic> json) {
    return SupportRequestModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      category: SupportCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => SupportCategory.general,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, email, subject, message, category, createdAt];
}

enum SupportCategory {
  general,
  technical,
  membership,
  events,
  other,
}

extension SupportCategoryExtension on SupportCategory {
  String get displayName {
    switch (this) {
      case SupportCategory.general:
        return 'General';
      case SupportCategory.technical:
        return 'Probleme Tehnice';
      case SupportCategory.membership:
        return 'Membru';
      case SupportCategory.events:
        return 'Evenimente';
      case SupportCategory.other:
        return 'Altele';
    }
  }
}
