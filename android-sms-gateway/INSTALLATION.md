# AgroConnect Africa - Android SMS Gateway Installation Guide

## 📱 Getting the APK

### Option 1: Download Pre-built APK (Fastest)
**Note:** Since this is a custom app, you'll need to build it yourself or have it built by a developer.

### Option 2: Build from Source (Recommended)

#### Prerequisites
1. **Android Studio** (Latest version)
   - Download: https://developer.android.com/studio
   - Install with Android SDK

2. **Java JDK 8 or higher**
   - Download: https://adoptium.net/

3. **Git** (to clone the repository)
   - Download: https://git-scm.com/

#### Building Steps

1. **Clone/Download the Project**
   ```bash
   # If using Git
   git clone <repository-url>
   cd android-sms-gateway
   
   # Or download and extract the ZIP file
   ```

2. **Open in Android Studio**
   - Launch Android Studio
   - Click "Open an existing project"
   - Navigate to the `android-sms-gateway` folder
   - Click "OK"

3. **Wait for Sync**
   - Android Studio will automatically sync the project
   - Wait for all dependencies to download

4. **Build the APK**
   ```bash
   # Using command line (in project directory)
   ./gradlew assembleDebug
   
   # Or in Android Studio: Build > Build Bundle(s) / APK(s) > Build APK(s)
   ```

5. **Find Your APK**
   - Location: `app/build/outputs/apk/debug/app-debug.apk`
   - File size: ~8-12 MB

#### Quick Build Scripts
- **Windows:** Run `build-apk.bat`
- **Linux/Mac:** Run `chmod +x build-apk.sh && ./build-apk.sh`

## 📲 Installing the APK

### On Android Device

1. **Enable Unknown Sources**
   - Go to Settings > Security
   - Enable "Unknown sources" or "Install unknown apps"
   - For Android 8+: Settings > Apps > Special access > Install unknown apps

2. **Transfer APK to Device**
   - USB cable: Copy APK to device storage
   - Email: Send APK to yourself and download
   - Cloud storage: Upload to Google Drive/Dropbox
   - ADB: `adb install app-debug.apk`

3. **Install APK**
   - Open file manager on device
   - Navigate to APK location
   - Tap the APK file
   - Tap "Install"
   - Tap "Open" when installation completes

### Using ADB (Developer Method)

1. **Enable Developer Options**
   - Go to Settings > About phone
   - Tap "Build number" 7 times
   - Go back to Settings > Developer options
   - Enable "USB debugging"

2. **Install via ADB**
   ```bash
   # Connect device via USB
   adb devices
   adb install app/build/outputs/apk/debug/app-debug.apk
   ```

## ⚙️ Initial Setup

### 1. Grant Permissions
When you first open the app, grant these permissions:
- **SMS permissions** (Send, Receive, Read)
- **Phone state permission**
- **Network access**

### 2. Configure Server Connection
- **Server URL:** `http://your-domain.com/api/android-sms/`
- **Device Name:** Choose a unique name for your device
- **Phone Number:** Enter the SIM card's phone number

### 3. Register Device
- Tap "Register Device"
- Wait for successful registration
- Save the API key securely

### 4. Optimize Battery Settings
- Go to device Settings > Battery
- Find "AgroConnect SMS Gateway"
- Set to "Don't optimize" or "No restrictions"
- This ensures the app works in background

### 5. Test Connection
- Send a test message from the admin panel
- Verify the message is received and sent
- Check the app logs for any errors

## 🔧 Configuration

### Server Settings
```
Production URL: https://your-domain.com/api/android-sms/
Development URL: http://10.0.2.2:8000/api/android-sms/
```

### App Settings
- **Polling Interval:** 30 seconds (default)
- **Auto-start:** Enable for automatic startup
- **Notifications:** Enable for message alerts
- **Debug Mode:** Enable for troubleshooting

## 🚨 Troubleshooting

### Common Issues

#### App Won't Install
- Check Android version (minimum: Android 5.0)
- Ensure "Unknown sources" is enabled
- Try installing via ADB
- Check available storage space

#### Permissions Denied
- Go to Settings > Apps > AgroConnect SMS Gateway > Permissions
- Enable all required permissions manually
- Restart the app

#### Can't Send SMS
- Check SIM card is inserted and active
- Verify SMS permissions are granted
- Check cellular signal strength
- Ensure SMS center number is configured

#### Connection Issues
- Verify server URL is correct
- Check internet connection (WiFi/Mobile data)
- Ensure server is running and accessible
- Check firewall settings

#### Battery Optimization
- Some manufacturers have aggressive battery optimization
- Add app to battery whitelist
- Disable "Adaptive battery" for the app
- Check manufacturer-specific battery settings

### Debug Information
Enable debug mode in app settings to see detailed logs:
1. Open app settings
2. Enable "Debug Mode"
3. Check logs in the "Logs" tab
4. Export logs for support

### Getting Help
1. Check app logs for error messages
2. Verify server connectivity
3. Test with a simple SMS first
4. Contact support with logs and device information

## 📋 Device Requirements

### Minimum Requirements
- **Android:** 5.0 (API level 21) or higher
- **RAM:** 1GB minimum, 2GB recommended
- **Storage:** 50MB free space
- **Network:** WiFi or mobile data connection
- **SIM Card:** Active SIM with SMS capability

### Recommended Devices
- Any modern Android smartphone
- Dedicated Android device for SMS gateway
- Android tablet with SIM card slot
- Android TV box with USB modem (advanced setup)

### Network Requirements
- Stable internet connection
- Access to your AgroConnect Africa server
- Cellular network for SMS sending
- Port 80/443 access for HTTPS communication

## 🔐 Security Notes

### Data Protection
- API keys are stored securely using Android Keystore
- All server communication uses HTTPS
- Local database is encrypted
- No sensitive data in logs (release builds)

### Permissions Explained
- **SEND_SMS:** Required to send SMS messages
- **READ_SMS:** Needed for delivery confirmation
- **RECEIVE_SMS:** Required for delivery reports
- **READ_PHONE_STATE:** Gets device and network information
- **INTERNET:** Communicates with your server
- **WAKE_LOCK:** Keeps device awake for background processing

## 📞 Support

### Before Contacting Support
1. Check this installation guide
2. Review troubleshooting section
3. Enable debug mode and check logs
4. Test with a simple configuration

### Contact Information
- **Email:** support@agroconnect-africa.com
- **Documentation:** Check the README.md file
- **Logs:** Always include app logs when reporting issues

### What to Include in Support Requests
- Device model and Android version
- App version and build number
- Server URL and configuration
- Error messages or logs
- Steps to reproduce the issue
