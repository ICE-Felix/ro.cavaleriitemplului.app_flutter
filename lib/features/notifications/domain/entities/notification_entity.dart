import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String targetType;
  final String? targetUserId;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.targetType,
    this.targetUserId,
    this.data = const {},
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    targetType,
    targetUserId,
    data,
    createdAt,
    isRead,
  ];
}
