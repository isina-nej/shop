@echo off
REM Quick test script for Flutter web deployment
echo 🧪 Testing Flutter Web Deployment Setup...
echo.

REM Check Flutter
echo 📱 Checking Flutter installation...
flutter --version
if %ERRORLEVEL% neq 0 (
    echo ❌ Flutter not found! Please install Flutter SDK.
    pause
    exit /b 1
)
echo ✅ Flutter is installed

REM Check Git
echo 📦 Checking Git installation...
git --version
if %ERRORLEVEL% neq 0 (
    echo ❌ Git not found! Please install Git.
    pause
    exit /b 1
)
echo ✅ Git is installed

REM Test Flutter build
echo 🔨 Testing Flutter web build...
flutter build web --debug
if %ERRORLEVEL% neq 0 (
    echo ❌ Flutter build failed!
    pause
    exit /b 1
)
echo ✅ Flutter web build successful

REM Check build output
if exist "build\web\index.html" (
    echo ✅ Web build files created successfully
    echo 📊 Build output size:
    dir "build\web" /s /-c | findstr "bytes"
) else (
    echo ❌ Web build files not found!
    pause
    exit /b 1
)

echo.
echo 🎉 All tests passed! Your deployment setup is ready.
echo.
echo 📋 Next steps:
echo 1. Create a GitHub repository for web deployment
echo 2. Run .\deploy-web.bat to deploy
echo 3. Connect the web repository to Vercel
echo.
pause
