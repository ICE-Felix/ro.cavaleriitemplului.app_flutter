import 'package:app/features/events/presentation/bloc/events_bloc.dart';
import 'package:app/features/events/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventsList extends StatelessWidget {
  final EventsState state;

  const EventsList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == EventsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == EventsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Eroare la încărcarea evenimentelor',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
            Icon(Icons.event_available, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nu sunt evenimente programate',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Evenimentele vor apărea aici când sunt disponibile',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
