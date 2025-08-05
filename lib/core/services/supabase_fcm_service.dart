import 'package:app/core/network/dio_client.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/core/services/models/user_device_model.dart';
import 'package:app/core/services/models/device_info_helper.dart';
import 'package:flutter/foundation.dart';

abstract class SupabaseFcmService {
  Future<List<UserDeviceModel>> getUserDevices({String? userId});
  Future<UserDeviceModel?> getDeviceById(String deviceId);
  Future<UserDeviceModel> registerDevice(UserDeviceModel device);
  Future<UserDeviceModel> updateDevice(String deviceId, UserDeviceModel device);
  Future<bool> deleteDevice(String deviceId);
  Future<bool> clearDeviceToken(String userId, String deviceId);
  Future<int> clearAllUserDevices(String userId);
  Future<UserDeviceModel> createDeviceRegistration(
      {required String userId, required String fcmToken});
}

class SupabaseFcmServiceImpl implements SupabaseFcmService {
  final DioClient dio;

  SupabaseFcmServiceImpl({required this.dio});

  @override
  Future<List<UserDeviceModel>> getUserDevices({String? userId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null && userId.isNotEmpty) {
        queryParams['user_id'] = userId;
      }

      final response = await dio.get(
        '/user_devices',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final List<dynamic> devicesData = response['data'] as List<dynamic>;
      return devicesData
          .map(
            (device) =>
                UserDeviceModel.fromJson(device as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting user devices: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserDeviceModel?> getDeviceById(String deviceId) async {
    try {
      final response = await dio.get('/user_devices/$deviceId');

      if (response['success'] != true) {
        if (response['error_code'] == 'DEVICE_NOT_FOUND') {
          return null; // Device not found, return null instead of throwing
        }
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> deviceData =
          response['data'] as Map<String, dynamic>;
      return UserDeviceModel.fromJson(deviceData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting device by ID: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserDeviceModel> registerDevice(UserDeviceModel device) async {
    try {
      final response = await dio.post('/user_devices', data: device.toJson());

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> deviceData =
          response['data'] as Map<String, dynamic>;
      return UserDeviceModel.fromJson(deviceData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error registering device: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserDeviceModel> updateDevice(
    String deviceId,
    UserDeviceModel device,
  ) async {
    try {
      final response = await dio.put(
        '/user_devices/$deviceId',
        data: device.toJson(),
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      final Map<String, dynamic> deviceData =
          response['data'] as Map<String, dynamic>;
      return UserDeviceModel.fromJson(deviceData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating device: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteDevice(String deviceId) async {
    try {
      final response = await dio.delete('/user_devices/$deviceId');

      if (response['success'] != true) {
        if (response['error_code'] == 'DEVICE_NOT_FOUND') {
          return false; // Device not found
        }
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error deleting device: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> clearDeviceToken(String userId, String deviceId) async {
    try {
      final response = await dio.post(
        '/user_devices',
        queryParameters: {'action': 'clear'},
        data: {'user_id': userId, 'device_id': deviceId},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing device token: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<int> clearAllUserDevices(String userId) async {
    try {
      final response = await dio.post(
        '/user_devices',
        queryParameters: {'action': 'clear_all'},
        data: {'user_id': userId},
      );

      if (response['success'] != true) {
        throw ServerException(
          message:
              'API returned error: ${response['error'] ?? 'Unknown error'}',
        );
      }

      // Return the number of cleared devices
      return response['data']['cleared'] as int? ?? 0;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing all user devices: $e');
      }
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  /// Helper method to create a device registration payload using DeviceInfoHelper
  /// For more detailed device info, use DeviceInfoHelper.getUserDeviceModel() directly
  @override
  Future<UserDeviceModel> createDeviceRegistration({
    required String userId,
    required String fcmToken,
  }) async {
    return await DeviceInfoHelper.getUserDeviceModel(
      userId: userId,
      fcmToken: fcmToken,
    );
  }
}
