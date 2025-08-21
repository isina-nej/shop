import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// کلاس مدیریت پیشرفته ترجمه‌ها
class TranslationManager {
  static TranslationManager? _instance;
  static TranslationManager get instance =>
      _instance ??= TranslationManager._();

  TranslationManager._();

  bool _isInitialized = false;
  String _currentLanguage = 'fa';

  /// مقداردهی اولیه
  Future<void> initialize({String defaultLanguage = 'fa'}) async {
    if (_isInitialized) return;

    _currentLanguage = defaultLanguage;

    // پیش‌بارگذاری زبان پیش‌فرض
    await AppLocalizations.preloadTranslations(_currentLanguage);

    _isInitialized = true;
  }

  /// تغییر زبان
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLanguage == languageCode) return;

    _currentLanguage = languageCode;

    // بارگذاری ترجمه‌های زبان جدید
    await AppLocalizations.preloadTranslations(languageCode);
  }

  /// دریافت ترجمه
  String translate(String key) {
    if (!_isInitialized) {
      debugPrint(
        'TranslationManager not initialized. Call initialize() first.',
      );
      return key;
    }

    return AppLocalizations.translate(key, _currentLanguage);
  }

  /// دریافت ترجمه async
  Future<String> translateAsync(String key) async {
    if (!_isInitialized) {
      await initialize();
    }

    return await AppLocalizations.translateAsync(key, _currentLanguage);
  }

  /// بررسی وجود ترجمه برای کلید
  bool hasTranslation(String key) {
    return AppLocalizations.translate(key, _currentLanguage) != key;
  }

  /// دریافت زبان فعلی
  String get currentLanguage => _currentLanguage;

  /// بررسی مقداردهی اولیه
  bool get isInitialized => _isInitialized;

  /// پاک کردن کش
  void clearCache() {
    AppLocalizations.clearCache();
    _isInitialized = false;
  }
}
