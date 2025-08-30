import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'language_controller.dart';
import 'app_localizations.dart';

/// Extension برای دسترسی آسان به ترجمه‌ها
extension LocalizationExtension on BuildContext {
  /// دریافت متن ترجمه شده (سینک)
  String tr(String key) {
    final languageController = Get.find<LanguageController>();
    return AppLocalizations.translate(
      key,
      languageController.locale.value.languageCode,
    );
  }

  /// دریافت متن ترجمه شده (async) - برای بارگذاری اولیه
  Future<String> trAsync(String key) async {
    final languageController = Get.find<LanguageController>();
    return await AppLocalizations.translateAsync(
      key,
      languageController.locale.value.languageCode,
    );
  }

  /// دریافت زبان فعلی
  LanguageController get languageController => Get.find<LanguageController>();

  /// دریافت جهت متن
  TextDirection get textDirection =>
      Get.find<LanguageController>().textDirection;

  /// بررسی زبان فارسی
  bool get isFarsi => Get.find<LanguageController>().isFarsi;

  /// بررسی زبان انگلیسی
  bool get isEnglish => Get.find<LanguageController>().isEnglish;

  /// بررسی زبان عربی
  bool get isArabic => Get.find<LanguageController>().isArabic;

  /// بررسی زبان روسی
  bool get isRussian => Get.find<LanguageController>().isRussian;

  /// بررسی زبان چینی
  bool get isChinese => Get.find<LanguageController>().isChinese;

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
