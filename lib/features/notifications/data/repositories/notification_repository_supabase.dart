import 'package:app/core/network/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositorySupabase implements NotificationRepository {
  supabase_flutter.SupabaseClient get _client => SupabaseClient().client;

  @override
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final from = (page - 1) * limit;
    final to = from + limit - 1;
    final userId = _client.auth.currentUser?.id;

    final data = await _client
        .from('notifications')
        .select('*, notification_reads!left(id)')
        .or('target_type.eq.global,target_user_id.eq.$userId')
        .order('created_at', ascending: false)
        .range(from, to);

    return (data as List)
        .map((json) => NotificationModel.fromJson(json))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final result = await _client.rpc('get_unread_notification_count');
    return (result as int?) ?? 0;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('notification_reads').upsert({
      'notification_id': notificationId,
      'user_id': userId,
    }, onConflict: 'notification_id,user_id');
  }

  @override
  Future<void> markAllAsRead() async {
    final userId = _client.auth.currentUser!.id;

    // Get all unread notification IDs
    final notifications = await _client
        .from('notifications')
        .select('id')
        .or('target_type.eq.global,target_user_id.eq.$userId');

    final notificationIds =
        (notifications as List).map((n) => n['id'] as String).toList();

    if (notificationIds.isEmpty) return;

    // Insert reads for all, ignoring conflicts
    final reads = notificationIds
        .map((id) => {'notification_id': id, 'user_id': userId})
        .toList();

    await _client
        .from('notification_reads')
        .upsert(reads, onConflict: 'notification_id,user_id');
  }
}
