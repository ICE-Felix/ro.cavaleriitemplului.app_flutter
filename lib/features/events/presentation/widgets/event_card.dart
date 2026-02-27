import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutesNames.eventDetails.name,
          pathParameters: {'id': event.id},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            if (event.eventImageId != null && event.eventImageId!.isNotEmpty)
              _EventImage(imageId: event.eventImageId!)
            else
              _PlaceholderImage(),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Location
                  _EventLocation(event: event),
                  const SizedBox(height: 8),

                  // Time
                  _EventTime(event: event),
                  const SizedBox(height: 8),

                  // Event Type
                  _EventTypeChip(eventTypeName: event.eventTypeName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventImage extends StatelessWidget {
  final String imageId;

  const _EventImage({required this.imageId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          imageId,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.primary.withValues(alpha: 0.1),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.calendarDays,
                  size: 48,
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.primary.withValues(alpha: 0.05),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.calendarDays,
          size: 48,
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _EventLocation extends StatelessWidget {
  final Event event;

  const _EventLocation({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(FontAwesomeIcons.locationDot,
            size: 14, color: AppColors.onBackground.withValues(alpha: 0.6)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            event.venueName.isNotEmpty ? event.venueName : event.address,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.onBackground.withValues(alpha: 0.7)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EventTime extends StatelessWidget {
  final Event event;

  const _EventTime({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(FontAwesomeIcons.clock,
            size: 14, color: AppColors.onBackground.withValues(alpha: 0.6)),
        const SizedBox(width: 6),
        Text(
          _formatEventTime(event.start, event.end),
          style: TextStyle(
              fontSize: 14,
              color: AppColors.onBackground.withValues(alpha: 0.7)),
        ),
      ],
    );
  }

  String _formatEventTime(String start, String end) {
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);

      final startTime =
          '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';
      final endTime =
          '${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}';

      return '$startTime - $endTime';
    } catch (e) {
      return 'Ora necunoscută';
    }
  }
}

class _EventTypeChip extends StatelessWidget {
  final String eventTypeName;

  const _EventTypeChip({required this.eventTypeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        eventTypeName,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
