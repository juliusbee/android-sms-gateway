# 🚀 Building APK Without Android Studio

## 🎯 **Quick Solutions (Choose One)**

### **Option 1: GitHub Actions (Recommended - 100% Free)**

**⏱️ Time: 5 minutes setup, 10 minutes build**

1. **Create GitHub Account** (if you don't have one)
   - Go to https://github.com
   - Sign up for free

2. **Upload Project to GitHub**
   ```bash
   # Method A: Upload ZIP file
   # 1. Compress android-sms-gateway folder to ZIP
   # 2. Go to GitHub > New Repository
   # 3. Upload ZIP file
   
   # Method B: Use Git (if installed)
   cd android-sms-gateway
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOURUSERNAME/agroconnect-sms.git
   git push -u origin main
   ```

3. **Automatic APK Build**
   - GitHub Actions will automatically build your APK
   - Go to "Actions" tab in your repository
   - Download APK from "Artifacts" section
   - **Build time:** ~10 minutes

**✅ Pros:** Free, automatic, no setup required
**❌ Cons:** Requires GitHub account, 10-minute wait

---

### **Option 2: Online APK Builder Service**

**⏱️ Time: 2 minutes**

Use our built-in web builder:

1. **Access Builder**
   - Go to: `http://localhost:8000/admin/apk-builder`
   - Configure your app settings
   - Click "Build APK"

2. **Download Options**
   - Direct APK download (if build environment available)
   - Source code download for manual build
   - Build instructions for other methods

**✅ Pros:** Instant, web-based, customizable
**❌ Cons:** Requires server setup

---

### **Option 3: Command Line Only (No IDE)**

**⏱️ Time: 15 minutes setup, 5 minutes build**

#### **Windows Setup:**
```batch
@echo off
echo Installing build environment...

REM 1. Download and install Java JDK
echo Downloading Java JDK 11...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20.1%%2B1/OpenJDK11U-jdk_x64_windows_hotspot_11.0.20.1_1.msi' -OutFile 'java-jdk.msi'"
msiexec /i java-jdk.msi /quiet

REM 2. Download Android Command Line Tools
echo Downloading Android SDK...
powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip' -OutFile 'android-tools.zip'"
powershell -Command "Expand-Archive -Path 'android-tools.zip' -DestinationPath 'C:\android-sdk'"

REM 3. Set environment variables
setx ANDROID_HOME "C:\android-sdk" /M
setx PATH "%PATH%;C:\android-sdk\cmdline-tools\latest\bin" /M

REM 4. Accept licenses and install packages
echo Installing Android packages...
echo y | C:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat --licenses
C:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat "platforms;android-34" "build-tools;34.0.0"

echo Setup complete! You can now build APKs.
pause
```

#### **Build APK:**
```batch
cd android-sms-gateway
gradlew.bat assembleDebug
```

**APK Location:** `app\build\outputs\apk\debug\app-debug.apk`

#### **Linux/Mac Setup:**
```bash
#!/bin/bash
echo "Installing build environment..."

# 1. Install Java
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y openjdk-11-jdk
elif command -v brew &> /dev/null; then
    brew install openjdk@11
fi

# 2. Download Android Command Line Tools
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-*.zip
mkdir -p ~/android-sdk/cmdline-tools
mv cmdline-tools ~/android-sdk/cmdline-tools/latest

# 3. Set environment variables
export ANDROID_HOME=~/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
echo 'export ANDROID_HOME=~/android-sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc

# 4. Accept licenses and install packages
yes | sdkmanager --licenses
sdkmanager "platforms;android-34" "build-tools;34.0.0"

echo "Setup complete! You can now build APKs."
```

#### **Build APK:**
```bash
cd android-sms-gateway
chmod +x gradlew
./gradlew assembleDebug
```

**APK Location:** `app/build/outputs/apk/debug/app-debug.apk`

---

### **Option 4: Docker Container (Advanced)**

**⏱️ Time: 10 minutes**

```bash
# 1. Install Docker
# Windows: Download Docker Desktop
# Linux: sudo apt install docker.io
# Mac: brew install docker

# 2. Build APK in container
cd android-sms-gateway
docker run --rm -v $(pwd):/workspace -w /workspace \
  mingc/android-build-box:latest \
  bash -c "chmod +x gradlew && ./gradlew assembleDebug"

# 3. APK will be in app/build/outputs/apk/debug/
```

---

### **Option 5: Cloud Development Environment**

#### **A. GitHub Codespaces (Free)**
1. Open your GitHub repository
2. Click "Code" > "Codespaces" > "Create codespace"
3. Wait for environment to load
4. Run build commands in terminal

#### **B. Gitpod (Free)**
1. Prefix your GitHub URL with `gitpod.io/#`
2. Example: `gitpod.io/#https://github.com/yourusername/repo`
3. Automatic development environment
4. Build APK in browser terminal

#### **C. Replit**
1. Upload project to Replit
2. Use Android build environment
3. Build and download APK

---

## 📱 **Quick Start Script**

Save this as `quick-build.bat` (Windows) or `quick-build.sh` (Linux/Mac):

### Windows (`quick-build.bat`):
```batch
@echo off
echo AgroConnect SMS Gateway - Quick APK Builder
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %errorLevel% neq 0 (
    echo Java not found. Please install Java JDK 11 from:
    echo https://adoptium.net/
    pause
    exit /b 1
)

REM Check if Android SDK is available
if not exist "%ANDROID_HOME%\cmdline-tools\latest\bin\sdkmanager.bat" (
    echo Android SDK not found. Running setup...
    call setup-android-sdk.bat
)

echo Building APK...
cd android-sms-gateway
call gradlew.bat assembleDebug

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo SUCCESS! APK built successfully.
    echo Location: app\build\outputs\apk\debug\app-debug.apk
    echo.
    explorer app\build\outputs\apk\debug
) else (
    echo BUILD FAILED! Check error messages above.
)

pause
```

### Linux/Mac (`quick-build.sh`):
```bash
#!/bin/bash
echo "AgroConnect SMS Gateway - Quick APK Builder"
echo

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "Java not found. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y openjdk-11-jdk
    elif command -v brew &> /dev/null; then
        brew install openjdk@11
    else
        echo "Please install Java JDK 11 manually from: https://adoptium.net/"
        exit 1
    fi
fi

# Check if Android SDK is available
if [ ! -f "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
    echo "Android SDK not found. Running setup..."
    ./setup-android-sdk.sh
fi

echo "Building APK..."
cd android-sms-gateway
chmod +x gradlew
./gradlew assembleDebug

if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo
    echo "SUCCESS! APK built successfully."
    echo "Location: app/build/outputs/apk/debug/app-debug.apk"
    echo
    ls -lh app/build/outputs/apk/debug/app-debug.apk
else
    echo "BUILD FAILED! Check error messages above."
fi
```

---

## 🆘 **Troubleshooting**

### **Common Issues:**

#### **"Java not found"**
```bash
# Install Java JDK 11
# Windows: Download from https://adoptium.net/
# Linux: sudo apt install openjdk-11-jdk
# Mac: brew install openjdk@11
```

#### **"Android SDK not found"**
```bash
# Download Android Command Line Tools
# Windows: https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip
# Linux: https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
# Mac: https://dl.google.com/android/repository/commandlinetools-mac-9477386_latest.zip
```

#### **"Permission denied"**
```bash
# Make gradlew executable
chmod +x gradlew
```

#### **"Build failed"**
```bash
# Clean and retry
./gradlew clean
./gradlew assembleDebug
```

---

## 🎯 **Recommended Approach**

**For Beginners:** Use GitHub Actions (Option 1)
**For Developers:** Use Command Line (Option 3)
**For Quick Testing:** Use Online Builder (Option 2)
**For Advanced Users:** Use Docker (Option 4)

---

## 📞 **Need Help?**

1. **Check build logs** for specific error messages
2. **Try GitHub Actions** - it's the most reliable method
3. **Use our online builder** for customized APKs
4. **Contact support** with your error logs

**Support:** support@agroconnect-africa.com
