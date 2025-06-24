@echo off
title AgroConnect SMS Gateway - Easy APK Builder
color 0A

echo.
echo ========================================
echo   AgroConnect Africa SMS Gateway
echo   Easy APK Builder for Windows
echo ========================================
echo.

echo [INFO] Checking system requirements...

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] This script works better with administrator privileges.
    echo [INFO] You can continue without admin rights.
    echo.
)

REM Check if Java is installed
echo [1/4] Checking Java installation...
java -version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Java JDK not found!
    echo.
    echo Please install Java JDK 11 or higher:
    echo 1. Go to: https://adoptium.net/
    echo 2. Download "Eclipse Temurin 11 (LTS)"
    echo 3. Install with default settings
    echo 4. Restart this script
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Java found
)

REM Check if Android SDK is available
echo [2/4] Checking Android SDK...
if not exist "%ANDROID_HOME%\cmdline-tools\latest\bin\sdkmanager.bat" (
    if not exist "%LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat" (
        echo [WARNING] Android SDK not found!
        echo.
        echo OPTION 1 - Quick Setup (Recommended):
        echo This script can download Android SDK for you.
        echo.
        set /p install_sdk="Download Android SDK automatically? (y/n): "
        if /i "!install_sdk!"=="y" (
            call :install_android_sdk
        ) else (
            echo.
            echo OPTION 2 - Manual Setup:
            echo 1. Download Android Studio from: https://developer.android.com/studio
            echo 2. Install with default settings
            echo 3. Set ANDROID_HOME environment variable
            echo 4. Restart this script
            echo.
            pause
            exit /b 1
        )
    ) else (
        set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
        echo [OK] Android SDK found at %LOCALAPPDATA%\Android\Sdk
    )
) else (
    echo [OK] Android SDK found at %ANDROID_HOME%
)

REM Check if gradlew exists
echo [3/4] Checking project files...
if not exist "gradlew.bat" (
    echo [ERROR] gradlew.bat not found!
    echo Please make sure you're running this script from the android-sms-gateway folder.
    pause
    exit /b 1
) else (
    echo [OK] Gradle wrapper found
)

REM Build APK
echo [4/4] Building APK...
echo.
echo This may take a few minutes on first run...
echo Please wait while downloading dependencies and building...
echo.

call gradlew.bat assembleDebug

if %errorLevel% equ 0 (
    echo.
    echo ========================================
    echo           BUILD SUCCESSFUL!
    echo ========================================
    echo.
    
    if exist "app\build\outputs\apk\debug\app-debug.apk" (
        for %%A in ("app\build\outputs\apk\debug\app-debug.apk") do (
            echo APK Location: %%~fA
            echo APK Size: %%~zA bytes
        )
        echo.
        echo NEXT STEPS:
        echo 1. Copy the APK to your Android device
        echo 2. Enable "Unknown sources" in Android settings
        echo 3. Install the APK by tapping on it
        echo 4. Grant all required permissions
        echo 5. Configure server settings in the app
        echo.
        
        set /p open_folder="Open APK folder? (y/n): "
        if /i "!open_folder!"=="y" (
            explorer "app\build\outputs\apk\debug"
        )
        
        set /p install_adb="Install on connected Android device via USB? (y/n): "
        if /i "!install_adb!"=="y" (
            call :install_via_adb
        )
        
    ) else (
        echo [ERROR] APK file not found after build!
    )
    
) else (
    echo.
    echo ========================================
    echo           BUILD FAILED!
    echo ========================================
    echo.
    echo Common solutions:
    echo 1. Check internet connection (needed for dependencies)
    echo 2. Make sure Android SDK is properly installed
    echo 3. Try running as administrator
    echo 4. Delete .gradle folder and try again
    echo.
    echo Alternative build methods:
    echo 1. Upload to GitHub for automatic build
    echo 2. Use Android Studio
    echo 3. Use online APK builder services
)

echo.
echo Press any key to exit...
pause >nul
exit /b 0

:install_android_sdk
echo.
echo [INFO] Downloading Android SDK Command Line Tools...
echo This may take a few minutes...

REM Create Android SDK directory
if not exist "C:\android-sdk" mkdir "C:\android-sdk"

REM Download command line tools
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip' -OutFile 'android-tools.zip'}"

if exist "android-tools.zip" (
    echo [INFO] Extracting Android SDK...
    powershell -Command "Expand-Archive -Path 'android-tools.zip' -DestinationPath 'C:\android-sdk' -Force"
    
    REM Move to correct location
    if exist "C:\android-sdk\cmdline-tools" (
        if not exist "C:\android-sdk\cmdline-tools\latest" (
            move "C:\android-sdk\cmdline-tools" "C:\android-sdk\cmdline-tools-temp"
            mkdir "C:\android-sdk\cmdline-tools\latest"
            move "C:\android-sdk\cmdline-tools-temp\*" "C:\android-sdk\cmdline-tools\latest\"
            rmdir "C:\android-sdk\cmdline-tools-temp"
        )
    )
    
    REM Set environment variable
    setx ANDROID_HOME "C:\android-sdk" /M
    set ANDROID_HOME=C:\android-sdk
    
    REM Accept licenses and install required packages
    echo [INFO] Installing Android packages...
    echo y | "C:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat" --licenses
    "C:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat" "platforms;android-34" "build-tools;34.0.0"
    
    del "android-tools.zip"
    echo [OK] Android SDK installed successfully
) else (
    echo [ERROR] Failed to download Android SDK
    echo Please install manually from: https://developer.android.com/studio
    pause
    exit /b 1
)
goto :eof

:install_via_adb
echo.
echo [INFO] Installing APK via ADB...
echo Make sure your Android device is:
echo 1. Connected via USB
echo 2. USB Debugging is enabled
echo 3. Device is authorized for debugging
echo.

if exist "%ANDROID_HOME%\platform-tools\adb.exe" (
    "%ANDROID_HOME%\platform-tools\adb.exe" devices
    echo.
    "%ANDROID_HOME%\platform-tools\adb.exe" install "app\build\outputs\apk\debug\app-debug.apk"
    
    if %errorLevel% equ 0 (
        echo [OK] APK installed successfully on device!
    ) else (
        echo [ERROR] Failed to install APK via ADB
        echo Please install manually by copying APK to device
    )
) else (
    echo [WARNING] ADB not found. Please install APK manually.
)
goto :eof
