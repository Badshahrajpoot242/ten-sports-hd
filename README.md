# TEN SPORTS HD — Flutter App

**Professional Live Sports Streaming App for Android**

---

## 📁 Project Structure

```
ten_sports_hd/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── config/
│   │   └── app_theme.dart           # Theme, colors, constants
│   ├── models/
│   │   └── category_model.dart      # Data models (Category, SubCategory, VideoLink, Notification)
│   ├── services/
│   │   ├── data_service.dart        # Data provider (local → Firebase)
│   │   ├── firebase_service.dart    # Firebase stub (ready to connect)
│   │   └── ads_service.dart         # AdMob stub (ready to connect)
│   ├── providers/
│   │   └── app_provider.dart        # App state (Provider)
│   ├── screens/
│   │   ├── home/
│   │   │   └── home_screen.dart     # Home screen with 10 sport buttons
│   │   ├── categories/
│   │   │   └── sub_category_screen.dart # Nested navigation screens
│   │   ├── player/
│   │   │   └── video_player_screen.dart # HLS/MP4/YouTube player
│   │   └── drawer_pages/
│   │       └── contact_screen.dart  # Contact Us page
│   └── widgets/
│       ├── sport_category_card.dart # Reusable UI components
│       └── app_drawer.dart          # Navigation drawer
├── assets/
│   ├── fonts/                       # Add Rajdhani fonts here
│   ├── images/                      # Thumbnails, logos
│   ├── icons/                       # Sport icons
│   └── animations/                  # Lottie files
└── android/                         # Android platform code
```

---

## 🚀 Setup Instructions

### Step 1: Install Flutter
Download Flutter SDK from https://flutter.dev/docs/get-started/install

### Step 2: Get dependencies
```bash
flutter pub get
```

### Step 3: Add Fonts (Optional but recommended)
Download Rajdhani from https://fonts.google.com/specimen/Rajdhani
Place in `assets/fonts/`:
- Rajdhani-Regular.ttf
- Rajdhani-Bold.ttf
- Rajdhani-SemiBold.ttf

**If you skip fonts**, remove the `fonts:` section from `pubspec.yaml`.

### Step 4: Run the app
```bash
flutter run
```

### Step 5: Build APK
```bash
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔥 Connect Firebase (When Ready)

1. Create Firebase project at https://console.firebase.google.com
2. Add Android app with package ID: `com.tensportshd.app`
3. Download `google-services.json` → place in `android/app/`
4. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
5. In `pubspec.yaml`, uncomment:
   - `firebase_core`
   - `cloud_firestore`
   - `firebase_messaging`
6. In `android/build.gradle`, uncomment:
   - `classpath 'com.google.gms:google-services:4.4.0'`
7. In `android/app/build.gradle`, uncomment:
   - `id "com.google.gms.google-services"`
8. In `android/settings.gradle`, uncomment the Google Services plugin
9. In `main.dart`, uncomment `FirebaseService.initialize()`

**All UI code stays the same!** Only `data_service.dart` needs updating.

---

## 📺 Connect AdMob Ads (When Ready)

1. Create AdMob account at https://admob.google.com
2. Create Android app and get 3 Ad Unit IDs (Banner, Interstitial, Rewarded)
3. In `pubspec.yaml`, uncomment `google_mobile_ads`
4. In `android/app/AndroidManifest.xml`, uncomment the AdMob App ID meta-data
5. Replace test IDs in `ads_service.dart` with your real Ad Unit IDs
6. In `widgets/sport_category_card.dart`, replace `BannerAdPlaceholder` with real `AdWidget`

---

## ➕ Add More Sports / Channels

Edit `lib/services/data_service.dart` → `_loadLocalData()` method.

Follow the pattern:
```dart
CategoryModel(
  id: 'unique_id',
  title: 'SPORT NAME',
  subtitle: 'Description',
  iconEmoji: '⚽',
  isLive: true,
  subCategories: [
    SubCategoryModel(
      id: 'sub_id',
      title: 'Match Name',
      subtitle: 'Details',
      videoLinks: [
        VideoLinkModel(
          id: 'link_id',
          title: 'Channel Name HD',
          url: 'https://your-stream.m3u8',
          type: VideoType.hls,
          quality: 'HD',
        ),
      ],
    ),
  ],
),
```

---

## 📱 Features Implemented

✅ 10 Sport Categories (Cricket, Football, Hockey, Tennis, Boxing, F1, Basketball, Snooker, Women's Cricket, Live TV)  
✅ Infinite nested navigation (Category → Sub → Sub → Player)  
✅ HLS (.m3u8) streaming support  
✅ MP4 video support  
✅ YouTube video support  
✅ Full-screen video player (Chewie + video_player)  
✅ Navigation Drawer (Home, Share, Privacy, Contact, Exit)  
✅ Contact Us page with email  
✅ Firebase-ready architecture  
✅ AdMob-ready structure (Banner, Interstitial, Rewarded placeholders)  
✅ Responsive UI (phones + tablets)  
✅ Live badges on active categories  
✅ Error handling + retry in player  
✅ Clean architecture with Provider state management  
✅ Null safety (Dart 3.x)  

---

## 📧 Contact

**sultanprince025@gmail.com**
