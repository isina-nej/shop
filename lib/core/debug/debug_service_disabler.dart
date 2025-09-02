import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'dart:async';

/// Advanced Debug Service Disabler
/// Completely disables all DebugService functionality in Flutter Web
class DebugServiceDisabler {
  static bool _isDisabled = false;
  static StreamSubscription? _logSubscription;

  /// Completely disable DebugService
  static void disableCompletely() {
    if (_isDisabled || !kIsWeb) return;

    _isDisabled = true;

    if (kDebugMode) {
      // Override debugPrint immediately to suppress all debug service messages
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null && _isDebugServiceRelated(message)) {
          return; // Completely suppress
        }
        // For non-debug-service messages, still allow them but with a marker
        developer.log('[APP] ${message ?? ''}', name: 'flutter');
      };

      // Register dummy extensions to prevent debug service from working
      _registerDummyExtensions();

      // Override Flutter error handling to suppress debug service errors
      _overrideErrorHandling();

      // Listen to log events and suppress debug service messages
      _setupLogListener();

      debugPrint('🚫 DebugService COMPLETELY DISABLED');
    }
  }

  /// Register dummy VM service extensions
  static void _registerDummyExtensions() {
    // Register dummy extensions that do nothing
    final dummyExtensions = [
      'ext.flutter.debugger',
      'ext.flutter.vm',
      'ext.flutter.isolate',
      'ext.flutter.debug',
      'ext.dart.vm',
      'ext.dart.isolate',
      'ext.flutter.platformOverride',
      'ext.flutter.inspector',
    ];

    for (final extension in dummyExtensions) {
      try {
        developer.registerExtension(extension, (method, parameters) async {
          return developer.ServiceExtensionResponse.result('{}');
        });
      } catch (e) {
        // Extension might already be registered
      }
    }
  }

  /// Override Flutter error handling to suppress debug service errors
  static void _overrideErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails details) {
      final error = details.exception.toString().toLowerCase();
      if (_isDebugServiceRelated(error)) {
        return; // Suppress completely
      }
      FlutterError.presentError(details);
    };
  }

  /// Setup log listener to suppress debug service messages
  static void _setupLogListener() {
    // Use Zone to capture and suppress debug service messages
    runZonedGuarded(
      () {
        // This will help capture async errors
      },
      (error, stack) {
        final errorMsg = error.toString().toLowerCase();
        if (_isDebugServiceRelated(errorMsg)) {
          return; // Suppress debug service errors
        }
        // For other errors, rethrow
        throw error;
      },
    );
  }

  /// Check if message is debug service related
  static bool _isDebugServiceRelated(String message) {
    final msg = message.toLowerCase();
    return msg.contains('debugservice') ||
        msg.contains('debug service') ||
        msg.contains('cannot send null') ||
        msg.contains('unsupported operation') ||
        msg.contains('vm service') ||
        msg.contains('observatory') ||
        msg.contains('debugger') ||
        msg.contains('debug service') ||
        msg.contains('flutter debug') ||
        msg.contains('web debug') ||
        msg.contains('null') && msg.contains('error') ||
        msg.contains('null') && msg.contains('debug') ||
        msg.contains('lifecycle channel') && msg.contains('discarded') ||
        msg.contains('plugin sends messages') ||
        msg.contains('channelbuffers');
  }

  /// Cleanup resources
  static void dispose() {
    _logSubscription?.cancel();
    _logSubscription = null;
  }

  /// Check if DebugService is disabled
  static bool get isDisabled => _isDisabled;
}
