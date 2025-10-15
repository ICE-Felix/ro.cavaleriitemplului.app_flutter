import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _locationKey = 'cached_location';
  static const String _locationTimestampKey = 'location_timestamp';
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  final SharedPreferences _prefs;
  StreamSubscription<Position>? _positionStream;

  LocationService(this._prefs);

  /// Get last known location instantly (no GPS call)
  Future<LatLng?> getLastKnownLocation() async {
    try {
      final lastKnownLocation = await Geolocator.getLastKnownPosition();
      if (lastKnownLocation != null) {
        return LatLng(lastKnownLocation.latitude, lastKnownLocation.longitude);
      }
      return _getCachedLocation(ignoreExpiry: true);
    } catch (e) {
      return _getCachedLocation(ignoreExpiry: true);
    }
  }

  /// Get current location with smart caching for moving users
  Future<LatLng?> getCurrentLocation({bool forceRefresh = false}) async {
    try {
      // First, try to get last known location (instant)
      if (!forceRefresh) {
        final lastKnownLocation = await Geolocator.getLastKnownPosition();
        if (lastKnownLocation != null) {
          final location = LatLng(
            lastKnownLocation.latitude,
            lastKnownLocation.longitude,
          );
          _cacheLocation(location);
          return location;
        }
      }

      // Check if we have a cached location that's still valid
      if (!forceRefresh) {
        final cachedLocation = _getCachedLocation();
        if (cachedLocation != null && _isCacheValid(_cacheValidityDuration)) {
          return cachedLocation;
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _getCachedLocation(ignoreExpiry: true);
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _getCachedLocation(ignoreExpiry: true);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _getCachedLocation(ignoreExpiry: true);
      }

      // Get current position with fast, low-accuracy first
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // Fast response
        timeLimit: const Duration(seconds: 3), // Very short timeout
      );

      final location = LatLng(position.latitude, position.longitude);

      // Cache the location
      _cacheLocation(location);

      return location;
    } catch (e) {
      // Return cached location if available, even if expired
      return _getCachedLocation(ignoreExpiry: true);
    }
  }

  /// Get cached location if it's still valid
  LatLng? _getCachedLocation({bool ignoreExpiry = false}) {
    try {
      final latStr = _prefs.getString('${_locationKey}_lat');
      final lngStr = _prefs.getString('${_locationKey}_lng');
      final timestampStr = _prefs.getString(_locationTimestampKey);

      if (latStr == null || lngStr == null || timestampStr == null) {
        return null;
      }

      final lat = double.tryParse(latStr);
      final lng = double.tryParse(lngStr);
      final timestamp = DateTime.tryParse(timestampStr);

      if (lat == null || lng == null || timestamp == null) {
        return null;
      }

      // Check if cache is still valid
      if (!ignoreExpiry &&
          DateTime.now().difference(timestamp) > _cacheValidityDuration) {
        return null;
      }

      return LatLng(lat, lng);
    } catch (e) {
      return null;
    }
  }

  /// Cache location with timestamp
  void _cacheLocation(LatLng location) {
    try {
      _prefs.setString('${_locationKey}_lat', location.latitude.toString());
      _prefs.setString('${_locationKey}_lng', location.longitude.toString());
      _prefs.setString(_locationTimestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Ignore caching errors
    }
  }

  /// Clear cached location
  void clearCache() {
    _prefs.remove('${_locationKey}_lat');
    _prefs.remove('${_locationKey}_lng');
    _prefs.remove(_locationTimestampKey);
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

  /// Start background location updates for moving users
  void startBackgroundLocationUpdates() {
    _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low, // Fast updates
        distanceFilter: 100, // Update every 100 meters (less frequent)
        timeLimit: Duration(seconds: 3), // Fast timeout
      ),
    ).listen(
      (Position position) {
        final location = LatLng(position.latitude, position.longitude);
        _cacheLocation(location);
      },
      onError: (error) {
        // Handle stream errors silently
      },
    );
  }

  /// Stop background location updates
  void stopBackgroundLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// Check if cache is still valid
  bool _isCacheValid(Duration duration) {
    final cachedTime = _getCachedTimestamp();
    if (cachedTime == null) return false;

    return DateTime.now().difference(cachedTime) < duration;
  }

  /// Get cached timestamp
  DateTime? _getCachedTimestamp() {
    try {
      final timestampStr = _prefs.getString(_locationTimestampKey);
      if (timestampStr == null) return null;
      return DateTime.tryParse(timestampStr);
    } catch (e) {
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _positionStream?.cancel();
  }
}
