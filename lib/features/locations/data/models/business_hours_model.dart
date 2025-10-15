class BusinessHoursModel {
  final bool enabled;
  final String open;
  final String close;

  const BusinessHoursModel({
    required this.enabled,
    required this.open,
    required this.close,
  });

  factory BusinessHoursModel.fromJson(Map<String, dynamic> json) {
    return BusinessHoursModel(
      enabled: json['enabled'] as bool? ?? false,
      open: json['open'] as String? ?? '09:00',
      close: json['close'] as String? ?? '17:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'open': open, 'close': close};
  }

  String get formattedHours {
    if (!enabled) return 'Closed';
    return '${_formatTime(open)} - ${_formatTime(close)}';
  }

  String _formatTime(String time) {
    // Convert 24-hour format to 12-hour format with AM/PM
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) {
      return '12:${minute} AM';
    } else if (hour < 12) {
      return '$time AM';
    } else if (hour == 12) {
      return '12:${minute} PM';
    } else {
      return '${hour - 12}:${minute} PM';
    }
  }

  bool get isOpen {
    if (!enabled) return false;

    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return currentTime.compareTo(open) >= 0 &&
        currentTime.compareTo(close) <= 0;
  }
}

class WeeklyBusinessHours {
  final Map<String, BusinessHoursModel> hours;

  const WeeklyBusinessHours({required this.hours});

  factory WeeklyBusinessHours.fromJson(Map<String, dynamic> json) {
    final Map<String, BusinessHoursModel> hoursMap = {};

    for (final entry in json.entries) {
      hoursMap[entry.key] = BusinessHoursModel.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    return WeeklyBusinessHours(hours: hoursMap);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    for (final entry in hours.entries) {
      result[entry.key] = entry.value.toJson();
    }
    return result;
  }

  /// Get today's business hours
  BusinessHoursModel? get todayHours {
    final today = _getTodayName();
    return hours[today];
  }

  /// Check if the location is currently open
  bool get isCurrentlyOpen {
    final today = todayHours;
    return today?.isOpen ?? false;
  }

  /// Get a formatted string for today's hours
  String get todayHoursFormatted {
    final today = todayHours;
    return today?.formattedHours ?? 'Closed';
  }

  /// Get a compact summary of all hours
  String get compactSummary {
    final List<String> summaries = [];

    // Group consecutive days with same hours
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    String? currentPattern;
    String? startDay;

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final dayHours = hours[day];
      final pattern = dayHours?.formattedHours ?? 'Closed';

      if (currentPattern == null) {
        currentPattern = pattern;
        startDay = day;
      } else if (currentPattern != pattern) {
        // Add the previous group
        if (startDay == days[i - 1]) {
          summaries.add('${_capitalizeDay(startDay!)}: $currentPattern');
        } else {
          summaries.add(
            '${_capitalizeDay(startDay!)}-${_capitalizeDay(days[i - 1])}: $currentPattern',
          );
        }

        currentPattern = pattern;
        startDay = day;
      }

      // Handle the last day
      if (i == days.length - 1) {
        if (startDay == day) {
          summaries.add('${_capitalizeDay(day)}: $pattern');
        } else {
          summaries.add(
            '${_capitalizeDay(startDay!)}-${_capitalizeDay(day)}: $pattern',
          );
        }
      }
    }

    return summaries.join('\n');
  }

  String _getTodayName() {
    final now = DateTime.now();
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[now.weekday - 1];
  }

  String _capitalizeDay(String day) {
    return day.substring(0, 1).toUpperCase() + day.substring(1, 3);
  }

  /// Get a detailed summary with better formatting
  String get detailedSummary {
    final List<String> summaries = [];

    // Group consecutive days with same hours
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    String? currentPattern;
    String? startDay;

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final dayHours = hours[day];
      final pattern = dayHours?.formattedHours ?? 'Closed';

      if (currentPattern == null) {
        currentPattern = pattern;
        startDay = day;
      } else if (currentPattern != pattern) {
        // Add the previous group
        if (startDay == days[i - 1]) {
          summaries.add('${_capitalizeDay(startDay!)}: $currentPattern');
        } else {
          summaries.add(
            '${_capitalizeDay(startDay!)}-${_capitalizeDay(days[i - 1])}: $currentPattern',
          );
        }

        currentPattern = pattern;
        startDay = day;
      }

      // Handle the last day
      if (i == days.length - 1) {
        if (startDay == day) {
          summaries.add('${_capitalizeDay(day)}: $pattern');
        } else {
          summaries.add(
            '${_capitalizeDay(startDay!)}-${_capitalizeDay(day)}: $pattern',
          );
        }
      }
    }

    return summaries.join('\n');
  }
}
