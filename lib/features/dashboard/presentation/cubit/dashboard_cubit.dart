import 'package:app/core/network/supabase_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  supabase_flutter.SupabaseClient get _client => SupabaseClient().client;

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true));

    try {
      // Load all in parallel
      final results = await Future.wait([
        _loadUserName(),
        _loadNextEvent(),
        _loadLatestNews(),
        _loadDashboardCards(),
        _loadHomepageSettings(),
      ]);

      if (isClosed) return;

      final cards = results[3] as List<DashboardCardData>;
      final settings = results[4] as Map<String, String>;

      // Sort large cards in fixed order: Noutăți, Program, Revista, Istoric
      const cardOrder = ['news', 'events', 'revista', 'istoric'];
      int cardPriority(DashboardCardData c) {
        final route = c.route.replaceAll('/', '');
        // Check dynamicSource first, then route
        if (c.dynamicSource == 'news' || route == 'news') return 0;
        if (c.dynamicSource == 'events' || route == 'events') return 1;
        if (route == 'revistas' || route == 'revista') return 2;
        if (route == 'history' || route == 'istoric') return 3;
        return 4 + cardOrder.length;
      }
      final largeCards = cards.where((c) => c.cardType == 'large').toList()
        ..sort((a, b) => cardPriority(a).compareTo(cardPriority(b)));

      emit(state.copyWith(
        isLoading: false,
        userName: results[0] as String,
        nextEventTitle: (results[1] as Map<String, String>)['title'],
        nextEventDate: (results[1] as Map<String, String>)['date'],
        nextEventTime: (results[1] as Map<String, String>)['time'],
        nextEventLabel: (results[1] as Map<String, String>)['label'],
        latestNewsId: (results[2] as Map<String, String>)['id'],
        latestNewsTitle: (results[2] as Map<String, String>)['title'],
        latestNewsTime: (results[2] as Map<String, String>)['time'],
        largeCards: largeCards,
        smallCards: cards.where((c) => c.cardType == 'small').toList(),
        settings: settings,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<List<DashboardCardData>> _loadDashboardCards() async {
    try {
      final data = await _client
          .from('dashboard_cards')
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      return (data as List)
          .map((json) => DashboardCardData.fromJson(json))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, String>> _loadHomepageSettings() async {
    try {
      final data = await _client
          .from('homepage_settings')
          .select('key, value');

      final map = <String, String>{};
      for (final row in (data as List)) {
        map[row['key'] as String] = row['value'] as String;
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  Future<String> _loadUserName() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return '';

      // Try to get display name from user metadata
      final meta = user.userMetadata;
      if (meta != null) {
        final name = meta['display_name'] ?? meta['full_name'] ?? meta['name'];
        if (name != null && name.toString().isNotEmpty) return name.toString();
      }

      // Fallback to email prefix
      final email = user.email ?? '';
      if (email.isNotEmpty) {
        final prefix = email.split('@').first;
        return prefix[0].toUpperCase() + prefix.substring(1);
      }

      return '';
    } catch (_) {
      return '';
    }
  }

  Future<Map<String, String>> _loadNextEvent() async {
    try {
      final now = DateTime.now();
      final todayStart = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00';
      final todayEnd = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T23:59:59';

      final months = [
        '', 'ianuarie', 'februarie', 'martie', 'aprilie', 'mai', 'iunie',
        'iulie', 'august', 'septembrie', 'octombrie', 'noiembrie', 'decembrie'
      ];

      // First check for events today
      final todayData = await _client
          .from('events')
          .select('title, start_time')
          .isFilter('deleted_at', null)
          .gte('start_time', todayStart)
          .lte('start_time', todayEnd)
          .order('start_time', ascending: true)
          .limit(1);

      if ((todayData as List).isNotEmpty) {
        final event = todayData[0];
        final startTime = DateTime.parse(event['start_time']);
        final dateStr = '${startTime.day} ${months[startTime.month]}';
        final timeStr = 'ora ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
        return {
          'title': event['title'] ?? '',
          'date': dateStr,
          'time': timeStr,
          'label': '',
        };
      }

      // No events today - get next future event
      final futureData = await _client
          .from('events')
          .select('title, start_time')
          .isFilter('deleted_at', null)
          .gt('start_time', todayEnd)
          .order('start_time', ascending: true)
          .limit(1);

      if ((futureData as List).isNotEmpty) {
        final event = futureData[0];
        final startTime = DateTime.parse(event['start_time']);
        final dateStr = '${startTime.day} ${months[startTime.month]}';
        final timeStr = 'ora ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
        return {
          'title': event['title'] ?? '',
          'date': dateStr,
          'time': timeStr,
          'label': 'Următorul eveniment',
        };
      }
    } catch (_) {}
    return {'title': '', 'date': '', 'time': '', 'label': ''};
  }

  Future<Map<String, String>> _loadLatestNews() async {
    try {
      final data = await _client
          .from('news')
          .select('id, title, created_at')
          .order('created_at', ascending: false)
          .limit(1);

      if ((data as List).isNotEmpty) {
        final news = data[0];
        final createdAt = DateTime.parse(news['created_at']);
        final timeAgo = _formatTimeAgo(createdAt);
        return {
          'id': news['id'] ?? '',
          'title': news['title'] ?? '',
          'time': timeAgo,
        };
      }
    } catch (e) {
      print('Dashboard: Failed to load latest news: $e');
    }
    return {'id': '', 'title': '', 'time': ''};
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Postat chiar acum';
    if (diff.inMinutes < 60) return 'Postat acum ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Postat acum ${diff.inHours} ore';
    if (diff.inDays < 7) return 'Postat acum ${diff.inDays} zile';
    if (diff.inDays < 30) return 'Postat acum ${(diff.inDays / 7).floor()} săpt.';
    return 'Postat acum ${(diff.inDays / 30).floor()} luni';
  }
}
