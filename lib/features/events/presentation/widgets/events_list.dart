import 'package:app/core/style/app_colors.dart';
import 'package:app/features/events/presentation/bloc/events_bloc.dart';
import 'package:app/features/events/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventsList extends StatelessWidget {
  final EventsState state;

  const EventsList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == EventsStatus.loading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.status == EventsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Eroare la încărcarea evenimentelor',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onBackground.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state.events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.calendarCheck,
              size: 48,
              color: AppColors.onBackground.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Nu sunt evenimente programate',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onBackground.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 8),
            Text(
              'Evenimentele vor apărea aici când sunt disponibile',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onBackground.withValues(alpha: 0.4)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: state.events.map((event) => EventCard(event: event)).toList(),
    );
  }
}
