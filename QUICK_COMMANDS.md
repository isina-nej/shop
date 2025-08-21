# 📋 Quick Commands Reference

## 🚀 Deployment Commands

```batch
# تست سیستم
.\test-deployment.bat

# دیپلویمنت سریع (Windows)
.\deploy-web.bat

# دیپلویمنت با PowerShell
.\deploy-web.ps1

# دیپلویمنت به مسیر سفارشی
.\deploy-web.ps1 -WebRepoPath "d:\custom\path"

# دیپلویمنت با پیام سفارشی
.\deploy-web.ps1 -CommitMessage "Updated homepage design"
```

## 🛠️ Development Commands

```batch
# بیلد برای production
flutter build web --release

# بیلد برای development
flutter build web --debug

# بیلد با renderer مشخص
flutter build web --web-renderer canvaskit

# سرو local (Python)
cd build\web && python -m http.server 8000

# سرو local (Node.js)
cd build\web && npx serve -s . -p 8000
```

## 📦 NPM Scripts

```batch
# نصب dependencies
npm install

# بیلد production
npm run build

# بیلد development  
npm run build:dev

# سرو local
npm run serve

# دیپلویمنت local
npm run deploy:local

# تست دیپلویمنت
npm run deploy:test

# پاکسازی
npm run clean
```

## 🔧 Git Commands

```batch
# تنظیم remote برای ریپوزیتوری وب
cd d:\project\SinaShop\shop-web
git remote add origin https://github.com/username/shop-web.git
git push -u origin main

# چک کردن وضعیت
git status

# مشاهده history
git log --oneline

# بازگشت به commit قبلی
git reset --hard HEAD~1
```

## 🌐 Vercel Commands

```batch
# نصب Vercel CLI
npm i -g vercel

# لاگین
vercel login

# دیپلویمنت دستی
cd d:\project\SinaShop\shop-web
vercel

# دیپلویمنت production
vercel --prod

# مشاهده لاگ‌ها
vercel logs
```

## 🧪 Testing Commands

```batch
# تست Flutter
flutter test

# تست web build
flutter build web --debug
start build\web\index.html

# چک کردن performance
flutter build web --release --analyze-size

# پروفایل performance
flutter build web --profile
```

## 🔍 Debugging Commands

```batch
# مشاهده Flutter doctor
flutter doctor

# پاکسازی کامل
flutter clean
flutter pub get

# مشاهده dependency tree
flutter pub deps

# آپدیت dependencies
flutter pub upgrade

# چک کردن outdated packages
flutter pub outdated
```

## 📊 Monitoring Commands

```batch
# مشاهده اندازه build
dir build\web /s

# آنالیز bundle size
flutter build web --analyze-size --target-platform web-javascript

# مشاهده memory usage در حین build
flutter build web --verbose

# چک کردن وضعیت git repository
git status --short
git log --oneline -5
```

## 🔐 Security Commands

```batch
# چک کردن vulnerabilities
flutter pub audit

# آپدیت security patches
flutter upgrade

# مشاهده permissions
flutter analyze

# تست security headers
curl -I https://your-deployed-site.vercel.app
```

---

💡 **نکته**: همیشه قبل از دیپلویمنت production، ابتدا تست کنید:
```batch
.\test-deployment.bat
```
