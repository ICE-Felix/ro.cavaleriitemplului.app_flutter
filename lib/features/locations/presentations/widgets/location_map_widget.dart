import 'package:app/core/utils/map_clustering.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:app/features/locations/presentations/widgets/cluster_marker_widget.dart';
import 'package:app/features/locations/presentations/widgets/location_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class LocationMapWidget extends StatefulWidget {
  const LocationMapWidget({
    super.key,
    required this.style,
    required this.locations,
    required this.currentLocation,
    required this.isLocationLoading,
  });

  final Style style;
  final List<LocationModel> locations;
  final LatLng? currentLocation;
  final bool isLocationLoading;

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  final MapController _mapController = MapController();
  double _currentZoom = 15.0;

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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Unable to get current location',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.currentLocation!,
        initialZoom: 15.0,
        minZoom: 3.0,
        maxZoom: 18.0,
        onMapEvent: (MapEvent mapEvent) {
          if (mapEvent is MapEventMove) {
            setState(() {
              _currentZoom = _mapController.camera.zoom;
            });
          }
        },
      ),
      children: [
        VectorTileLayer(
          tileProviders: widget.style.providers,
          theme: widget.style.theme,
          sprites: widget.style.sprites,
        ),
        MarkerLayer(
          markers: _buildMarkers(),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Add current location marker
    markers.add(
      Marker(
        point: widget.currentLocation!,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    );

    // Create clusters based on current zoom level
    final clusters =
        MapClustering.createClusters(widget.locations, _currentZoom);


    for (final cluster in clusters) {
      if (cluster.isCluster) {
        // Add cluster marker
        markers.add(
          Marker(
            point: LatLng(cluster.latitude, cluster.longitude),
            width: 40,
            height: 40,
            child: ClusterMarkerWidget(
              count: cluster.pointCount,
              point: LatLng(cluster.latitude, cluster.longitude),
              onTap: () => _onClusterTap(cluster),
            ),
          ),
        );
      } else {
        // Add individual location marker
        final location = cluster.locations.first;

        markers.add(
          Marker(
            point: LatLng(cluster.latitude, cluster.longitude),
            width: 30,
            height: 30,
            child: GestureDetector(
              onTap: () => _showLocationPopup(context, location),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  void _onClusterTap(ClusterItem cluster) {
    // Zoom in to expand the cluster
    final newZoom = _currentZoom + 2;
    _mapController.move(
      LatLng(cluster.latitude, cluster.longitude),
      newZoom,
    );
  }

  void _showLocationPopup(BuildContext context, LocationModel location) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: LocationPopupWidget(location: location),
      ),
    );
  }
}
