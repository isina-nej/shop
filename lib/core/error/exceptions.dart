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
  const NetworkException({required super.message, super.code, super.details});
}

class TimeoutException extends NetworkException {
  const TimeoutException({
    super.message = 'Request timeout',
    super.code,
    super.details,
  });
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    super.message = 'No internet connection',
    super.code,
    super.details,
  });
}

class ServerException extends NetworkException {
  const ServerException({
    super.message = 'Server error',
    super.code,
    super.details,
  });
}

// Auth Exceptions
class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.details});
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.code,
    super.details,
  });
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    super.message = 'Token expired',
    super.code,
    super.details,
  });
}

// Validation Exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

// Storage Exceptions
class StorageException extends AppException {
  const StorageException({required super.message, super.code, super.details});
}

// Cache Exceptions
class CacheException extends AppException {
  const CacheException({required super.message, super.code, super.details});
}
