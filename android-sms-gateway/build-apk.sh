#!/bin/bash

echo "========================================"
echo "AgroConnect Africa - Android SMS Gateway"
echo "APK Build Script"
echo "========================================"
echo

# Check if Android SDK is installed
if [ -z "$ANDROID_HOME" ]; then
    echo "ERROR: ANDROID_HOME environment variable not set!"
    echo "Please install Android Studio and set ANDROID_HOME."
    echo "Download from: https://developer.android.com/studio"
    exit 1
fi

if [ ! -f "$ANDROID_HOME/platform-tools/adb" ]; then
    echo "ERROR: Android SDK not found at $ANDROID_HOME"
    echo "Please verify your Android SDK installation."
    exit 1
fi

echo "Android SDK found: $ANDROID_HOME"
echo

# Check if gradlew exists
if [ ! -f "./gradlew" ]; then
    echo "ERROR: gradlew not found!"
    echo "Please run this script from the android-sms-gateway directory."
    exit 1
fi

# Make gradlew executable
chmod +x ./gradlew

echo "Building Android APK..."
echo

# Clean previous builds
echo "Cleaning previous builds..."
./gradlew clean

# Build debug APK
echo "Building debug APK..."
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo
    echo "========================================"
    echo "BUILD SUCCESSFUL!"
    echo "========================================"
    echo
    echo "Debug APK location:"
    echo "app/build/outputs/apk/debug/app-debug.apk"
    echo
    
    # Check if APK exists and show file size
    if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
        APK_SIZE=$(stat -f%z "app/build/outputs/apk/debug/app-debug.apk" 2>/dev/null || stat -c%s "app/build/outputs/apk/debug/app-debug.apk" 2>/dev/null)
        echo "APK Size: $APK_SIZE bytes"
        echo
        echo "To install on connected device:"
        echo "adb install app/build/outputs/apk/debug/app-debug.apk"
    fi
else
    echo
    echo "========================================"
    echo "BUILD FAILED!"
    echo "========================================"
    echo
    echo "Please check the error messages above."
    echo "Common issues:"
    echo "- Missing Android SDK"
    echo "- Missing Java JDK"
    echo "- Network connection for dependencies"
    exit 1
fi

echo
