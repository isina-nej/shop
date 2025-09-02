import 'package:flutter/foundation.dart';

/// Debug configuration for handling debug output
class DebugConfig {
  static bool _isInitialized = false;

  /// Initialize debug configuration
  static void initialize() {
    if (!_isInitialized) {
      _isInitialized = true;
      if (kDebugMode) {
        debugPrint('Debug configuration initialized');
      }
    }
  }

  /// Custom print function that filters debug service errors
  static void safePrint(Object? object) {
    if (object != null && kIsWeb && kDebugMode) {
      final message = object.toString();
      // Filter out debug service null errors that spam the console
      if (message.contains('DebugService: Error serving requests') &&
          message.contains('Cannot send Null')) {
        return; // Don't print these errors
      }
    }
    debugPrint(object?.toString());
  }

  /// Log error with context
  static void logError(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      debugPrint('ERROR: $message');
      if (error != null) {
        debugPrint('Error details: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  /// Log warning
  static void logWarning(String message) {
    if (kDebugMode) {
      debugPrint('WARNING: $message');
    }
  }

  /// Log info
  static void logInfo(String message) {
    if (kDebugMode) {
      debugPrint('INFO: $message');
    }
  }
}
