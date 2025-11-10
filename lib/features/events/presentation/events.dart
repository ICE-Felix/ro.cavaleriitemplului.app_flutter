import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/core/widgets/category_horizontal_slider.dart';
import 'package:app/features/events/presentation/bloc/events_bloc.dart';
import 'package:app/features/events/presentation/widgets/events_list.dart';
import 'package:app/features/events/domain/model/events_type.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsBloc()..add(InitEventsEvent()),
      child: const _EventsPageContent(),
    );
  }
}

class _EventsPageContent extends StatefulWidget {
  const _EventsPageContent();

  @override
  State<_EventsPageContent> createState() => _EventsPageContentState();
}

class _EventsPageContentState extends State<_EventsPageContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when user scrolls to 80% of the content
      context.read<EventsBloc>().add(const LoadMoreEventsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar.withCart(
        context: context,
        showLogo: true,
        showBackButton: false,
        showNotificationButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      // Calendar
                      Visibility(
                        visible: !state.isCalendarMinimized,
                        child: Container(
                          // height: 400,
                          padding: const EdgeInsets.all(8),
                          child: CalendarDatePicker(
                            initialDate: state.selectedDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            onDateChanged: (DateTime selectedDate) {
                              context.read<EventsBloc>().add(
                                SelectDateEvent(selectedDate),
                              );
                            },
                          ),
                        ),
                      ),

                      // Minimize Button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<EventsBloc>().add(
                              const ToggleCalendarMinimizedEvent(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.1),
                            foregroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(
                            state.isCalendarMinimized
                                ? Icons.expand_more
                                : Icons.expand_less,
                            size: 20,
                          ),
                          label: Text(
                            state.isCalendarMinimized
                                ? 'Arată Calendarul'
                                : 'Ascunde Calendarul',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Event Type Slider
                if (state.eventTypes.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategoryHorizontalSlider<EventType>(
                      showAllButton: true,
                      items: state.eventTypes,
                      getDisplayName: (eventType) => eventType.name,
                      onSelectionChanged: (eventType) {
                        // Load events for the selected event type and current date
                        final dateString =
                            '${state.selectedDate.year}-${state.selectedDate.month.toString().padLeft(2, '0')}-${state.selectedDate.day.toString().padLeft(2, '0')}';
                        context.read<EventsBloc>().add(
                          LoadEventsEvent(
                            eventType: eventType?.id,
                            page: 1,
                            date: dateString,
                          ),
                        );
                      },
                      getItemId: (eventType) => eventType.id,
                      // selectedItemId: state.selectedEventTypeId,
                      itemsPerPage: 3,
                      height: 40,
                    ),
                  ),

                const SizedBox(height: 16),

                // Events List
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Evenimente pe ${_formatDate(state.selectedDate)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  _getDayOfWeek(state.selectedDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      EventsList(state: state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getDayOfWeek(DateTime date) {
    const days = [
      'Luni',
      'Marți',
      'Miercuri',
      'Joi',
      'Vineri',
      'Sâmbătă',
      'Duminică',
    ];
    return days[date.weekday - 1];
  }
}
