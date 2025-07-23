import 'package:app/core/network/supabase_client.dart';
import 'package:app/core/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../error/exceptions.dart';

class DioClient {
  late final Dio _dio;
  late final SupabaseAuthClient _authClient;

  // Singleton pattern
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  DioClient._internal() {
    _authClient = sl.get<SupabaseAuthClient>();
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.get('SUPABASE_URL')}/functions/v1',
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
          if (_authClient.isAuthenticated) {
            final session = _authClient.currentSession;
            if (session?.accessToken != null) {
              options.headers['Authorization'] =
                  'Bearer ${session!.accessToken}';
            }
          }

          options.headers['x-client-type'] = 'api';
          options.headers['apikey'] = dotenv.get('ANON_KEY');
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';

          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print(
              'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
            );
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

  // Generic GET method
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

  // Generic POST method
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

  // Generic PUT method
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

  // Generic DELETE method
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

  // Error handling
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
        final message =
            error.response?.data['message'] ?? error.message ?? 'Bad response';

        if (statusCode == 401) {
          throw AuthException(message: 'Unauthorized. Please login again.');
        } else if (statusCode == 403) {
          throw AuthException(
            message: 'Forbidden. You do not have permission.',
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
}
