class MemberModel {
  final String id;
  final String name;
  final String? title;
  final String? position;
  final String? description;
  final String? phoneNumber;
  final String? email;
  final String? imageUrl;
  final bool isImportant;
  final int orderDisplay;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MemberModel({
    required this.id,
    required this.name,
    this.title,
    this.position,
    this.description,
    this.phoneNumber,
    this.email,
    this.imageUrl,
    this.isImportant = false,
    this.orderDisplay = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String?,
      position: json['position'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      imageUrl: json['image_url'] as String?,
      isImportant: json['is_important'] as bool? ?? false,
      orderDisplay: json['order_display'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'position': position,
      'description': description,
      'phone_number': phoneNumber,
      'email': email,
      'image_url': imageUrl,
      'is_important': isImportant,
      'order_display': orderDisplay,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MemberModel copyWith({
    String? id,
    String? name,
    String? title,
    String? position,
    String? description,
    String? phoneNumber,
    String? email,
    String? imageUrl,
    bool? isImportant,
    int? orderDisplay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      position: position ?? this.position,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      isImportant: isImportant ?? this.isImportant,
      orderDisplay: orderDisplay ?? this.orderDisplay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
