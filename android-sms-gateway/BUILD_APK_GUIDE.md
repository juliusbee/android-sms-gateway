# 🚀 Quick APK Build Guide

## 📋 Prerequisites (5 minutes)

### 1. Install Android Studio
- Download: https://developer.android.com/studio
- Install with default settings (includes Android SDK)

### 2. Install Java JDK
- Download: https://adoptium.net/
- Install Java 11 or higher

## 🔧 Build APK (3 steps)

### Step 1: Open Project
1. Launch Android Studio
2. Click "Open an existing project"
3. Select the `android-sms-gateway` folder
4. Wait for project sync (2-3 minutes)

### Step 2: Build APK
**Option A: Using Android Studio**
1. Go to `Build` menu
2. Click `Build Bundle(s) / APK(s)`
3. Click `Build APK(s)`
4. Wait for build completion

**Option B: Using Command Line**
```bash
# Windows
gradlew.bat assembleDebug

# Linux/Mac
./gradlew assembleDebug
```

### Step 3: Find Your APK
📁 Location: `app/build/outputs/apk/debug/app-debug.apk`
📏 Size: ~8-12 MB

## 📱 Install APK

### Method 1: USB Installation
1. Enable Developer Options on Android device
2. Enable USB Debugging
3. Connect device to computer
4. Run: `adb install app-debug.apk`

### Method 2: Manual Installation
1. Copy APK to device storage
2. Enable "Unknown sources" in Android settings
3. Open file manager and tap APK
4. Follow installation prompts

## ⚙️ Configure App

### 1. Server Settings
- **Server URL:** `http://your-domain.com/api/android-sms/`
- **Device Name:** Choose unique name
- **Phone Number:** SIM card number

### 2. Register Device
1. Open app
2. Fill in server details
3. Tap "Register Device"
4. Save API key securely

### 3. Grant Permissions
- SMS permissions (Send, Read, Receive)
- Phone state permission
- Network access

### 4. Optimize Battery
- Go to Settings > Battery
- Find app and set to "Don't optimize"
- Allow background activity

## 🔍 Troubleshooting

### Build Issues
- **Gradle sync failed:** Check internet connection
- **SDK not found:** Install Android SDK via Android Studio
- **Java not found:** Install Java JDK 11+

### Installation Issues
- **App won't install:** Enable "Unknown sources"
- **Permission denied:** Check Android version (min: 5.0)
- **Storage full:** Free up device space

### Runtime Issues
- **Can't send SMS:** Grant SMS permissions
- **No connection:** Check server URL and internet
- **Battery optimization:** Disable for the app

## 📞 Support

If you encounter issues:
1. Check error messages in Android Studio
2. Enable debug mode in app settings
3. Export app logs for troubleshooting
4. Contact support with device info and logs

## 🎯 Quick Commands

```bash
# Build debug APK
./gradlew assembleDebug

# Build release APK (requires signing)
./gradlew assembleRelease

# Install on connected device
adb install app/build/outputs/apk/debug/app-debug.apk

# Check connected devices
adb devices

# View app logs
adb logcat | grep "AgroConnect"
```

## 📦 File Structure
```
android-sms-gateway/
├── app/
│   ├── build/
│   │   └── outputs/
│   │       └── apk/
│   │           └── debug/
│   │               └── app-debug.apk ← YOUR APK
│   ├── src/
│   └── build.gradle
├── gradle/
├── build.gradle
├── settings.gradle
└── gradlew / gradlew.bat
```

## 🎨 Logo & Branding

The APK includes custom AgroConnect Africa branding:
- **App Icon:** Adaptive icon with wheat/grain symbol
- **Splash Screen:** Full logo with company branding
- **In-App Logo:** Header logo in main interface
- **Notification Icon:** Custom SMS notification icon
- **Colors:** AgroConnect green theme (#2E7D32, #4CAF50)

All logo resources are vector-based for crisp display on all devices.

## ✅ Success Checklist

- [ ] Android Studio installed
- [ ] Project opened and synced
- [ ] APK built successfully
- [ ] APK installed on device
- [ ] App permissions granted
- [ ] Server configured
- [ ] Device registered
- [ ] Battery optimization disabled
- [ ] Test SMS sent successfully
- [ ] Logo and branding display correctly

**🎉 Your Android SMS Gateway is ready!**
