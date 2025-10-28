import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _locationKey = 'cached_location';
  static const String _locationTimestampKey = 'location_timestamp';
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  LocationService();

  /// Get current location with smart caching for moving users
  Future<LatLng?> getCurrentLocation({bool forceRefresh = false}) async {
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Get current position with fast, low-accuracy first
    Position position = await Geolocator.getCurrentPosition();

    final location = LatLng(position.latitude, position.longitude);

    return location;
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
