# Odelle Nyse - Asset and Branding Guide

This guide provides instructions on how to incorporate your visual assets (app icons, logos, splash screens, etc.) into the Odelle Nyse Flutter application.

## 1. App Icons

You need to replace the default Flutter app icons with your custom Odelle Nyse icons.

**Design Requirements (from project documentation):**
*   **Primary Logo Concept:** An elegant, minimalist representation of the letter "O" with a subtle spiritual element.
*   **Resolution:** 1024x1024px for the primary logo.
*   **Format:** PNG with transparency.
*   **Style:** Clean, modern, with a hint of depth.
*   **Color:** Use the app's primary color palette (#8ECAE6, #219EBC).
*   **iOS:** Follow Apple's icon guidelines with all required sizes.
*   **Android:** Follow Material Design icon guidelines.

**Implementation:**

### a. iOS App Icons
1.  Locate the directory: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`.
2.  Replace the placeholder icon files in this directory with your own generated icon files. Ensure you provide all the required sizes as specified by Apple. Tools like [App Icon Generator](https://appicon.co/) can help generate these sizes from your 1024x1024px primary logo.
3.  Verify `Contents.json` in this directory correctly lists your icon files.

### b. Android App Icons
1.  Locate the directories: `android/app/src/main/res/mipmap-*/` (e.g., `mipmap-hdpi`, `mipmap-mdpi`, etc.).
2.  Replace the placeholder `ic_launcher.png` files in these directories with your own generated icon files. Android uses different resolutions for different screen densities.
3.  Consider using Android Studio's "Image Asset Studio" to generate these icons correctly from your primary logo:
    *   Right-click the `res` directory in Android Studio.
    *   Select New > Image Asset.
    *   Configure the launcher icons.

## 2. Splash Screen

Update the launch (splash) screens for both iOS and Android.

### a. iOS Splash Screen
1.  Locate `ios/Runner/Base.lproj/LaunchScreen.storyboard`.
2.  Open this file in Xcode.
3.  Edit the storyboard to include your Odelle Nyse logo. You might want to:
    *   Set a background color matching `AppColors.background`.
    *   Add an `UIImageView` and set its image to your logo.
    *   Use Auto Layout constraints to position the logo correctly.
4.  Alternatively, if you prefer a simpler setup, you can configure the launch screen programmatically or use a solid background color with a centered image via the `Info.plist` (though Storyboard is common).

### b. Android Splash Screen
1.  **Background Color:**
    *   Open `android/app/src/main/res/values/colors.xml` (create if it doesn't exist).
    *   Define your splash screen background color, e.g.:
        ```xml
        <?xml version="1.0" encoding="utf-8"?>
        <resources>
            <color name="splash_background">#F8F9FA</color> <!-- Corresponds to AppColors.background -->
        </resources>
        ```
    *   Open `android/app/src/main/res/drawable/launch_background.xml` (or `launch_background.xml` in `drawable-v21` etc.).
    *   It might look something like this:
        ```xml
        <?xml version="1.0" encoding="utf-8"?>
        <!-- You can insert your own splash screen drawable or color here -->
        <layer-list xmlns:android="http://schemas.android.com/apk/res/android">
            <item android:drawable="@color/splash_background" />
            <!-- You can add a bitmap item to display a logo here -->
            <!--
            <item>
                <bitmap
                    android:gravity="center"
                    android:src="@mipmap/your_logo_for_splash" />
            </item>
            -->
        </layer-list>
        ```
2.  **Logo (Optional):**
    *   If you want to display a logo on the splash screen, add your logo image to the `android/app/src/main/res/mipmap-*` directories.
    *   Uncomment and modify the `<item>` with `<bitmap>` in `launch_background.xml` to reference your logo.
3.  **Theme Update:**
    *   Ensure your `android/app/src/main/res/values/styles.xml` references this drawable for the launch theme:
        ```xml
        <?xml version="1.0" encoding="utf-8"?>
        <resources>
            <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
                <item name="android:windowBackground">@drawable/launch_background</item>
            </style>
            <!-- You can add other styles here -->
        </resources>
        ```
    *   The `MainActivity` in `AndroidManifest.xml` should use `@style/LaunchTheme`.

## 3. Other Image Assets (e.g., for Affirmation Cards, Hero's Journey)

The project documentation mentions:
*   **Background Patterns:** Subtle, light patterns for gradient backgrounds.
*   **Affirmation Card Images:** Calming imagery for each affirmation category.
*   **Hero's Journey Icons:** Simple icons for each journey stage.

### a. Adding Assets to the Project
1.  Create an `assets` folder in your project's root directory if it doesn't exist. It's common to create a subfolder like `assets/images/`.
    ```
    project_root/
      assets/
        images/
          my_pattern.png
          affirmation_joy.png
          hero_stage1_icon.png
      lib/
      ...
    ```
2.  Place your image files into this `assets/images/` directory.

### b. Declaring Assets in `pubspec.yaml`
Open your `pubspec.yaml` file and declare the asset folder so Flutter knows to include them in the app bundle:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/ # This includes all files in the images folder
    # If you want to be more specific:
    # - assets/images/my_pattern.png
    # - assets/images/affirmation_joy.png
```
Ensure correct indentation.

### c. Using Assets in Your Code
You can then use these assets in your Flutter widgets, for example:

```dart
Image.asset('assets/images/affirmation_joy.png')

Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/images/my_pattern.png"),
      fit: BoxFit.cover,
    ),
  ),
)
```

---
This guide provides a general overview. Specific implementation details might vary based on your exact design and asset files. Refer to the official Flutter documentation on [Adding assets and images](https://docs.flutter.dev/ui/assets/assets-and-images) for more details.
```
