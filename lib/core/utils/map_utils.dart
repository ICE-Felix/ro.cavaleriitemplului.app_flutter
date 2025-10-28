import 'dart:math';
import 'package:latlong2/latlong.dart';

class MapUtils {
  static const String flutterMapTileProviderUrl =
      'https://tiles.openfreemap.org/styles/bright';
  
  static const double defaultZoomLevel = 15.0;
  static const double minZoomLevel = 3.0;
  static const double maxZoomLevel = 18.0;
  static const int defaultRadiusKmForMap = 100;
  static const int defaultRadiusKmForList = 30;
  static const int minRadiusFilterValue = 0;
  static const int maxRadiusFilterValue = 100;
  static const int radiusFilterDivisions = 20;

  /// Calculate the radius in kilometers based on the map viewport
  /// This is an approximation based on zoom level and screen size
  static int calculateViewportRadius({
    required double zoom,
    required double screenWidth,
    required double screenHeight,
  }) {
    // Approximate radius calculation based on zoom level
    // This is a rough estimation - in a real app you might want to use
    // the actual map bounds to calculate the exact radius

    // Base radius at zoom level 15 (typical city level)
    const baseRadius = 5.0; // 5km at zoom 15

    // Calculate radius based on zoom level
    // Higher zoom = smaller radius, lower zoom = larger radius
    final zoomFactor = pow(2, 15 - zoom).toDouble();
    final calculatedRadius = baseRadius * zoomFactor;

    // Clamp between 1km and 100km
    final radius = calculatedRadius.clamp(1.0, 100.0);

    return radius.round();
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const Distance distance = Distance();
    return distance.as(
      LengthUnit.Kilometer,
      LatLng(lat1, lng1),
      LatLng(lat2, lng2),
    );
  }

  /// Calculate radius from map bounds (if available)
  static int calculateRadiusFromBounds({
    required LatLng center,
    required LatLng northeast,
    required LatLng southwest,
  }) {
    // Calculate the distance from center to northeast corner
    final distance = calculateDistance(
      center.latitude,
      center.longitude,
      northeast.latitude,
      northeast.longitude,
    );

    // Return radius in km, clamped between 1 and 100
    return distance.clamp(1.0, 100.0).round();
  }
}
