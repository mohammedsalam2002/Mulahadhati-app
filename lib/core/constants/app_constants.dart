// ثوابت التطبيق العامة

class AppConstants {
  // معلومات التطبيق
  static const String appName = 'ملاحظاتي';
  static const String appNameEn = 'My Notes';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Mohammed.S';
  static const String developerEmail = 'slamhmwdy148@gmail.com';
  //static const String privacyPolicyUrl = 'https://example.com/privacy';
  //static const String termsUrl = 'https://example.com/terms';

  // أسماء صناديق Hive
  static const String notesBox = 'notes_box';
  static const String settingsBox = 'settings_box';
  static const String tagsBox = 'tags_box';

  // مفاتيح الإعدادات
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String sortKey = 'sort_method';
  static const String lockEnabledKey = 'lock_enabled';
  static const String pinHashKey = 'pin_hash';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String firstLaunchKey = 'first_launch';

  // مدد زمنية
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 2);

  // أحجام
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const int maxTitleLength = 100;
  static const int trashRetentionDays = 30;
}
