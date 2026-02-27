import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.targetType,
    super.targetUserId,
    super.data,
    required super.createdAt,
    super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // notification_reads is a left-joined array; non-empty means read
    final reads = json['notification_reads'];
    final bool isRead;
    if (reads is List) {
      isRead = reads.isNotEmpty;
    } else {
      isRead = false;
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      targetType: json['target_type'] ?? 'global',
      targetUserId: json['target_user_id'],
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : const {},
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isRead: isRead,
    );
  }
}
