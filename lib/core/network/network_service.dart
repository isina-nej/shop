// Network Configuration and HTTP Client
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class NetworkService {
  static late Dio _dio;
  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: '${AppConstants.baseUrl}/${AppConstants.apiVersion}',
        connectTimeout: AppConstants.requestTimeout,
        receiveTimeout: AppConstants.requestTimeout,
        sendTimeout: AppConstants.requestTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) {
            // Filter out debug service related logs
            final message = obj.toString();
            if (!message.contains('DebugService') &&
                !message.contains('Cannot send Null')) {
              debugPrint(message);
            }
          },
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          // Ensure no null values are sent in headers
          options.headers.removeWhere((key, value) => value == null);
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle global errors - avoid sending null error data
          if (kDebugMode && error.error != null) {
            debugPrint('Network Error: ${error.error}');
          }
          handler.next(error);
        },
      ),
    );

    _initialized = true;
  }

  static Dio get client => _dio;
}

// Network Result wrapper
class NetworkResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  NetworkResult._({this.data, this.error, required this.isSuccess});

  factory NetworkResult.success(T data) {
    return NetworkResult._(data: data, isSuccess: true);
  }

  factory NetworkResult.failure(String error) {
    return NetworkResult._(error: error, isSuccess: false);
  }
}
