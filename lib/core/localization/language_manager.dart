import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// کلاس مدیریت زبان اپلیکیشن
class LanguageManager extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  static const String _countryKey = 'country_code';

  late Locale _locale;

  Locale get locale => _locale;

  bool get isFarsi => _locale.languageCode == 'fa';
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isArabic => _locale.languageCode == 'ar';
  bool get isRussian => _locale.languageCode == 'ru';
  bool get isChinese => _locale.languageCode == 'zh';

  /// جهت متن بر اساس زبان
  TextDirection get textDirection =>
      _locale.languageCode == 'fa' || _locale.languageCode == 'ar'
      ? TextDirection.rtl
      : TextDirection.ltr;

  /// فونت فعلی براساس زبان
  String get fontFamily => isEnglish ? 'Poppins' : 'IranSansX';

  /// نام زبان فعلی
  String get languageName {
    switch (_locale.languageCode) {
      case 'fa':
        return 'فارسی';
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      default:
        return 'English';
    }
  }

  /// آیکون زبان فعلی
  String get languageFlag {
    switch (_locale.languageCode) {
      case 'fa':
        return '🇮🇷';
      case 'en':
        return '🇺🇸';
      case 'ar':
        return '🇸🇦';
      case 'ru':
        return '🇷🇺';
      case 'zh':
        return '🇨🇳';
      default:
        return '🇺🇸';
    }
  }

  /// چک کردن پشتیبانی از زبان
  bool isLanguageSupported(String languageCode) {
    return supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
  }

  /// تنظیم زبان بر اساس زبان دستگاه
  Locale getDeviceLanguage(Locale deviceLocale) {
    // اگر زبان دستگاه پشتیبانی می‌شود، از آن استفاده کن
    if (isLanguageSupported(deviceLocale.languageCode)) {
      // پیدا کردن تنظیمات کشور مناسب از لیست زبان‌های پشتیبانی شده
      final supportedLocale = supportedLocales.firstWhere(
        (locale) => locale.languageCode == deviceLocale.languageCode,
      );
      return supportedLocale;
    }
    // در غیر این صورت از انگلیسی استفاده کن
    return const Locale('en', 'US');
  }

  /// بارگذاری تنظیمات زبان از SharedPreferences
  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

      // اگر زبان قبلاً تنظیم نشده است
      if (!prefs.containsKey(_languageKey)) {
        _locale = getDeviceLanguage(deviceLocale);
        await saveLanguage();
      } else {
        // استفاده از تنظیمات ذخیره شده
        final languageCode = prefs.getString(_languageKey)!;
        final countryCode = prefs.getString(_countryKey);
        _locale = Locale(languageCode, countryCode ?? '');
      }

      notifyListeners();
    } catch (e) {
      // در صورت بروز خطا، از زبان دستگاه یا انگلیسی استفاده کن
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      _locale = getDeviceLanguage(deviceLocale);
      debugPrint('Error loading language: $e');
    }
  }

  /// ذخیره تنظیمات زبان در SharedPreferences
  Future<void> saveLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, _locale.languageCode);
      await prefs.setString(_countryKey, _locale.countryCode ?? '');
      debugPrint('Language saved: ${_locale.languageCode}');
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  /// تغییر به زبان فارسی
  Future<void> setFarsi() async {
    _locale = const Locale('fa', 'IR');
    notifyListeners();
    await saveLanguage();
  }

  /// تغییر به زبان انگلیسی
  Future<void> setEnglish() async {
    _locale = const Locale('en', 'US');
    notifyListeners();
    await saveLanguage();
  }

  /// تغییر به زبان عربی
  Future<void> setArabic() async {
    _locale = const Locale('ar', 'SA');
    notifyListeners();
    await saveLanguage();
  }

  /// تغییر به زبان روسی
  Future<void> setRussian() async {
    _locale = const Locale('ru', 'RU');
    notifyListeners();
    await saveLanguage();
  }

  /// تغییر به زبان چینی
  Future<void> setChinese() async {
    _locale = const Locale('zh', 'CN');
    notifyListeners();
    await saveLanguage();
  }

  /// تغییر به زبان بعدی
  Future<void> toggleLanguage() async {
    switch (_locale.languageCode) {
      case 'fa':
        await setEnglish();
        break;
      case 'en':
        await setArabic();
        break;
      case 'ar':
        await setRussian();
        break;
      case 'ru':
        await setChinese();
        break;
      case 'zh':
        await setFarsi();
        break;
      default:
        await setFarsi();
    }
  }

  /// زبان‌های پشتیبانی شده
  static const List<Locale> supportedLocales = [
    Locale('fa', 'IR'), // فارسی
    Locale('en', 'US'), // انگلیسی
    Locale('ar', 'SA'), // عربی
    Locale('ru', 'RU'), // روسی
    Locale('zh', 'CN'), // چینی
  ];
}
