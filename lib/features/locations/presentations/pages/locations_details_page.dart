import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/core/widgets/image_gallery/wiget/image_gallery.dart';
import 'package:app/features/locations/presentations/cubit/location_details/location_details_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_details/location_image_widget.dart';
import 'package:app/features/locations/presentations/widgets/location_details/location_info_widget.dart';
import 'package:app/features/locations/presentations/widgets/location_details/business_hours_widget.dart';
import 'package:app/features/locations/presentations/widgets/location_details/description_widget.dart';
import 'package:app/features/locations/presentations/widgets/location_details/contact_info_widget.dart';
import 'package:app/features/locations/presentations/widgets/location_details/action_buttons_widget.dart';
import 'package:app/features/locations/presentations/widgets/location_details/location_attributes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationsDetailsPage extends StatelessWidget {
  const LocationsDetailsPage({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationDetailsCubit>(
      create:
          (context) => LocationDetailsCubit()..getLocationDetails(locationId),
      child: LocationsDetailsPageView(locationId: locationId),
    );
  }
}

class LocationsDetailsPageView extends StatelessWidget {
  const LocationsDetailsPageView({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar.withCart(
        context: context,
        showBackButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
        onLogoTap: () {},
      ),
      body: BlocBuilder<LocationDetailsCubit, LocationDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const _LoadingView();
          }
          if (state.isError) {
            return _ErrorView(
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<LocationDetailsCubit>().getLocationDetails(
                  locationId,
                );
              },
            );
          }
          if (state.location == null) {
            return const _NoDataView();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Image
                ImageGallery(images: state.location?.images ?? [],featureImage: state.location?.imageFeaturedUrl),
              
                // Location Info
                LocationInfoWidget(location: state.location!),
                const SizedBox(height: 20),

                // Business Hours
                BusinessHoursWidget(location: state.location!),

                // Location Attributes
                LocationAttributesWidget(location: state.location!),
                const SizedBox(height: 24),

                // Description
                DescriptionWidget(location: state.location!),
                const SizedBox(height: 24),

                // Contact Information
                ContactInfoWidget(location: state.location!),
                const SizedBox(height: 24),

                // Action Buttons
                ActionButtonsWidget(location: state.location!),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading location details...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.errorMessage, required this.onRetry});

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? 'An error occurred',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _NoDataView extends StatelessWidget {
  const _NoDataView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No location data available', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
