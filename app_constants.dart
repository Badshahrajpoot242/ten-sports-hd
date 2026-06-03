// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TEN SPORTS HD';
  static const String appVersion = '1.0.0';
  static const String contactEmail = 'sultanprince0258@gmail.com';
  static const String playStoreUrl = 'https://play.google.com/store/apps';

  // Firebase Paths
  static const String buttonsPath = 'buttons';
  static const String videosPath = 'videos';
  static const String settingsPath = 'settings';

  // Settings Keys
  static const String keyAppName = 'app_name';
  static const String keyAppLogo = 'app_logo';
  static const String keyBannerImage = 'banner_image';
  static const String keyMaintenanceMode = 'maintenance_mode';
  static const String keyPrivacyPolicy = 'privacy_policy';
  static const String keyContactEmail = 'contact_email';

  // Video Types
  static const String typeM3u8 = 'm3u8';
  static const String typeMp4 = 'mp4';
  static const String typeYoutube = 'youtube';

  // Splash Duration
  static const int splashDurationSeconds = 10;

  // Max Videos per Category
  static const int maxVideosPerCategory = 20;

  // FCM Topics
  static const String topicMatchAlerts = 'match_alerts';
  static const String topicBreakingNews = 'breaking_news';
  static const String topicAll = 'all_users';

  // Ad Unit IDs (Test IDs - Replace with real ones)
  static const String admobBannerAdId = 'ca-app-pub-3940256099942544/6300978111';
  static const String admobInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String admobRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';

  // Drawer Items
  static const List<Map<String, String>> drawerItems = [
    {'title': 'Home', 'icon': 'home'},
    {'title': 'Privacy Policy', 'icon': 'privacy'},
    {'title': 'Contact Us', 'icon': 'contact'},
    {'title': 'Share App', 'icon': 'share'},
    {'title': 'Rate App', 'icon': 'rate'},
    {'title': 'Exit', 'icon': 'exit'},
  ];
}
