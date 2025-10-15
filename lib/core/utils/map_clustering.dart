import 'dart:math';
import 'package:app/features/locations/data/models/location_model.dart';

class ClusterItem {
  final double latitude;
  final double longitude;
  final int pointCount;
  final bool isCluster;
  final List<LocationModel> locations;

  ClusterItem({
    required this.latitude,
    required this.longitude,
    required this.pointCount,
    required this.isCluster,
    required this.locations,
  });
}

class MapClustering {
  static const double _clusterZoomThreshold = 12.0;

  /// Get cluster distance based on zoom level
  static double _getClusterDistance(double zoom) {
    // Much larger distance for very zoomed out views
    if (zoom < 4) return 0.2; // ~20km - country level
    if (zoom < 6) return 0.1; // ~10km - city level
    if (zoom < 8) return 0.05; // ~5km - district level
    if (zoom < 10) return 0.03; // ~3km - neighborhood level
    if (zoom < 12) return 0.02; // ~2km - street level
    return 0.01; // ~1km - building level
  }

  /// Create clusters from locations based on zoom level
  static List<ClusterItem> createClusters(
    List<LocationModel> locations,
    double zoom,
  ) {
    if (locations.isEmpty) return [];

    // If zoomed in enough, show individual markers
    if (zoom > _clusterZoomThreshold) {
      return locations
          .where((location) =>
              location.locationLatitude != null &&
              location.locationLongitude != null)
          .map((location) {
        final lat = double.tryParse(location.locationLatitude!) ?? 0.0;
        final lng = double.tryParse(location.locationLongitude!) ?? 0.0;

        return ClusterItem(
          latitude: lat,
          longitude: lng,
          pointCount: 1,
          isCluster: false,
          locations: [location],
        );
      }).toList();
    }

    // Create clusters for zoomed out view
    final validLocations = locations
        .where((location) =>
            location.locationLatitude != null &&
            location.locationLongitude != null)
        .toList();

    if (validLocations.isEmpty) return [];

    final clusterDistance = _getClusterDistance(zoom);
    return _createClustersRecursive(validLocations, clusterDistance);
  }

  /// Recursive clustering to handle multiple levels
  static List<ClusterItem> _createClustersRecursive(
    List<LocationModel> locations,
    double clusterDistance,
  ) {
    final clusters = <ClusterItem>[];
    final processed = <int>{};

    for (int i = 0; i < locations.length; i++) {
      if (processed.contains(i)) continue;

      final location = locations[i];
      final lat = double.tryParse(location.locationLatitude!) ?? 0.0;
      final lng = double.tryParse(location.locationLongitude!) ?? 0.0;

      final clusterLocations = <LocationModel>[location];
      processed.add(i);

      // Find nearby locations to cluster
      for (int j = i + 1; j < locations.length; j++) {
        if (processed.contains(j)) continue;

        final otherLocation = locations[j];
        final otherLat =
            double.tryParse(otherLocation.locationLatitude!) ?? 0.0;
        final otherLng =
            double.tryParse(otherLocation.locationLongitude!) ?? 0.0;

        final distance = _calculateDistance(lat, lng, otherLat, otherLng);
        if (distance < clusterDistance) {
          clusterLocations.add(otherLocation);
          processed.add(j);
        }
      }

      if (clusterLocations.length == 1) {
        // Single location - show as individual marker
        clusters.add(ClusterItem(
          latitude: lat,
          longitude: lng,
          pointCount: 1,
          isCluster: false,
          locations: clusterLocations,
        ));
      } else {
        // Multiple locations - create cluster
        final clusterLat = clusterLocations.map((loc) {
              return double.tryParse(loc.locationLatitude!) ?? 0.0;
            }).reduce((a, b) => a + b) /
            clusterLocations.length;

        final clusterLng = clusterLocations.map((loc) {
              return double.tryParse(loc.locationLongitude!) ?? 0.0;
            }).reduce((a, b) => a + b) /
            clusterLocations.length;

        clusters.add(ClusterItem(
          latitude: clusterLat,
          longitude: clusterLng,
          pointCount: clusterLocations.length,
          isCluster: true,
          locations: clusterLocations,
        ));
      }
    }

    return clusters;
  }

  /// Calculate distance between two points in degrees
  static double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    final dx = lng1 - lng2;
    final dy = lat1 - lat2;
    return sqrt(dx * dx + dy * dy);
  }

  /// Get the zoom level threshold for clustering
  static double getClusterZoomThreshold() {
    return _clusterZoomThreshold;
  }
}
