import 'package:app/core/style/app_colors.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key, required this.location});

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          // Get Directions Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleGetDirections(context),
              icon: const Icon(Icons.directions, size: 20),
              label: const Text(
                'Get Directions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Call Button (if phone number exists)
          if (location.phoneNo != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleCall(context),
                icon: const Icon(Icons.phone, size: 20),
                label: const Text(
                  'Call Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleGetDirections(BuildContext context) async {
    final latitude = double.tryParse(location.locationLatitude ?? '');
    final longitude = double.tryParse(location.locationLongitude ?? '');

    if (latitude == null || longitude == null) {
      _showErrorSnackBar(context, 'Location coordinates not available');
      return;
    }

    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
        _showErrorSnackBar(context, 'No map apps available');
        return;
      }

      await availableMaps.first.showMarker(
        coords: Coords(latitude, longitude),
        title: location.name,
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to open map: $e');
    }
  }

  Future<void> _handleCall(BuildContext context) async {
    if (location.phoneNo == null) return;

    try {
      await launchUrl(Uri.parse('tel:${location.phoneNo}'));
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to make call: $e');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
