import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:math';
import 'package:app/core/services/models/user_device_model.dart';

class DeviceInfoHelper {

  /// Get a unique device identifier
  /// Note: For production use, consider adding device_info_plus package for more accurate device IDs
  static Future<String> getDeviceId() async {
    try {
      // Generate a unique device ID based on platform and timestamp
      // This is a simplified version - for production, use device_info_plus package
      final platform = getPlatformName().toLowerCase();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = Random().nextInt(10000);
      
      return '${platform}_${timestamp}_$random';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting device ID: $e');
      }
      // Fallback to a generated ID based on timestamp
      return 'fallback_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Get device model information
  /// Note: This is a simplified version. For detailed device info, add device_info_plus package
  static Future<String?> getDeviceModel() async {
    try {
      if (kIsWeb) {
        return 'Web Browser';
      }

      // Return basic platform information
      // For detailed device info, use device_info_plus package
      return getPlatformName();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting device model: $e');
      }
      return null;
    }
  }

  /// Get platform information
  static String getPlatformName() {
    if (kIsWeb) return 'Web';

    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';

    return 'Unknown';
  }

  /// Get comprehensive device info for registration
  static Future<Map<String, String?>> getDeviceRegistrationInfo() async {
    final deviceId = await getDeviceId();
    final model = await getDeviceModel();
    final platform = getPlatformName();

    return {'device_id': deviceId, 'model': model, 'platform': platform};
  }

  /// Get the current device type based on platform
  static DeviceType getCurrentDeviceType() {
    if (kIsWeb) return DeviceType.web;
    
    if (Platform.isAndroid) return DeviceType.android;
    if (Platform.isIOS) return DeviceType.ios;
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return DeviceType.desktop;
    }
    
    return DeviceType.unknown;
  }

  /// Create a UserDeviceModel for the current device
  /// This is a utility function that combines device info gathering with model creation
  static Future<UserDeviceModel> getUserDeviceModel({
    required String userId,
    required String fcmToken,
  }) async {
    final deviceId = await getDeviceId();
    final model = await getDeviceModel();
    final deviceType = getCurrentDeviceType();

    return UserDeviceModel(
      deviceId: deviceId,
      userId: userId,
      fcmToken: fcmToken,
      model: model,
      deviceType: deviceType,
    );
  }
}
