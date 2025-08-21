// Localization Configuration
import 'package:flutter/material.dart';

class AppLocalizations {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('fa', 'IR'), // Persian/Farsi
    Locale('ar', 'SA'), // Arabic
  ];

  static const String translationsPath = 'assets/translations';

  static const Locale fallbackLocale = Locale('en', 'US');
}

// Language Model
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool isRTL;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.isRTL,
  });

  static const List<Language> availableLanguages = [
    Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
      isRTL: false,
    ),
    Language(
      code: 'fa',
      name: 'Persian',
      nativeName: 'فارسی',
      flag: '🇮🇷',
      isRTL: true,
    ),
    Language(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
      isRTL: true,
    ),
  ];

  static Language getLanguageByCode(String code) {
    return availableLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => availableLanguages.first,
    );
  }
}
