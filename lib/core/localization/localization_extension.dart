import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_manager.dart';
import 'app_localizations.dart';

/// Extension برای دسترسی آسان به ترجمه‌ها
extension LocalizationExtension on BuildContext {
  /// دریافت متن ترجمه شده (سینک)
  String tr(String key) {
    final languageManager = Provider.of<LanguageManager>(this, listen: false);
    return AppLocalizations.translate(key, languageManager.locale.languageCode);
  }

  /// دریافت متن ترجمه شده (async) - برای بارگذاری اولیه
  Future<String> trAsync(String key) async {
    final languageManager = Provider.of<LanguageManager>(this, listen: false);
    return await AppLocalizations.translateAsync(
      key,
      languageManager.locale.languageCode,
    );
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

  /// ترجمه نوع حساب کاربری
  String translateAccountType(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'basic':
        return tr('account_type_basic');
      case 'premium':
        return tr('account_type_premium');
      case 'vip':
        return tr('account_type_vip');
      default:
        return accountType; // fallback to original if not found
    }
  }

  /// ترجمه وضعیت حساب
  String translateAccountStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return tr('account_status_active');
      case 'suspended':
        return tr('account_status_suspended');
      case 'pending':
        return tr('account_status_pending');
      default:
        return status; // fallback to original if not found
    }
  }
}
