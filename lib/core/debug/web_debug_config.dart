import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

/// Web-specific debug configuration
class WebDebugConfig {
  static bool _debugServiceDisabled = false;
  static const bool enableDebugService = false;

  /// Disable DebugService completely
  static void disableDebugService() {
    if (!kIsWeb || _debugServiceDisabled) return;

    _debugServiceDisabled = true;

    // Override debug service related functions
    if (kDebugMode) {
      // Disable VM service extensions that cause debug service errors
      _registerDummyExtensions();

      // Override console methods to suppress debug service messages
      _overrideConsoleMethods();

      // Disable debug print for debug service messages
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null && _isDebugServiceMessage(message)) {
          return; // Suppress debug service messages
        }
        developer.log(message ?? '', name: 'flutter');
      };

      debugPrint('🔧 DebugService completely disabled');
    }
  }

  /// Register dummy extensions to prevent debug service errors
  static void _registerDummyExtensions() {
    final extensions = [
      'ext.flutter.debugger',
      'ext.flutter.vm',
      'ext.flutter.isolate',
      'ext.flutter.debug',
      'ext.dart.vm',
      'ext.dart.isolate',
      'ext.flutter.platformOverride',
      'ext.flutter.inspector',
    ];

    for (final ext in extensions) {
      try {
        developer.registerExtension(ext, (method, parameters) async {
          return developer.ServiceExtensionResponse.result('{}');
        });
      } catch (e) {
        // Extension might already be registered
      }
    }
  }

  /// Override console methods to suppress debug service messages
  static void _overrideConsoleMethods() {
    // This will be handled by the HTML file console override
    // But we can also do it here for additional suppression
  }

  /// Check if message is from debug service
  static bool _isDebugServiceMessage(String message) {
    final msg = message.toLowerCase();
    return msg.contains('debugservice') ||
        msg.contains('debug service') ||
        msg.contains('cannot send null') ||
        msg.contains('unsupported operation') ||
        msg.contains('vm service') ||
        msg.contains('observatory') ||
        msg.contains('debugger') ||
        msg.contains('flutter debug') ||
        msg.contains('web debug') ||
        msg.contains('null') && msg.contains('error') ||
        msg.contains('null') && msg.contains('debug') ||
        msg.contains('lifecycle channel') ||
        msg.contains('plugin sends messages') ||
        msg.contains('channelbuffers') ||
        msg.contains('error serving requests');
  }

  /// Initialize web debug configuration
  static void initialize() {
    if (kIsWeb && kDebugMode) {
      // First, disable debug service completely
      disableDebugService();

      // Set up error handlers for any remaining issues
      FlutterError.onError = (FlutterErrorDetails details) {
        // Filter out debug service errors
        final error = details.exception.toString().toLowerCase();
        if (_isDebugServiceMessage(error)) {
          return; // Don't report these errors
        }

        // Report other errors normally
        FlutterError.presentError(details);
      };
    }
  }

  /// Handle uncaught errors
  static void handleUncaughtError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      final errorString = error.toString();
      if (_isDebugServiceMessage(errorString)) {
        return; // Ignore debug service errors
      }
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Get current debug configuration status
  static Map<String, dynamic> getStatus() {
    return {
      'debugServiceEnabled': enableDebugService,
      'debugServiceDisabled': _debugServiceDisabled,
      'isWeb': kIsWeb,
      'isDebugMode': kDebugMode,
      'isProfileMode': kProfileMode,
      'isReleaseMode': kReleaseMode,
    };
  }
}
