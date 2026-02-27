import 'package:app/core/network/supabase_client.dart';

/// Global singleton that caches homepage_settings from Supabase.
/// Loaded once at app startup via [initialize].
class AppSettingsService {
  AppSettingsService._();
  static final AppSettingsService instance = AppSettingsService._();

  final Map<String, String> _settings = {};

  /// Fetch all rows from homepage_settings once.
  Future<void> initialize() async {
    try {
      final client = SupabaseClient().client;
      final data = await client
          .from('homepage_settings')
          .select('key, value');

      for (final row in (data as List)) {
        _settings[row['key'] as String] = row['value'] as String;
      }
    } catch (_) {
      // Silently fail – hardcoded fallbacks will be used.
    }
  }

  /// Return the value for [key], or [fallback] if missing.
  String get(String key, [String fallback = '']) =>
      _settings[key] ?? fallback;

  /// Convenience getter for the app name shown in app bars.
  String get appName => get('appbar_title', 'R.L. 126 C.T.');
}
