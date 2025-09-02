# 🛍️ SinaShop - Flutter E-commerce App

یک اپلیکیشن فروشگاهی کامل با Flutter که برای وب، موبایل و دسکتاپ طراحی شده است.

## ✨ ویژگی‌ها

- 🌐 چندپلتفرمه (Web, Android, iOS, Desktop)
- 🌍 پشتیبانی از چند زبان (فارسی/انگلیسی)
- 🛒 سیستم سبد خرید کامل
- 👤 مدیریت حساب کاربری
- 📱 طراحی ریسپانسیو
- 🎨 تم‌های متعدد
- 📦 مدیریت محصولات
- 💳 سیستم پرداخت
- 🚀 عملکرد بالا

## 🚀 دیپلویمنت وب

### دیپلویمنت سریع
```bash
# ویندوز
.\deploy-web.bat

# PowerShell  
.\deploy-web.ps1

# Linux/Mac
./deploy-web.sh
```

### دیپلویمنت خودکار
این پروژه از GitHub Actions برای دیپلویمنت خودکار به Vercel استفاده می‌کند.

📖 **راهنمای کامل**: [WEB_DEPLOYMENT_GUIDE.md](WEB_DEPLOYMENT_GUIDE.md)  
⚡ **دستورات سریع**: [QUICK_COMMANDS.md](QUICK_COMMANDS.md)

## 🛠️ شروع کار

### پیش‌نیازها
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (نسخه 3.24.0+)
- [Git](https://git-scm.com/downloads)
- [Node.js](https://nodejs.org/) (اختیاری، برای ابزارهای اضافی)

### نصب
```bash
# کلون کردن پروژه
git clone https://github.com/your-username/shop.git
cd shop

# نصب dependencies
flutter pub get

# اجرا (موبایل/دسکتاپ)
flutter run

# اجرا (وب) - حالت‌های مختلف

## 🎯 اجرای وب (با حل کامل مشکل DebugService)

### ✅ حالت Release (توصیه شده - بدون خطا)
```bash
# PowerShell
.\run-web-release.ps1

# یا مستقیم
flutter run -d chrome --release
```
🚫 **DebugService کاملاً غیرفعال** - هیچ خطایی نمایش داده نمی‌شود

### ✅ حالت Profile (بدون خطا، بدون Hot Reload)
```bash
# PowerShell
.\run-web-profile.ps1

# یا مستقیم
flutter run -d chrome --profile
```
🚫 **بدون خطای DebugService** - عملکرد بهینه

### ✅ حالت Debug با DebugService غیرفعال (جدید!)
```bash
# PowerShell - حالت جدید با فلگ‌های کامپایل
.\run-web-debug-no-service.ps1

# یا حالت قدیمی با فیلترینگ
.\run-web-clean.ps1

# یا مستقیم
flutter run -d chrome
```
🚫 **DebugService کاملاً غیرفعال در حالت Debug** - Hot Reload فعال

### ✅ حالت کاملاً پاک (بدون هیچ DebugService)
```bash
# PowerShell
.\run-web-no-debug.ps1
```
🚫 **کاملاً پاک** - هیچ اثری از DebugService

### 📋 راهنما:
- **Release**: کاملاً پاک، بدون خطا (برای تست نهایی)
- **Profile**: پاک، بهینه (برای تست بدون Hot Reload)
- **Debug با فلگ‌ها**: پاک با Hot Reload (توصیه شده برای توسعه)
- **کاملاً پاک**: بدون هیچ گونه DebugService (برای تست‌های خاص)
```

### بیلد
```bash
# بیلد برای وب
flutter build web --release

# بیلد برای Android
flutter build apk --release

# بیلد برای iOS
flutter build ios --release
```

## 📁 ساختار پروژه

```
lib/
├── core/           # هسته اصلی برنامه
│   ├── constants/  # ثابت‌ها
│   ├── data/       # داده‌های mock
│   ├── models/     # مدل‌های داده
│   ├── network/    # شبکه و API
│   ├── routing/    # مسیریابی
│   └── theme/      # تم‌ها
├── features/       # ویژگی‌های برنامه
│   ├── home/       # صفحه اصلی
│   ├── products/   # محصولات
│   ├── cart/       # سبد خرید
│   ├── auth/       # احراز هویت
│   └── profile/    # پروفایل کاربر
├── shared/         # کامپوننت‌های مشترک
│   ├── widgets/    # ویجت‌های مشترک
│   └── services/   # سرویس‌ها
└── l10n/           # چندزبانگی
```

## 🌐 لینک‌های مفید

- 🌍 **وب‌سایت**: [https://shop-web.vercel.app](https://shop-web.vercel.app)
- 📱 **Android**: [Download APK](releases/latest)
- 🍎 **iOS**: [App Store](#)
- 💻 **Desktop**: [Download](#)

## 🧪 تست

```bash
# تست واحد
flutter test

# تست integration
flutter test integration_test/

# تست widget
flutter test test/widget_test.dart

# تست دیپلویمنت
.\test-deployment.bat
```

## 🤝 مشارکت

1. Fork کنید
2. برنچ جدید بسازید (`git checkout -b feature/amazing-feature`)
3. تغییرات را commit کنید (`git commit -m 'Add amazing feature'`)
4. برنچ را push کنید (`git push origin feature/amazing-feature`)
5. Pull Request باز کنید

## 📄 لایسنس

این پروژه تحت لایسنس MIT منتشر شده است. فایل [LICENSE](LICENSE) را مشاهده کنید.

## 📞 تماس

- 👨‍💻 **توسعه‌دهنده**: Your Name
- 📧 **ایمیل**: your.email@example.com
- 🐦 **توییتر**: [@yourusername](https://twitter.com/yourusername)
- 💼 **LinkedIn**: [Your Profile](https://linkedin.com/in/yourprofile)

---

⭐ اگر این پروژه برایتان مفید بود، یک ستاره بدهید!
