# 🎨 AgroConnect Africa - Logo & Branding Resources

## 📱 App Icons & Logos

### Main App Icon
- **File:** `ic_agroconnect_logo.xml`
- **Size:** 120dp x 120dp
- **Type:** Vector drawable
- **Usage:** Main app logo, headers, splash screen

### Launcher Icons
- **Foreground:** `ic_launcher_foreground.xml`
- **Background:** `ic_launcher_background.xml`
- **Adaptive:** `ic_launcher.xml` & `ic_launcher_round.xml`
- **Type:** Adaptive icons (Android 8.0+)

### Splash Screen Logo
- **File:** `splash_logo.xml`
- **Size:** 200dp x 200dp
- **Type:** Vector drawable
- **Usage:** App startup screen

### Notification Icon
- **File:** `ic_notification.xml`
- **Size:** 24dp x 24dp
- **Type:** Vector drawable
- **Usage:** System notifications

## 🎨 Design Elements

### Logo Composition
The AgroConnect Africa logo consists of:

1. **Circular Background**
   - Primary green (#2E7D32)
   - Secondary green (#4CAF50)
   - Gradient effect for depth

2. **Wheat/Grain Symbol**
   - Central wheat stem (white)
   - Grain clusters (orange #FF9800)
   - Leaves (green #4CAF50)
   - Represents agriculture/farming

3. **SMS/Communication Element**
   - Message/phone icon
   - Signal waves
   - Represents SMS gateway functionality

### Color Palette
```xml
<!-- Primary Colors -->
<color name="primary">#2E7D32</color>          <!-- Dark Green -->
<color name="primary_light">#4CAF50</color>    <!-- Light Green -->
<color name="accent">#FF9800</color>           <!-- Orange -->

<!-- Logo Specific -->
<color name="logo_primary">#2E7D32</color>
<color name="logo_secondary">#4CAF50</color>
<color name="logo_accent">#FF9800</color>
<color name="logo_text_color">#FFFFFF</color>
```

### Typography
- **Primary Font:** Sans-serif Medium
- **Logo Text:** "AgroConnect"
- **Subtitle:** "SMS Gateway"
- **Sizes:** 24sp (main), 14sp (subtitle)

## 📁 File Structure

```
app/src/main/res/
├── drawable/
│   ├── ic_agroconnect_logo.xml      # Main app logo
│   ├── ic_launcher_foreground.xml   # Launcher foreground
│   ├── ic_launcher_background.xml   # Launcher background
│   ├── splash_logo.xml              # Splash screen logo
│   ├── ic_notification.xml          # Notification icon
│   ├── ic_dashboard.xml             # Navigation icons
│   ├── ic_messages.xml
│   ├── ic_logs.xml
│   └── ic_settings.xml
├── mipmap-anydpi-v26/
│   ├── ic_launcher.xml              # Adaptive launcher icon
│   └── ic_launcher_round.xml        # Round adaptive icon
├── values/
│   ├── colors.xml                   # Color definitions
│   ├── strings.xml                  # Text resources
│   └── logo_config.xml              # Logo configuration
└── layout/
    ├── activity_main.xml            # Main layout with logo
    └── activity_splash.xml          # Splash screen layout
```

## 🔧 Usage Examples

### In Layouts
```xml
<!-- Main Logo -->
<ImageView
    android:layout_width="48dp"
    android:layout_height="48dp"
    android:src="@drawable/ic_agroconnect_logo"
    android:contentDescription="@string/app_name" />

<!-- Splash Logo -->
<ImageView
    android:layout_width="@dimen/logo_width"
    android:layout_height="@dimen/logo_height"
    android:src="@drawable/splash_logo" />
```

### In Code
```kotlin
// Set logo programmatically
imageView.setImageResource(R.drawable.ic_agroconnect_logo)

// For notifications
NotificationCompat.Builder(context, CHANNEL_ID)
    .setSmallIcon(R.drawable.ic_notification)
    .setLargeIcon(BitmapFactory.decodeResource(resources, R.drawable.ic_agroconnect_logo))
```

## 📐 Design Specifications

### Logo Dimensions
- **Minimum Size:** 24dp x 24dp
- **Recommended Size:** 48dp x 48dp
- **Maximum Size:** 200dp x 200dp
- **Aspect Ratio:** 1:1 (square)

### Safe Area
- **Padding:** 8dp minimum around logo
- **Clear Space:** 16dp for optimal visibility
- **Background:** Ensure sufficient contrast

### Accessibility
- **Content Description:** Always include for screen readers
- **Color Contrast:** Meets WCAG 2.1 AA standards
- **Alternative Text:** "AgroConnect Africa SMS Gateway"

## 🎯 Brand Guidelines

### Do's
✅ Use official color palette
✅ Maintain aspect ratio
✅ Ensure clear visibility
✅ Include proper spacing
✅ Use vector formats when possible

### Don'ts
❌ Distort or stretch the logo
❌ Change official colors
❌ Add effects or shadows
❌ Use low-resolution versions
❌ Place on busy backgrounds

## 🔄 Updating Logos

### To Modify Logos:
1. Edit the XML vector files
2. Maintain the same dimensions
3. Test on different screen densities
4. Verify accessibility compliance
5. Update this documentation

### Vector Advantages:
- **Scalable:** Crisp at any size
- **Small File Size:** Efficient storage
- **Themeable:** Can adapt to dark/light modes
- **Maintainable:** Easy to modify colors/shapes

## 📱 Platform Compatibility

### Android Versions
- **Android 5.0+:** Full vector support
- **Android 8.0+:** Adaptive icons
- **All Versions:** PNG fallbacks available

### Screen Densities
- **LDPI:** 120dpi (0.75x)
- **MDPI:** 160dpi (1.0x) - baseline
- **HDPI:** 240dpi (1.5x)
- **XHDPI:** 320dpi (2.0x)
- **XXHDPI:** 480dpi (3.0x)
- **XXXHDPI:** 640dpi (4.0x)

Vector drawables automatically scale to all densities.

## 🎨 Customization

### For Different Deployments:
1. **Colors:** Modify `logo_config.xml`
2. **Text:** Update `strings.xml`
3. **Sizes:** Adjust `dimens.xml`
4. **Icons:** Replace vector files

### Brand Variations:
- Regional color schemes
- Partner co-branding
- Seasonal themes
- Dark mode variants

## 📞 Support

For logo-related questions or custom branding:
- **Design Team:** design@agroconnect-africa.com
- **Technical Support:** support@agroconnect-africa.com
- **Brand Guidelines:** Available in project documentation

---

**© 2025 AgroConnect Africa. All rights reserved.**
