@echo off
echo ========================================
echo AgroConnect Africa - Android SMS Gateway
echo APK Build Script
echo ========================================
echo.

REM Check if Android SDK is installed
if not exist "%ANDROID_HOME%\platform-tools\adb.exe" (
    echo ERROR: Android SDK not found!
    echo Please install Android Studio and set ANDROID_HOME environment variable.
    echo Download from: https://developer.android.com/studio
    pause
    exit /b 1
)

echo Android SDK found: %ANDROID_HOME%
echo.

REM Check if gradlew exists
if not exist "gradlew.bat" (
    echo ERROR: gradlew.bat not found!
    echo Please run this script from the android-sms-gateway directory.
    pause
    exit /b 1
)

echo Building Android APK...
echo.

REM Clean previous builds
echo Cleaning previous builds...
call gradlew.bat clean

REM Build debug APK
echo Building debug APK...
call gradlew.bat assembleDebug

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo Debug APK location:
    echo app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo You can now install this APK on your Android device.
    echo.
    
    REM Check if APK exists and show file size
    if exist "app\build\outputs\apk\debug\app-debug.apk" (
        for %%A in ("app\build\outputs\apk\debug\app-debug.apk") do (
            echo APK Size: %%~zA bytes
        )
        echo.
        echo To install on connected device:
        echo adb install app\build\outputs\apk\debug\app-debug.apk
    )
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo Common issues:
    echo - Missing Android SDK
    echo - Missing Java JDK
    echo - Network connection for dependencies
)

echo.
pause
