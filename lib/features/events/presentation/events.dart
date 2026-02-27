import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/core/widgets/custom_top_bar.dart';
import 'package:app/core/widgets/app_search_bar_v2.dart';
import 'package:app/core/widgets/category_horizontal_slider.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/features/events/presentation/bloc/events_bloc.dart';
import 'package:app/features/events/presentation/widgets/events_list.dart';
import 'package:app/features/events/presentation/widgets/events_calendar.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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
      backgroundColor: AppColors.background,
      appBar: CustomTopBar.withCart(
        context: context,
        showLogo: true,
        logoHeight: 200,
        logoWidth: 0,
        centerTitle: false,
        showNotificationButton: true,
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Search bar
                AppSearchBarV2(
                  controller: _searchController,
                  hintText: 'Caută evenimente...',
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  onChanged: (query) {
                    if (query.isEmpty) {
                      context.read<EventsBloc>().add(const ClearSearchEventsEvent());
                    } else {
                      context.read<EventsBloc>().add(SearchEventsEvent(query));
                    }
                  },
                  onClear: () {
                    context.read<EventsBloc>().add(const ClearSearchEventsEvent());
                  },
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      // Calendar
                      Visibility(
                        visible: !state.isCalendarMinimized,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: EventsCalendar(
                            selectedDate: state.selectedDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            allEvents: state.allMonthEvents,
                            onDateChanged: (DateTime selectedDate) {
                              context.read<EventsBloc>().add(
                                SelectDateEvent(selectedDate),
                              );
                            },
                            onMonthChanged: (DateTime month) {
                              context.read<EventsBloc>().add(
                                LoadMonthEventsEvent(month),
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
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: FaIcon(
                            state.isCalendarMinimized
                                ? FontAwesomeIcons.chevronDown
                                : FontAwesomeIcons.chevronUp,
                            size: 14,
                          ),
                          label: Text(
                            state.isCalendarMinimized
                                ? 'Arată Calendarul'
                                : 'Ascunde Calendarul',
                            style: const TextStyle(
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
                      itemsPerPage: 3,
                      height: 40,
                    ),
                  ),

                const SizedBox(height: 16),

                // Events Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.calendarDays,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.searchQuery.isNotEmpty
                                  ? 'Rezultate pentru "${state.searchQuery}"'
                                  : 'Evenimente pe ${_formatDate(state.selectedDate)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            if (state.searchQuery.isEmpty)
                              Text(
                                _getDayOfWeek(state.selectedDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onBackground.withValues(alpha: 0.6),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Events List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EventsList(state: state),
                ),

                const SizedBox(height: 16),
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
