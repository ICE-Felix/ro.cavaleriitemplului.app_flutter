import 'package:app/core/style/app_colors.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:flutter/material.dart';

class BusinessHoursWidget extends StatelessWidget {
  const BusinessHoursWidget({super.key, required this.location});

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Status Badge and Today's Hours in a Row
          Row(
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      location.isCurrentlyOpen
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color:
                        location.isCurrentlyOpen
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      location.isCurrentlyOpen
                          ? Icons.schedule
                          : Icons.schedule_outlined,
                      size: 16,
                      color:
                          location.isCurrentlyOpen
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      location.currentStatus,
                      style: TextStyle(
                        color:
                            location.isCurrentlyOpen
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Today's Hours
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Open today:',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location.todayHoursFormatted,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Compact Business Hours Display
          if (location.parsedBusinessHours != null)
            _CompactBusinessHoursDisplay(location: location),
        ],
      ),
    );
  }
}

class _CompactBusinessHoursDisplay extends StatelessWidget {
  const _CompactBusinessHoursDisplay({required this.location});

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    final businessHours = location.parsedBusinessHours;
    if (businessHours == null) return const SizedBox.shrink();

    // Group days by their hours pattern
    final Map<String, List<String>> groupedDays = {};
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    for (final day in days) {
      final dayHours = businessHours.hours[day];
      final pattern = dayHours?.formattedHours ?? 'Closed';

      if (!groupedDays.containsKey(pattern)) {
        groupedDays[pattern] = [];
      }
      groupedDays[pattern]!.add(day);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Weekly Schedule',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...groupedDays.entries.map((entry) {
            final pattern = entry.key;
            final daysList = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    pattern == 'Closed'
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color:
                      pattern == 'Closed'
                          ? Colors.red.shade200
                          : Colors.green.shade200,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      _formatDaysGroup(daysList),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            pattern == 'Closed'
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Text(
                      pattern,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            pattern == 'Closed'
                                ? Colors.red.shade600
                                : Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _formatDaysGroup(List<String> days) {
    if (days.isEmpty) return '';

    // Sort days by their order in the week
    const dayOrder = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    days.sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));

    if (days.length == 1) {
      return _capitalizeDay(days.first);
    }

    // Check if consecutive days
    final dayIndices = days.map((day) => dayOrder.indexOf(day)).toList();
    final isConsecutive = _isConsecutive(dayIndices);

    if (isConsecutive && days.length > 1) {
      return '${_capitalizeDay(days.first)} - ${_capitalizeDay(days.last)}';
    }

    // For non-consecutive days, show individual days
    return days.map(_capitalizeDay).join(', ');
  }

  bool _isConsecutive(List<int> indices) {
    if (indices.length <= 1) return true;

    indices.sort();
    for (int i = 1; i < indices.length; i++) {
      if (indices[i] - indices[i - 1] != 1) {
        return false;
      }
    }
    return true;
  }

  String _capitalizeDay(String day) {
    return day.substring(0, 1).toUpperCase() + day.substring(1, 3);
  }
}
