// Language Controller using GetX
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translation_manager.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'language_code';
  static const String _countryKey = 'country_code';

  var locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  bool get isFarsi => locale.value.languageCode == 'fa';
  bool get isEnglish => locale.value.languageCode == 'en';
  bool get isArabic => locale.value.languageCode == 'ar';
  bool get isRussian => locale.value.languageCode == 'ru';
  bool get isChinese => locale.value.languageCode == 'zh';

  TextDirection get textDirection =>
      locale.value.languageCode == 'fa' || locale.value.languageCode == 'ar'
      ? TextDirection.rtl
      : TextDirection.ltr;

  String get fontFamily => isEnglish ? 'Poppins' : 'IranSansX';

  String get languageName {
    switch (locale.value.languageCode) {
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

  String get languageFlag {
    switch (locale.value.languageCode) {
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

  bool isLanguageSupported(String languageCode) {
    return supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
  }

  Locale getDeviceLanguage(Locale deviceLocale) {
    if (isLanguageSupported(deviceLocale.languageCode)) {
      final supportedLocale = supportedLocales.firstWhere(
        (locale) => locale.languageCode == deviceLocale.languageCode,
      );
      return supportedLocale;
    }
    return const Locale('en', 'US');
  }

  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

      if (!prefs.containsKey(_languageKey)) {
        locale.value = getDeviceLanguage(deviceLocale);
        await saveLanguage();
      } else {
        final languageCode = prefs.getString(_languageKey)!;
        final countryCode = prefs.getString(_countryKey);
        locale.value = Locale(languageCode, countryCode ?? '');
      }

      await TranslationManager.instance.initialize(
        defaultLanguage: locale.value.languageCode,
      );

      update();
    } catch (e) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      locale.value = getDeviceLanguage(deviceLocale);
      debugPrint('Error loading language: $e');

      try {
        await TranslationManager.instance.initialize(
          defaultLanguage: locale.value.languageCode,
        );
      } catch (e) {
        debugPrint('Error initializing TranslationManager: $e');
      }
    }
  }

  Future<void> saveLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.value.languageCode);
      await prefs.setString(_countryKey, locale.value.countryCode ?? '');
      debugPrint('Language saved: ${locale.value.languageCode}');
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  Future<void> setFarsi() async {
    locale.value = const Locale('fa', 'IR');
    await TranslationManager.instance.changeLanguage('fa');
    update();
    await saveLanguage();
  }

  Future<void> setEnglish() async {
    locale.value = const Locale('en', 'US');
    await TranslationManager.instance.changeLanguage('en');
    update();
    await saveLanguage();
  }

  Future<void> setArabic() async {
    locale.value = const Locale('ar', 'SA');
    await TranslationManager.instance.changeLanguage('ar');
    update();
    await saveLanguage();
  }

  Future<void> setRussian() async {
    locale.value = const Locale('ru', 'RU');
    await TranslationManager.instance.changeLanguage('ru');
    update();
    await saveLanguage();
  }

  Future<void> setChinese() async {
    locale.value = const Locale('zh', 'CN');
    await TranslationManager.instance.changeLanguage('zh');
    update();
    await saveLanguage();
  }

  Future<void> toggleLanguage() async {
    switch (locale.value.languageCode) {
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

  static const List<Locale> supportedLocales = [
    Locale('fa', 'IR'),
    Locale('en', 'US'),
    Locale('ar', 'SA'),
    Locale('ru', 'RU'),
    Locale('zh', 'CN'),
  ];
}
