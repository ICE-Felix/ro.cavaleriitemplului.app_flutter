import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  static const String _localeKey = 'selected_locale';
  static const String _defaultLocale = 'ro';

  LocalizationCubit() : super(LocalizationInitial());

  /// Initialize localization with saved locale or default to Romanian
  Future<void> initializeLocalization() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey) ?? _defaultLocale;
      await loadStrings(locale: savedLocale);
    } catch (e) {
      // If there's an error loading from preferences, use default
      await loadStrings(locale: _defaultLocale);
    }
  }

  /// Load strings for a specific locale
  Future<void> loadStrings({required String locale}) async {
    try {
      emit(LocalizationLoading());

      final String jsonString = await rootBundle.loadString(
        'assets/l10n/$locale.json',
      );
      final Map<String, dynamic> strings = json.decode(jsonString);

      emit(LocalizationLoaded(strings: strings, currentLocale: locale));
    } catch (e) {
      emit(
        LocalizationError(message: 'Failed to load localization strings: $e'),
      );
    }
  }

  /// Change locale and save to SharedPreferences
  Future<void> changeLocale(String newLocale) async {
    try {
      emit(LocalizationLoading());

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale);

      // Load new strings
      await loadStrings(locale: newLocale);
    } catch (e) {
      emit(LocalizationError(message: 'Failed to change locale: $e'));
    }
  }

  /// Get current locale
  String get currentLocale {
    if (state is LocalizationLoaded) {
      return (state as LocalizationLoaded).currentLocale;
    }
    return _defaultLocale;
  }

  String getString({
    required String label,
    num? variable,
    List<String>? parameters,
    Map<String, dynamic>? namedParameters,
  }) {
    if (state is! LocalizationLoaded) {
      return label; // Return the label itself if strings are not loaded
    }

    final loadedState = state as LocalizationLoaded;
    dynamic value = _getValueFromPath(loadedState.strings, label);
    String stringToProcess = '';

    if (value is String) {
      stringToProcess = value;
    } else if (variable != null) {
      String key = 'none';
      if (variable == 1) {
        key = 'singular';
      } else {
        key = 'plural';
      }
      stringToProcess = value[key] ?? '';
    }

    // Handle positional parameters (%p1, %p2, etc.)
    if (parameters != null) {
      for (var entry in parameters.asMap().entries) {
        final index = entry.key;
        final element = entry.value;
        String toReplace = '%p${index + 1}';
        stringToProcess = stringToProcess.replaceAll(toReplace, element);
      }
    }

    // Handle named parameters ({name}, {count}, etc.)
    if (namedParameters != null) {
      namedParameters.forEach((key, value) {
        String toReplace = '{$key}';
        stringToProcess = stringToProcess.replaceAll(
          toReplace,
          value.toString(),
        );
      });
    }

    return stringToProcess;
  }

  // Helper method to get value from nested path (e.g., "timeAgo.now")
  dynamic _getValueFromPath(Map<String, dynamic> map, String path) {
    if (!path.contains('.')) {
      return map[path];
    }
    List<String> pathParts = path.split('.');

    final String lastPart = pathParts.last;
    Map<String, dynamic> current = map;

    for (String part in pathParts) {
      if (current.containsKey(part)) {
        if (current[part] is Map) {
          current = current[part];
          if (part == lastPart) {
            return current;
          }
        }
        if (current[part] is String && part == lastPart) {
          return current[part];
        }
      } else {
        return null;
      }
    }

    return current;
  }
}
