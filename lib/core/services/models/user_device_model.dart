enum DeviceType {
  android('Android'),
  ios('iOS'),
  desktop('Desktop'),
  web('Web'),
  unknown('Unknown');

  const DeviceType(this.value);
  final String value;

  static DeviceType fromString(String value) {
    return DeviceType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => DeviceType.unknown,
    );
  }
}

class UserDeviceModel {
  final String deviceId; // Now the primary key
  final String userId;
  final String fcmToken;
  final String? model;
  final DeviceType deviceType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserDeviceModel({
    required this.deviceId,
    required this.userId,
    required this.fcmToken,
    this.model,
    required this.deviceType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDeviceModel.fromJson(Map<String, dynamic> json) {
    return UserDeviceModel(
      deviceId: json['device_id'] as String,
      userId: json['user_id'] as String,
      fcmToken: json['fcm_token'] as String,
      model: json['model'] as String?,
      deviceType:
          json['device_type'] != null
              ? DeviceType.fromString(json['device_type'] as String)
              : DeviceType.unknown,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'user_id': userId,
      'fcm_token': fcmToken,
      if (model != null) 'model': model,
      'device_type': deviceType.value,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  UserDeviceModel copyWith({
    String? deviceId,
    String? userId,
    String? fcmToken,
    String? model,
    DeviceType? deviceType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserDeviceModel(
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      fcmToken: fcmToken ?? this.fcmToken,
      model: model ?? this.model,
      deviceType: deviceType ?? this.deviceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserDeviceModel &&
        other.deviceId == deviceId &&
        other.userId == userId &&
        other.fcmToken == fcmToken &&
        other.model == model &&
        other.deviceType == deviceType &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return deviceId.hashCode ^
        userId.hashCode ^
        fcmToken.hashCode ^
        model.hashCode ^
        deviceType.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'UserDeviceModel(deviceId: $deviceId, userId: $userId, fcmToken: $fcmToken, model: $model, deviceType: $deviceType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
