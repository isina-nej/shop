// Network Configuration and HTTP Client
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class NetworkService {
  static late Dio _dio;

  static void initialize() {
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
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          // TODO: Implement token management
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle global errors
          // TODO: Implement error handling
          handler.next(error);
        },
      ),
    );
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
