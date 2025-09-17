import 'package:app/core/localization/app_localization.dart';
import 'package:app/core/localization/widgets/language_switcher_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/features/locations/presentations/cubit/location_details/location_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationsDetailsPage extends StatelessWidget {
  const LocationsDetailsPage({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationDetailsCubit>(
      create:
          (context) => LocationDetailsCubit()..getLocationDetails(locationId),
      child: const LocationsDetailsPageView(),
    );
  }
}

class LocationsDetailsPageView extends StatelessWidget {
  const LocationsDetailsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        showProfileButton: true,
        showNotificationButton: true,
        showLogo: true,
        logoHeight: 90,
        logoWidth: 140,
        logoPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        notificationCount: 0,
        onProfileTap: () {},
        onNotificationTap: () {
          // Handle notification tap
        },
        onLogoTap: () {},
        customActions: [
          // Language switcher button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: LanguageSwitcherWidget(isCompact: true),
          ),
          // Saved articles button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                context.pushNamed(AppRoutesNames.savedArticles.name);
              },
              icon: const FaIcon(FontAwesomeIcons.solidBookmark, size: 20),
              tooltip: context.getString(label: 'savedArticles'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<LocationDetailsCubit, LocationDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isError) {
            return Center(
              child: Text(state.errorMessage ?? 'An error occurred'),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Location Name
                Text(
                  state.location?.name ?? 'Unknown Location',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Location Address
                if (state.location?.address != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          state.location!.address!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Open now',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Description Section
                Text(
                  'About',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  state.location?.description ??
                      'No description available for this location.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Contact Information
                if (state.location?.phoneNo != null ||
                    state.location?.email != null) ...[
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (state.location?.phoneNo != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            state.location!.phoneNo!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                  if (state.location?.email != null)
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          state.location!.email!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final latitude = double.tryParse(
                            state.location!.locationLatitude!,
                          );
                          final longitude = double.tryParse(
                            state.location!.locationLongitude!,
                          );
                          if (latitude == null || longitude == null) {
                            return;
                          }

                          final availableMaps = await MapLauncher.installedMaps;

                          await availableMaps.first.showMarker(
                            coords: Coords(latitude, longitude),
                            title: state.location?.name ?? 'No name available',
                          );
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('Get Directions'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (state.location!.phoneNo != null) {
                            launchUrl(
                              Uri.parse('tel:${state.location!.phoneNo}'),
                            );
                          }
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
