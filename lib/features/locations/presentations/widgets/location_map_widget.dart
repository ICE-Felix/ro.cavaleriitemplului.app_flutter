import 'package:app/core/style/app_colors.dart';
import 'package:app/core/utils/map_utils.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:app/features/locations/presentations/cubit/selected_location_category/selected_location_category_cubit.dart';
import 'package:app/features/locations/presentations/widgets/location_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class LocationMapWidget extends StatefulWidget {
  const LocationMapWidget({
    super.key,
    required this.style,
    required this.currentLocation,
    required this.isLocationLoading,
  });

  final Style style;
  final LatLng? currentLocation;
  final bool isLocationLoading;

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  final MapController _mapController = MapController();
  LatLng? _lastLoadedCenter;
  double _lastLoadedZoom = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.isLocationLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Getting your location...'),
          ],
        ),
      );
    }

    if (widget.currentLocation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to get current location',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<
      SelectedLocationCategoryCubit,
      SelectedLocationCategoryState
    >(
      builder: (context, state) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.currentLocation!,
            onPositionChanged: (camera, hasGesture) {
              _onMapPositionChanged(context, camera);
            },
            initialZoom: MapUtils.defaultZoomLevel,
            minZoom: MapUtils.minZoomLevel,
            maxZoom: MapUtils.maxZoomLevel,
          ),
          children: [
            VectorTileLayer(
              tileProviders: widget.style.providers,
              theme: widget.style.theme,
              sprites: widget.style.sprites,
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                maxZoom: 15,
                markers: _buildMarkers(state.mapVenues),
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Marker> _buildMarkers(List<LocationModel> venues) {
    final markers = <Marker>[];

    // Add current location marker
    markers.add(
      Marker(
        point: widget.currentLocation!,
        width: 40,
        height: 40,
        child: Icon(
          Icons.location_on,
          color: AppColors.error,
          size: 40,
        ),
      ),
    );

    // Add venue markers
    for (final location in venues) {
      if (location.locationLatitude != null &&
          location.locationLongitude != null) {
        final lat = double.tryParse(location.locationLatitude!) ?? 0.0;
        final lng = double.tryParse(location.locationLongitude!) ?? 0.0;

        markers.add(
          Marker(
            point: LatLng(lat, lng),
            width: 30,
            height: 30,
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () => _showLocationPopup(context, location),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }

    return markers;
  }

  void _onMapPositionChanged(BuildContext context, MapCamera camera) {
    final center = camera.center;
    final zoom = camera.zoom;

    // Only load new venues if the position has changed significantly
    // or if this is the first load
    if (_lastLoadedCenter == null ||
        _hasPositionChangedSignificantly(center, zoom)) {
      _lastLoadedCenter = center;
      _lastLoadedZoom = zoom;

      // Calculate viewport radius based on zoom level
      final screenSize = MediaQuery.of(context).size;
      final radius = MapUtils.calculateViewportRadius(
        zoom: zoom,
        screenWidth: screenSize.width,
        screenHeight: screenSize.height,
      );

      // Load venues for the new center position
      context.read<SelectedLocationCategoryCubit>().loadMapVenues(
        latitude: center.latitude,
        longitude: center.longitude,
        radiusKm: radius,
      );
    }
  }

  bool _hasPositionChangedSignificantly(LatLng newCenter, double newZoom) {
    if (_lastLoadedCenter == null) return true;

    // Check if zoom level changed significantly (more than 1 level)
    if ((newZoom - _lastLoadedZoom).abs() > 1.0) return true;

    // Check if center moved significantly (more than ~1km)
    final distance = MapUtils.calculateDistance(
      _lastLoadedCenter!.latitude,
      _lastLoadedCenter!.longitude,
      newCenter.latitude,
      newCenter.longitude,
    );

    return distance > 1.0; // 1km threshold
  }

  void _showLocationPopup(BuildContext context, LocationModel location) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
            backgroundColor: Colors.transparent,
            child: LocationPopupWidget(location: location),
          ),
    );
  }
}
