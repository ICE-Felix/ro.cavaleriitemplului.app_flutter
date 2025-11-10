import 'package:app/core/utils/distance_calculator.dart' as distance_utils;
import 'package:app/core/style/app_colors.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationListItem extends StatelessWidget {
  const LocationListItem({
    super.key,
    required this.location,
    this.height = 150,
    this.onTap,
    this.currentLocation,
  });

  final LocationModel location;
  final double height;
  final VoidCallback? onTap;
  final LatLng? currentLocation;

  @override
  Widget build(BuildContext context) {
    String? distanceText;
    if (currentLocation != null &&
        location.locationLatitude != null &&
        location.locationLongitude != null) {
      final lat = double.tryParse(location.locationLatitude!);
      final lng = double.tryParse(location.locationLongitude!);
      if (lat != null && lng != null) {
        final distance = distance_utils.DistanceCalculator.calculateDistance(
          currentLocation!,
          LatLng(lat, lng),
        );
        distanceText = distance_utils.DistanceCalculator.formatDistance(
          distance,
        );
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Location Image/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      location.imageFeaturedUrl != null
                          ? Colors.transparent
                          : AppColors.primary,
                ),
                child:
                    location.imageFeaturedUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            location.imageFeaturedUrl!,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primary,
                                child: Image.asset(
                                  'assets/images/logo/logo.png',
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        )
                        : Image.asset(
                          'assets/images/logo/logo.png',
                          height: 40,
                          fit: BoxFit.contain,
                        ),
              ),
              const SizedBox(width: 16),

              // Location Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Name
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Address
                    if (location.address != null)
                      Text(
                        location.address!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),

                    // Status and Distance Row
                    Row(
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                location.isCurrentlyOpen
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  location.isCurrentlyOpen
                                      ? AppColors.success.withValues(alpha: 0.3)
                                      : AppColors.error.withValues(alpha: 0.3),
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
                                size: 12,
                                color:
                                    location.isCurrentlyOpen
                                        ? AppColors.success
                                        : AppColors.error,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location.currentStatus,
                                style: TextStyle(
                                  color:
                                      location.isCurrentlyOpen
                                          ? AppColors.success
                                          : AppColors.error,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // Distance Badge
                        if (distanceText != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.near_me,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  distanceText,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
