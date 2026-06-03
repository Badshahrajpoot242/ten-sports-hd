// lib/data/models/app_settings_model.dart

class AppSettingsModel {
  final String appName;
  final String appLogo;
  final String bannerImage;
  final bool maintenanceMode;
  final String privacyPolicy;
  final String contactEmail;

  AppSettingsModel({
    required this.appName,
    required this.appLogo,
    required this.bannerImage,
    required this.maintenanceMode,
    required this.privacyPolicy,
    required this.contactEmail,
  });

  factory AppSettingsModel.fromMap(Map<dynamic, dynamic> map) {
    return AppSettingsModel(
      appName: map['app_name']?.toString() ?? 'TEN SPORTS HD',
      appLogo: map['app_logo']?.toString() ?? '',
      bannerImage: map['banner_image']?.toString() ?? '',
      maintenanceMode:
          map['maintenance_mode'] == true || map['maintenance_mode'] == 'true',
      privacyPolicy: map['privacy_policy']?.toString() ?? '',
      contactEmail:
          map['contact_email']?.toString() ?? 'sultanprince0258@gmail.com',
    );
  }

  factory AppSettingsModel.defaults() {
    return AppSettingsModel(
      appName: 'TEN SPORTS HD',
      appLogo: '',
      bannerImage: '',
      maintenanceMode: false,
      privacyPolicy: 'Privacy policy not available.',
      contactEmail: 'sultanprince0258@gmail.com',
    );
  }
}
