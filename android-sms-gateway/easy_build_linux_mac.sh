#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}"
echo "========================================"
echo "  AgroConnect Africa SMS Gateway"
echo "  Easy APK Builder for Linux/Mac"
echo "========================================"
echo -e "${NC}"

echo -e "${BLUE}[INFO]${NC} Checking system requirements..."

# Function to install Java on different systems
install_java() {
    echo -e "${BLUE}[INFO]${NC} Installing Java JDK 11..."
    
    if command -v apt-get &> /dev/null; then
        # Ubuntu/Debian
        sudo apt-get update
        sudo apt-get install -y openjdk-11-jdk
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        sudo yum install -y java-11-openjdk-devel
    elif command -v dnf &> /dev/null; then
        # Fedora
        sudo dnf install -y java-11-openjdk-devel
    elif command -v brew &> /dev/null; then
        # macOS with Homebrew
        brew install openjdk@11
        echo 'export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"' >> ~/.zshrc
        export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
    else
        echo -e "${RED}[ERROR]${NC} Cannot automatically install Java on this system."
        echo "Please install Java JDK 11 manually:"
        echo "- Ubuntu/Debian: sudo apt install openjdk-11-jdk"
        echo "- macOS: brew install openjdk@11"
        echo "- Or download from: https://adoptium.net/"
        exit 1
    fi
}

# Function to install Android SDK
install_android_sdk() {
    echo -e "${BLUE}[INFO]${NC} Installing Android SDK..."
    
    # Determine OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        SDK_URL="https://dl.google.com/android/repository/commandlinetools-mac-9477386_latest.zip"
    else
        echo -e "${RED}[ERROR]${NC} Unsupported operating system"
        exit 1
    fi
    
    # Create Android SDK directory
    ANDROID_HOME="$HOME/android-sdk"
    mkdir -p "$ANDROID_HOME"
    
    # Download and extract
    echo -e "${BLUE}[INFO]${NC} Downloading Android Command Line Tools..."
    curl -L "$SDK_URL" -o android-tools.zip
    
    if [ -f "android-tools.zip" ]; then
        unzip -q android-tools.zip -d "$ANDROID_HOME"
        mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
        mv "$ANDROID_HOME/cmdline-tools"/* "$ANDROID_HOME/cmdline-tools/latest/" 2>/dev/null || true
        rm android-tools.zip
        
        # Set environment variables
        export ANDROID_HOME="$ANDROID_HOME"
        export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
        
        # Add to shell profile
        SHELL_PROFILE=""
        if [ -f "$HOME/.bashrc" ]; then
            SHELL_PROFILE="$HOME/.bashrc"
        elif [ -f "$HOME/.zshrc" ]; then
            SHELL_PROFILE="$HOME/.zshrc"
        fi
        
        if [ -n "$SHELL_PROFILE" ]; then
            echo "export ANDROID_HOME=$ANDROID_HOME" >> "$SHELL_PROFILE"
            echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools" >> "$SHELL_PROFILE"
        fi
        
        # Accept licenses and install packages
        echo -e "${BLUE}[INFO]${NC} Installing Android packages..."
        yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses
        "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" "platforms;android-34" "build-tools;34.0.0" "platform-tools"
        
        echo -e "${GREEN}[OK]${NC} Android SDK installed successfully"
    else
        echo -e "${RED}[ERROR]${NC} Failed to download Android SDK"
        exit 1
    fi
}

# Check Java installation
echo -e "${BLUE}[1/4]${NC} Checking Java installation..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1-2)
    echo -e "${GREEN}[OK]${NC} Java found (version $JAVA_VERSION)"
else
    echo -e "${YELLOW}[WARNING]${NC} Java not found!"
    read -p "Install Java JDK 11 automatically? (y/n): " install_java_choice
    if [[ $install_java_choice =~ ^[Yy]$ ]]; then
        install_java
    else
        echo -e "${RED}[ERROR]${NC} Java is required to build APK"
        echo "Please install Java JDK 11 and try again"
        exit 1
    fi
fi

# Check Android SDK
echo -e "${BLUE}[2/4]${NC} Checking Android SDK..."
if [ -z "$ANDROID_HOME" ] || [ ! -f "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
    echo -e "${YELLOW}[WARNING]${NC} Android SDK not found!"
    read -p "Install Android SDK automatically? (y/n): " install_sdk_choice
    if [[ $install_sdk_choice =~ ^[Yy]$ ]]; then
        install_android_sdk
    else
        echo -e "${RED}[ERROR]${NC} Android SDK is required to build APK"
        echo "Please install Android SDK and set ANDROID_HOME environment variable"
        exit 1
    fi
else
    echo -e "${GREEN}[OK]${NC} Android SDK found at $ANDROID_HOME"
fi

# Check project files
echo -e "${BLUE}[3/4]${NC} Checking project files..."
if [ ! -f "gradlew" ]; then
    echo -e "${RED}[ERROR]${NC} gradlew not found!"
    echo "Please make sure you're running this script from the android-sms-gateway folder"
    exit 1
else
    echo -e "${GREEN}[OK]${NC} Gradle wrapper found"
    chmod +x gradlew
fi

# Build APK
echo -e "${BLUE}[4/4]${NC} Building APK..."
echo
echo "This may take a few minutes on first run..."
echo "Please wait while downloading dependencies and building..."
echo

./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo
    echo -e "${GREEN}"
    echo "========================================"
    echo "         BUILD SUCCESSFUL!"
    echo "========================================"
    echo -e "${NC}"
    
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        echo -e "${GREEN}[OK]${NC} APK Location: $(pwd)/$APK_PATH"
        echo -e "${GREEN}[OK]${NC} APK Size: $APK_SIZE"
        echo
        echo "NEXT STEPS:"
        echo "1. Copy the APK to your Android device"
        echo "2. Enable 'Unknown sources' in Android settings"
        echo "3. Install the APK by tapping on it"
        echo "4. Grant all required permissions"
        echo "5. Configure server settings in the app"
        echo
        
        read -p "Open APK folder? (y/n): " open_folder
        if [[ $open_folder =~ ^[Yy]$ ]]; then
            if command -v xdg-open &> /dev/null; then
                xdg-open "app/build/outputs/apk/debug"
            elif command -v open &> /dev/null; then
                open "app/build/outputs/apk/debug"
            fi
        fi
        
        read -p "Install on connected Android device via USB? (y/n): " install_adb
        if [[ $install_adb =~ ^[Yy]$ ]]; then
            if [ -f "$ANDROID_HOME/platform-tools/adb" ]; then
                echo
                echo -e "${BLUE}[INFO]${NC} Installing APK via ADB..."
                echo "Make sure your Android device is:"
                echo "1. Connected via USB"
                echo "2. USB Debugging is enabled"
                echo "3. Device is authorized for debugging"
                echo
                
                "$ANDROID_HOME/platform-tools/adb" devices
                echo
                "$ANDROID_HOME/platform-tools/adb" install "$APK_PATH"
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}[OK]${NC} APK installed successfully on device!"
                else
                    echo -e "${RED}[ERROR]${NC} Failed to install APK via ADB"
                    echo "Please install manually by copying APK to device"
                fi
            else
                echo -e "${YELLOW}[WARNING]${NC} ADB not found. Please install APK manually."
            fi
        fi
        
    else
        echo -e "${RED}[ERROR]${NC} APK file not found after build!"
    fi
    
else
    echo
    echo -e "${RED}"
    echo "========================================"
    echo "         BUILD FAILED!"
    echo "========================================"
    echo -e "${NC}"
    echo
    echo "Common solutions:"
    echo "1. Check internet connection (needed for dependencies)"
    echo "2. Make sure Android SDK is properly installed"
    echo "3. Delete .gradle folder and try again: rm -rf .gradle"
    echo "4. Run with verbose output: ./gradlew assembleDebug --info"
    echo
    echo "Alternative build methods:"
    echo "1. Upload to GitHub for automatic build"
    echo "2. Use Android Studio"
    echo "3. Use Docker: docker run mingc/android-build-box"
fi

echo
echo "Press Enter to exit..."
read
