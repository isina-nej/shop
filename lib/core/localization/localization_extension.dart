import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_manager.dart';
import 'app_localizations.dart';

/// Extension برای دسترسی آسان به ترجمه‌ها
extension LocalizationExtension on BuildContext {
  /// دریافت متن ترجمه شده
  String tr(String key) {
    final languageManager = Provider.of<LanguageManager>(this, listen: false);
    return AppLocalizations.translate(key, languageManager.locale.languageCode);
  }

  /// دریافت زبان فعلی
  LanguageManager get languageManager =>
      Provider.of<LanguageManager>(this, listen: false);

  /// دریافت جهت متن
  TextDirection get textDirection =>
      Provider.of<LanguageManager>(this, listen: false).textDirection;

  /// بررسی زبان فارسی
  bool get isFarsi => Provider.of<LanguageManager>(this, listen: false).isFarsi;

  /// بررسی زبان انگلیسی
  bool get isEnglish =>
      Provider.of<LanguageManager>(this, listen: false).isEnglish;

  /// بررسی زبان عربی
  bool get isArabic =>
      Provider.of<LanguageManager>(this, listen: false).isArabic;

  /// بررسی زبان روسی
  bool get isRussian =>
      Provider.of<LanguageManager>(this, listen: false).isRussian;

  /// بررسی زبان چینی
  bool get isChinese =>
      Provider.of<LanguageManager>(this, listen: false).isChinese;
}
