.\deploy-web.bat


# 🚀 Flutter Web Deployment Guide

این راهنما نحوه دیپلویمنت خودکار پروژه Flutter به Vercel را توضیح می‌دهد.

## 📁 فایل‌های موجود

- `deploy-web.ps1` - اسکریپت کامل PowerShell (توصیه شده برای Windows)
- `deploy-web.bat` - اسکریپت ساده Batch برای Windows  
- `deploy-web.sh` - اسکریپت Bash برای Linux/Mac
- `deploy-config.env` - فایل تنظیمات
- `.github/workflows/deploy-web.yml` - GitHub Actions برای خودکارسازی
- `vercel.json` - تنظیمات Vercel
- `package.json` - اسکریپت‌های npm

## 🔧 مرحله اول: تنظیم ریپوزیتوری وب

### روش دستی
1. یک ریپوزیتوری جدید در GitHub بسازید (مثلاً `shop-web`)
2. فایل `deploy-config.env` را ویرایش کنید و URL ریپوزیتوری را وارد کنید

### روش خودکار (GitHub Actions)
1. یک ریپوزیتوری جدید در GitHub بسازید (مثلاً `shop-web`)
2. در ریپوزیتوری اصلی، به Settings > Secrets and variables > Actions بروید
3. یک Personal Access Token بسازید:
   - GitHub > Settings > Developer settings > Personal access tokens
   - Generate new token (classic)
   - دسترسی‌های لازم: `repo`, `workflow`
4. Secret جدید اضافه کنید:
   - Name: `WEB_DEPLOY_TOKEN`
   - Value: توکن ساخته شده
5. فایل `.github/workflows/deploy-web.yml` را ویرایش کنید و نام ریپوزیتوری وب را تغییر دهید

## نحوه استفاده

### ویندوز (PowerShell) - روش توصیه شده

```powershell
# اجرای اسکریپت کامل
.\deploy-web.ps1

# اجرای با مسیر سفارشی
.\deploy-web.ps1 -WebRepoPath "d:\my-custom-path\shop-web"

# اجرای با پیام کامیت سفارشی
.\deploy-web.ps1 -CommitMessage "Updated homepage design"
```

### ویندوز (Batch)

```cmd
deploy-web.bat
```

### Linux/Mac (Bash)

```bash
chmod +x deploy-web.sh
./deploy-web.sh
```

## آنچه اسکریپت انجام می‌دهد

1. 🧹 **پاکسازی**: بیلد قبلی را پاک می‌کند
2. 🔨 **بیلد**: پروژه Flutter را برای وب بیلد می‌کند
3. 📁 **تنظیم**: ریپوزیتوری وب را آماده می‌کند
4. 📋 **کپی**: فایل‌های بیلد شده را کپی می‌کند
5. 🔄 **کامیت**: تغییرات را کامیت و پوش می‌کند

## تنظیم Vercel

بعد از اولین اجرای موفقیت‌آمیز اسکریپت:

1. به [vercel.com](https://vercel.com) بروید
2. ریپوزیتوری وب خود را وصل کنید
3. تنظیمات زیر را اعمال کنید:
   - **Framework Preset**: Other
   - **Build Command**: (خالی بگذارید یا `echo "Static site"`)
   - **Output Directory**: `./`
   - **Install Command**: (خالی بگذارید)

## خودکارسازی

### GitHub Actions

برای خودکارسازی کامل، می‌توانید از GitHub Actions استفاده کنید:

```yaml
# .github/workflows/deploy-web.yml
name: Deploy Web Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
    
    - name: Build Web
      run: flutter build web --release
    
    - name: Deploy to Web Repo
      run: |
        git clone https://github.com/isina-nej/shop-web.git web-repo
        cd web-repo
        rm -rf * .[^.]*
        cp -r ../build/web/* .
        git add .
        git commit -m "Auto deploy - $(date)"
        git push
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## نکات مفید

- اسکریپت خودکار ریپوزیتوری وب را می‌سازد اگر وجود نداشته باشد
- فایل‌های مهم مثل `.git` و `README.md` را حفظ می‌کند
- قبل از هر دیپلویمنت، بیلد قبلی را پاک می‌کند
- اگر تغییری وجود نداشته باشد، کامیت جدیدی ایجاد نمی‌کند

## عیب‌یابی

### خطای "git command not found"
Git را نصب کنید و مطمئن شوید که در PATH سیستم قرار دارد.

### خطای "flutter command not found"
Flutter SDK را نصب کنید و به PATH اضافه کنید.

### خطای "Permission denied"
در Linux/Mac:
```bash
chmod +x deploy-web.sh
```

### ریپوزیتوری remote ندارد
```bash
cd d:\project\SinaShop\shop-web
git remote add origin https://github.com/isina-nej/shop-web.git
git push -u origin main
```

## پشتیبانی

برای مشکلات و سوالات، issue ایجاد کنید یا با تیم توسعه تماس بگیرید.

---

**نکته**: قبل از اولین استفاده، حتماً فایل `deploy-config.env` را مطابق تنظیمات خود ویرایش کنید.
