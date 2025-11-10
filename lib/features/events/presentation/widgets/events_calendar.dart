import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app/features/events/domain/model/events.dart';

class EventsCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateChanged;
  final Function(DateTime)? onMonthChanged;
  final List<Event> allEvents;

  const EventsCalendar({
    super.key,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.onMonthChanged,
    required this.allEvents,
  });

  @override
  State<EventsCalendar> createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate;
    _selectedDay = widget.selectedDate;
  }

  @override
  void didUpdateWidget(EventsCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _focusedDay = widget.selectedDate;
      _selectedDay = widget.selectedDate;
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return widget.allEvents.where((event) {
      try {
        final eventDate = DateTime.parse(event.start);
        return isSameDay(eventDate, day);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: TableCalendar<Event>(
        firstDay: widget.firstDate,
        lastDay: widget.lastDate,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: _getEventsForDay,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        locale: 'ro_RO',
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).primaryColor,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Theme.of(context).primaryColor,
          ),
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        calendarStyle: CalendarStyle(
          // Today's date
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          // Selected date
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          // Default dates
          defaultTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          // Weekend dates
          weekendTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
          // Outside dates (dates from other months)
          outsideTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          // Marker (event indicator) - will be customized with markerBuilder
          markerDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
          markerSize: 7.0,
          markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),
        ),
        calendarBuilders: CalendarBuilders(
          // Custom marker builder for more visible event indicators
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return const SizedBox.shrink();

            return Positioned(
              bottom: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (events.length > 1) ...[
                    const SizedBox(width: 2),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  if (events.length > 2) ...[
                    const SizedBox(width: 2),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onDateChanged(selectedDay);
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          // Notify when month changes
          if (widget.onMonthChanged != null) {
            widget.onMonthChanged!(focusedDay);
          }
        },
      ),
    );
  }
}
