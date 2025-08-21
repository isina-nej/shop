import 'json_loader.dart';

/// کلاس ترجمه‌های اپلیکیشن
class AppLocalizations {
  static final Map<String, Map<String, String>> _cachedTranslations = {};

  /// بارگذاری ترجمه‌ها برای زبان مشخص
  static Future<void> _loadTranslations(String languageCode) async {
    if (!_cachedTranslations.containsKey(languageCode)) {
      final translations = await JsonTranslationLoader.loadTranslations(
        languageCode,
      );
      _cachedTranslations[languageCode] = translations;
    }
  }

  /// ترجمه کلید به زبان مشخص
  static Future<String> translateAsync(String key, String languageCode) async {
    await _loadTranslations(languageCode);
    return _cachedTranslations[languageCode]?[key] ?? key;
  }

  /// ترجمه سینک (از کش)
  static String translate(String key, String languageCode) {
    return _cachedTranslations[languageCode]?[key] ?? key;
  }

  /// دریافت ترجمه برای کلید
  static String get(String key, String languageCode) {
    return translate(key, languageCode);
  }

  /// پیش‌بارگذاری ترجمه‌ها برای زبان
  static Future<void> preloadTranslations(String languageCode) async {
    await _loadTranslations(languageCode);
  }

  /// پیش‌بارگذاری همه زبان‌های پشتیبانی شده
  static Future<void> preloadAllTranslations() async {
    final languages = ['fa', 'en', 'ar', 'ru', 'zh'];
    for (String lang in languages) {
      await _loadTranslations(lang);
    }
  }

  /// پاک کردن کش ترجمه‌ها
  static void clearCache() {
    _cachedTranslations.clear();
    JsonTranslationLoader.clearCache();
  }
}
