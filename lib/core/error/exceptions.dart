// App Error Classes
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  String toString() => message;
}

// Network Exceptions
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class TimeoutException extends NetworkException {
  const TimeoutException({
    String message = 'Request timeout',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    String message = 'No internet connection',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class ServerException extends NetworkException {
  const ServerException({
    String message = 'Server error',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Auth Exceptions
class AuthException extends AppException {
  const AuthException({required String message, String? code, dynamic details})
    : super(message: message, code: code, details: details);
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    String message = 'Unauthorized access',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    String message = 'Token expired',
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Validation Exceptions
class ValidationException extends AppException {
  const ValidationException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Storage Exceptions
class StorageException extends AppException {
  const StorageException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

// Cache Exceptions
class CacheException extends AppException {
  const CacheException({required String message, String? code, dynamic details})
    : super(message: message, code: code, details: details);
}
