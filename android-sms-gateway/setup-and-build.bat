@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   AgroConnect Africa SMS Gateway
echo   Automated Setup and Build Script
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator.
    pause
    exit /b 1
)

echo [1/6] Checking system requirements...

REM Check if Java is installed
java -version >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo Java JDK not found. Installing OpenJDK 11...
    
    REM Download and install OpenJDK
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20.1%2B1/OpenJDK11U-jdk_x64_windows_hotspot_11.0.20.1_1.msi' -OutFile 'openjdk11.msi'}"
    
    if exist "openjdk11.msi" (
        echo Installing Java JDK 11...
        msiexec /i openjdk11.msi /quiet /norestart
        del openjdk11.msi
        
        REM Add Java to PATH
        setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-11.0.20.1-hotspot" /M
        setx PATH "%PATH%;%JAVA_HOME%\bin" /M
        
        echo Java JDK 11 installed successfully.
    ) else (
        echo Failed to download Java JDK. Please install manually from:
        echo https://adoptium.net/
        pause
        exit /b 1
    )
) else (
    echo Java JDK found.
)

echo.
echo [2/6] Checking Android SDK...

REM Check if Android SDK is installed
if not exist "%ANDROID_HOME%\platform-tools\adb.exe" (
    if not exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" (
        echo.
        echo Android SDK not found. Please install Android Studio first:
        echo https://developer.android.com/studio
        echo.
        echo After installation, set ANDROID_HOME environment variable to:
        echo %LOCALAPPDATA%\Android\Sdk
        pause
        exit /b 1
    ) else (
        set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
        setx ANDROID_HOME "%LOCALAPPDATA%\Android\Sdk" /M
        echo Android SDK found at %LOCALAPPDATA%\Android\Sdk
    )
) else (
    echo Android SDK found at %ANDROID_HOME%
)

echo.
echo [3/6] Setting up project...

REM Create local.properties file
echo sdk.dir=%ANDROID_HOME:\=\\% > local.properties
echo Created local.properties file.

REM Make gradlew executable (not needed on Windows, but good practice)
if exist "gradlew.bat" (
    echo Gradle wrapper found.
) else (
    echo Gradle wrapper not found. This might cause build issues.
)

echo.
echo [4/6] Downloading dependencies...

REM Clean any previous builds
if exist "app\build" (
    rmdir /s /q "app\build"
    echo Cleaned previous builds.
)

REM Download dependencies
echo Downloading project dependencies...
call gradlew.bat --refresh-dependencies

echo.
echo [5/6] Building APK...

REM Build the debug APK
echo Building debug APK...
call gradlew.bat assembleDebug

if %errorLevel% equ 0 (
    echo.
    echo [6/6] Build completed successfully!
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
        echo Next steps:
        echo 1. Copy the APK to your Android device
        echo 2. Enable "Unknown sources" in Android settings
        echo 3. Install the APK
        echo 4. Grant all required permissions
        echo 5. Configure server settings in the app
        echo.
        
        REM Ask if user wants to install via ADB
        set /p install_adb="Do you want to install via ADB to connected device? (y/n): "
        if /i "!install_adb!"=="y" (
            echo.
            echo Checking for connected devices...
            "%ANDROID_HOME%\platform-tools\adb.exe" devices
            echo.
            echo Installing APK...
            "%ANDROID_HOME%\platform-tools\adb.exe" install "app\build\outputs\apk\debug\app-debug.apk"
            
            if !errorLevel! equ 0 (
                echo APK installed successfully on device!
            ) else (
                echo Failed to install APK. Please install manually.
            )
        )
        
        REM Open APK location in explorer
        set /p open_folder="Open APK folder in Explorer? (y/n): "
        if /i "!open_folder!"=="y" (
            explorer "app\build\outputs\apk\debug"
        )
        
    ) else (
        echo ERROR: APK file not found after build!
    )
    
) else (
    echo.
    echo ========================================
    echo           BUILD FAILED!
    echo ========================================
    echo.
    echo Common solutions:
    echo 1. Check internet connection for dependency downloads
    echo 2. Ensure Android SDK is properly installed
    echo 3. Verify Java JDK is installed and in PATH
    echo 4. Try running: gradlew.bat clean assembleDebug
    echo.
    echo For detailed error information, check the output above.
)

echo.
echo Script completed. Press any key to exit...
pause >nul
