import 'package:latlong2/latlong.dart';

class DistanceCalculator {
  static const Distance _distance = Distance();

  /// Calculate distance between two points in kilometers
  static double calculateDistance(LatLng point1, LatLng point2) {
    return _distance.as(LengthUnit.Kilometer, point1, point2);
  }

  /// Format distance for display
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()}m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }
}
