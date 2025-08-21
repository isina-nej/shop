@echo off
REM Flutter Web Deployment Script for Windows
REM Simple version for quick deployment

setlocal enabledelayedexpansion

REM Configuration
set "WEB_REPO_PATH=d:\project\SinaShop\shop-web"
set "PROJECT_PATH=d:\project\SinaShop\shop"

echo 🚀 Starting Flutter Web Deployment...
echo.

REM Build Flutter web
echo 📦 Building Flutter for web...
cd /d "%PROJECT_PATH%"
call flutter build web --release

if !ERRORLEVEL! neq 0 (
    echo ❌ Build failed!
    pause
    exit /b 1
)

echo ✅ Build completed successfully!
echo.

REM Check/Create web repository
if not exist "%WEB_REPO_PATH%" (
    echo 📁 Creating web repository...
    mkdir "%WEB_REPO_PATH%"
    cd /d "%WEB_REPO_PATH%"
    git init
    echo # SinaShop Web Build > README.md
    git add README.md
    git commit -m "Initial commit"
    echo.
    echo ⚠️  Please add remote origin:
    echo git remote add origin ^<your-web-repo-url^>
    echo.
) else (
    echo 📁 Web repository exists
    cd /d "%WEB_REPO_PATH%"
    git pull
)

REM Copy files (exclude .git and README.md)
echo 📋 Copying web build files...
for /f "delims=" %%i in ('dir /b /a-d') do (
    if /i not "%%i"=="README.md" (
        del "%%i" 2>nul
    )
)
for /f "delims=" %%i in ('dir /b /ad') do (
    if /i not "%%i"==".git" (
        rmdir /s /q "%%i" 2>nul
    )
)

xcopy "%PROJECT_PATH%\build\web\*" . /e /i /y >nul
echo ✅ Files copied successfully!
echo.

REM Commit and push
echo 🔄 Committing changes...
git add .

REM Check if there are changes to commit
git diff --cached --quiet
if !ERRORLEVEL! neq 0 (
    git commit -m "Deploy web build - %date% %time%"
    
    REM Check if remote exists
    git remote show origin >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        git push origin main
        echo ✅ Changes pushed successfully!
    ) else (
        echo ⚠️  Remote 'origin' not found. Please add remote and push manually:
        echo git remote add origin ^<your-web-repo-url^>
        echo git push -u origin main
    )
) else (
    echo ℹ️  No changes to commit.
)

echo.
echo ✅ Deployment process completed!
echo.
echo 📋 Next Steps:
echo 1. Connect your web repository to GitHub/GitLab
echo 2. Connect the repository to Vercel
echo 3. Configure Vercel deployment settings
echo.
pause
