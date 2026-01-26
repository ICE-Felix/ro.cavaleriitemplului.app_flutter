import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../error/exceptions.dart';

/// WooCommerce API Client for handling WooCommerce REST API requests
///
/// This client uses OAuth1.0a authentication with Consumer Key and Secret.
/// For HTTPS connections, credentials are sent as query parameters.
class WooCommerceApiClient {
  late final Dio _dio;
  final String storeUrl;
  final String consumerKey;
  final String consumerSecret;

  // Singleton pattern
  static WooCommerceApiClient? _instance;

  factory WooCommerceApiClient({
    required String storeUrl,
    required String consumerKey,
    required String consumerSecret,
  }) {
    _instance ??= WooCommerceApiClient._internal(
      storeUrl: storeUrl,
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );
    return _instance!;
  }

  WooCommerceApiClient._internal({
    required this.storeUrl,
    required this.consumerKey,
    required this.consumerSecret,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: '$storeUrl/wp-json/wc/v3',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add WooCommerce authentication as query parameters (for HTTPS)
          options.queryParameters.addAll({
            'consumer_key': consumerKey,
            'consumer_secret': consumerSecret,
          });

          if (kDebugMode) {
            print('WooCommerce REQUEST[${options.method}] => PATH: ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              'WooCommerce RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print(
              'WooCommerce ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
            );
            print('Error message: ${e.message}');
            print('Error response: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  /// Generic GET method for WooCommerce API
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Generic POST method for WooCommerce API
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Generic PUT method for WooCommerce API
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Generic DELETE method for WooCommerce API
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Error handling for WooCommerce API responses
  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ServerException(message: 'Connection timed out');
      case DioExceptionType.badCertificate:
        throw ServerException(message: 'Bad certificate');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        String message = 'Bad response';

        // WooCommerce API returns errors in this format
        if (data is Map && data.containsKey('message')) {
          message = data['message'] as String;
        } else if (data is Map && data.containsKey('code')) {
          message = '${data['code']}: ${data['message'] ?? 'Unknown error'}';
        } else {
          message = error.message ?? 'Bad response';
        }

        if (statusCode == 401) {
          throw AuthException(message: 'Unauthorized. Invalid WooCommerce credentials.');
        } else if (statusCode == 403) {
          throw AuthException(
            message: 'Forbidden. Check WooCommerce API permissions.',
          );
        } else if (statusCode == 404) {
          throw ServerException(message: 'Resource not found');
        } else if (statusCode == 500) {
          throw ServerException(message: 'Internal server error');
        } else {
          throw ServerException(message: message);
        }
      case DioExceptionType.cancel:
        throw ServerException(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        throw NetworkException(message: 'No internet connection');
      case DioExceptionType.unknown:
        throw ServerException(message: 'Unknown error occurred');
    }
  }

  /// Reset the singleton instance (useful for testing or reconfiguration)
  static void resetInstance() {
    _instance = null;
  }
}
