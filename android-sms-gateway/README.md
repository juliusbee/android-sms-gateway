# AgroConnect Africa - Android SMS Gateway

A powerful Android application that turns your Android device into an SMS gateway for the AgroConnect Africa platform. This app enables reliable SMS delivery using your device's cellular connection.

## Features

### 🚀 Core Functionality
- **Automatic SMS Sending**: Polls server for pending messages and sends them automatically
- **Real-time Status Reporting**: Reports delivery status back to the server
- **Background Operation**: Works continuously in the background
- **Multi-part SMS Support**: Handles long messages automatically
- **Priority-based Processing**: Processes high-priority messages first

### 📱 User Interface
- **Dashboard**: Real-time statistics and gateway status
- **Message Logs**: View sent/received messages with detailed information
- **Settings**: Configure server connection and app behavior
- **Setup Wizard**: Easy initial configuration

### 🔧 Technical Features
- **Auto-reconnection**: Automatically reconnects to server if connection is lost
- **Battery Optimization**: Handles Android battery optimization settings
- **Permission Management**: Guides users through required permissions
- **Error Handling**: Comprehensive error handling and retry mechanisms
- **Local Database**: Stores messages locally for reliability

## Installation

### Prerequisites
- Android 5.0 (API level 21) or higher
- SMS permissions
- Internet connection
- AgroConnect Africa server access

### Setup Instructions

1. **Download and Install**
   - Download the APK file
   - Enable "Install from unknown sources" in Android settings
   - Install the APK

2. **Grant Permissions**
   - SMS permissions (Send, Receive, Read)
   - Phone state permission
   - Network access permission

3. **Configure Gateway**
   - Open the app
   - Follow the setup wizard
   - Enter server URL and device information
   - Register device with the server

4. **Optimize Battery Settings**
   - Disable battery optimization for the app
   - Allow background activity
   - Set app to "Don't optimize" in battery settings

## Configuration

### Server Configuration
```
Server URL: https://your-domain.com/api/android-sms/
Device Name: Your device identifier
Phone Number: SIM card phone number
```

### App Settings
- **Polling Interval**: How often to check for new messages (default: 30 seconds)
- **Auto-start**: Start gateway automatically on device boot
- **Notifications**: Show notifications for sent messages
- **Log Level**: Debug, Info, Warning, Error

## API Integration

### Server Endpoints

#### Device Registration
```http
POST /api/android-sms/register
Content-Type: application/json

{
  "device_name": "My Android Gateway",
  "device_id": "unique-device-id",
  "phone_number": "+233241234567",
  "android_version": "13",
  "app_version": "1.0.0",
  "device_model": "Samsung Galaxy S21",
  "network_operator": "MTN"
}
```

#### Get Pending Messages
```http
GET /api/android-sms/pending-messages
Authorization: Bearer your-api-key
```

#### Report Message Status
```http
POST /api/android-sms/report-status
Authorization: Bearer your-api-key
Content-Type: application/json

{
  "message_id": 123,
  "status": "sent",
  "sent_at": "2025-06-24T10:30:00Z"
}
```

### Authentication
All API calls (except registration) require an API key in the Authorization header:
```
Authorization: Bearer your-api-key-here
```

## Architecture

### Components
- **MainActivity**: Main app interface and navigation
- **SmsPollingWorker**: Background worker for message processing
- **ApiClient**: HTTP client for server communication
- **SmsRepository**: Local database operations
- **NotificationHelper**: Manages app notifications

### Data Flow
1. App polls server for pending messages
2. Server returns list of messages to send
3. App sends SMS using Android SMS Manager
4. App reports delivery status back to server
5. Server updates message status in database

### Local Database
- **Messages Table**: Stores sent/received messages
- **Logs Table**: Application logs and errors
- **Settings Table**: App configuration

## Troubleshooting

### Common Issues

#### App Not Sending Messages
- Check SMS permissions are granted
- Verify internet connection
- Check server URL configuration
- Ensure device is registered with server

#### Messages Not Being Delivered
- Check cellular signal strength
- Verify phone number format
- Check SMS center configuration
- Review message content for special characters

#### Battery Optimization Issues
- Go to Settings > Battery > Battery Optimization
- Find the app and set to "Don't optimize"
- Some manufacturers have additional battery settings

#### Permission Issues
- Go to Settings > Apps > AgroConnect SMS Gateway > Permissions
- Enable all required permissions
- Restart the app after granting permissions

### Debug Mode
Enable debug mode in settings to see detailed logs:
1. Open app settings
2. Enable "Debug Mode"
3. Check logs in the Logs tab
4. Share logs with support if needed

## Security

### Data Protection
- API keys are stored securely using Android Keystore
- All communication uses HTTPS
- Local database is encrypted
- No sensitive data is logged in release builds

### Permissions
The app requires these permissions:
- `SEND_SMS`: Send SMS messages
- `READ_SMS`: Read SMS for delivery confirmation
- `RECEIVE_SMS`: Receive delivery reports
- `READ_PHONE_STATE`: Get device information
- `INTERNET`: Communicate with server
- `WAKE_LOCK`: Keep device awake for background processing

## Development

### Building from Source
1. Clone the repository
2. Open in Android Studio
3. Configure server URL in `build.gradle`
4. Build and run

### Testing
- Unit tests: `./gradlew test`
- Integration tests: `./gradlew connectedAndroidTest`
- Manual testing with test server

### Contributing
1. Fork the repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit pull request

## Support

### Getting Help
- Check troubleshooting section
- Review app logs
- Contact AgroConnect Africa support
- Submit issue on GitHub

### Logs and Diagnostics
The app maintains detailed logs that can be exported for troubleshooting:
1. Open app
2. Go to Logs tab
3. Tap "Export Logs"
4. Share with support team

## License

Copyright © 2025 AgroConnect Africa. All rights reserved.

This application is proprietary software developed for AgroConnect Africa platform users.
