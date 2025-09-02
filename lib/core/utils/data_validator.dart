import 'package:flutter/foundation.dart';

/// Utility class for data validation to prevent null-related errors
class DataValidator {
  /// Validate and clean data before sending to prevent null errors
  static Map<String, dynamic> cleanData(Map<String, dynamic> data) {
    final cleanedData = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      // Skip null values unless they are explicitly allowed
      if (value != null) {
        cleanedData[key] = value;
      } else if (kDebugMode) {
        debugPrint('Warning: Null value found for key "$key" - skipping');
      }
    }

    return cleanedData;
  }

  /// Validate required fields and provide defaults
  static Map<String, dynamic> validateRequiredFields(
    Map<String, dynamic> data,
    Map<String, dynamic> requiredDefaults,
  ) {
    final validatedData = Map<String, dynamic>.from(data);

    for (final entry in requiredDefaults.entries) {
      final key = entry.key;
      final defaultValue = entry.value;

      if (validatedData[key] == null) {
        validatedData[key] = defaultValue;
        if (kDebugMode) {
          debugPrint('Applied default value for "$key": $defaultValue');
        }
      }
    }

    return validatedData;
  }

  /// Safe string conversion that never returns null
  static String safeString(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// Safe integer conversion with default
  static int safeInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Safe double conversion with default
  static double safeDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Safe boolean conversion with default
  static bool safeBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value != 0;
    return defaultValue;
  }

  /// Validate email format
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Validate non-empty string
  static bool isValidString(String? value, {int minLength = 1}) {
    if (value == null) return false;
    return value.trim().length >= minLength;
  }
}
