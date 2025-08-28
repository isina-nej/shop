import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// سرویس خواندن فایل‌های JSON ترجمه
class JsonTranslationLoader {
  static final Map<String, Map<String, String>> _cachedTranslations = {};

  /// بارگذاری ترجمه‌ها از فایل JSON
  static Future<Map<String, String>> loadTranslations(
    String languageCode,
  ) async {
    // بررسی کش
    if (_cachedTranslations.containsKey(languageCode)) {
      return _cachedTranslations[languageCode]!;
    }

    try {
      // خواندن فایل JSON از assets
      String jsonString = await rootBundle.loadString(
        'assets/translations/$languageCode.json',
      );

      // پارس کردن JSON
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      // تبدیل به Map<String, String>
      Map<String, String> translations = {};
      jsonMap.forEach((key, value) {
        translations[key] = value.toString();
      });

      // ذخیره در کش
      _cachedTranslations[languageCode] = translations;

      return translations;
    } catch (e) {
      // در محیط Debug خطا را نمایش دهید
      if (kDebugMode) {
        debugPrint('Error loading translations for $languageCode: $e');
      }
      return {};
    }
  }

  /// پاک کردن کش ترجمه‌ها
  static void clearCache() {
    _cachedTranslations.clear();
  }

  /// بررسی وجود فایل ترجمه برای زبان
  static Future<bool> hasTranslation(String languageCode) async {
    try {
      await rootBundle.loadString('assets/translations/$languageCode.json');
      return true;
    } catch (e) {
      return false;
    }
  }
}
