# راهنمای استفاده از سیستم ترجمه JSON

## نحوه کارکرد

سیستم ترجمه حالا از فایل‌های JSON استفاده می‌کند که در پوشه `assets/translations/` قرار دارند.

## فایل‌های مهم

### 1. `json_loader.dart`
- بارگذاری فایل‌های JSON از assets
- کش کردن ترجمه‌ها برای بهبود عملکرد
- مدیریت خطاها

### 2. `app_localizations.dart` 
- کلاس اصلی ترجمه‌ها
- متدهای سینک و async برای دریافت ترجمه
- پیش‌بارگذاری ترجمه‌ها

### 3. `translation_manager.dart`
- مدیریت پیشرفته ترجمه‌ها
- مقداردهی اولیه خودکار
- تغییر زبان

### 4. `language_manager.dart` (به‌روزرسانی شده)
- یکپارچگی با TranslationManager
- بارگذاری خودکار ترجمه‌ها هنگام تغییر زبان

### 5. `localization_extension.dart`
- Extension برای استفاده آسان در Widget ها
- متدهای `tr()` و `trAsync()`

## فایل‌های JSON

فایل‌های ترجمه در `assets/translations/` قرار دارند:
- `fa.json` - فارسی
- `en.json` - انگلیسی
- `ar.json` - عربی (در صورت نیاز)
- `ru.json` - روسی (در صورت نیاز)
- `zh.json` - چینی (در صورت نیاز)

## نحوه استفاده

### 1. در Widget ها

```dart
import '../../core/localization/localization_extension.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // استفاده سینک
        Text(context.tr('welcome')),
        
        // استفاده async برای بارگذاری اولیه
        FutureBuilder<String>(
          future: context.trAsync('loading'),
          builder: (context, snapshot) {
            return Text(snapshot.data ?? 'loading...');
          },
        ),
      ],
    );
  }
}
```

### 2. مقداردهی اولیه در main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // بارگذاری زبان
  final languageManager = LanguageManager();
  await languageManager.loadLanguage(); // این خودکار TranslationManager را نیز مقداردهی می‌کند
  
  runApp(MyApp());
}
```

### 3. تغییر زبان

```dart
// تغییر زبان خودکار ترجمه‌ها را بارگذاری می‌کند
await languageManager.setFarsi();
await languageManager.setEnglish();
```

## مزایای استفاده از فایل‌های JSON

1. **جدایی محتوا از کد**: متن‌ها در فایل‌های جداگانه
2. **سهولت ویرایش**: ویرایش آسان بدون نیاز به تغییر کد
3. **قابلیت توسعه**: افزودن زبان‌های جدید با ایجاد فایل JSON جدید
4. **مدیریت بهتر**: کد تمیزتر و سازمان‌یافته‌تر
5. **کش کردن**: بهبود عملکرد با کش کردن ترجمه‌ها
6. **مدیریت خطا**: مدیریت مناسب در صورت عدم وجود فایل یا کلید

## نکات مهم

1. فایل‌های JSON باید در `pubspec.yaml` در بخش assets تعریف شوند
2. هنگام افزودن کلید جدید، باید در همه فایل‌های زبان اضافه شود
3. از متد `tr()` برای استفاده معمول و `trAsync()` برای بارگذاری اولیه استفاده کنید
4. سیستم خودکار از کش استفاده می‌کند برای بهبود عملکرد

## تست

فایل `translation_test_page.dart` برای تست عملکرد سیستم ترجمه ایجاد شده است.

## نحوه افزودن کلید جدید

1. کلید را در تمام فایل‌های JSON (fa.json, en.json, ...) اضافه کنید
2. از `context.tr('new_key')` برای استفاده کنید
3. تست کنید که در همه زبان‌ها درست کار می‌کند
