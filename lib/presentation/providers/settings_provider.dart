import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

// مزود الإعدادات - يدير الثيم واللغة وإعدادات الأمان

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ar');
  bool _lockEnabled = false;
  bool _biometricEnabled = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get lockEnabled => _lockEnabled;
  bool get biometricEnabled => _biometricEnabled;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';

  // تحميل الإعدادات المحفوظة
  void _loadSettings() {
    final themeIndex = _prefs.getInt(AppConstants.themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    final localeCode = _prefs.getString(AppConstants.localeKey) ?? 'ar';
    _locale = Locale(localeCode);

    _lockEnabled = _prefs.getBool(AppConstants.lockEnabledKey) ?? false;
    _biometricEnabled = _prefs.getBool(AppConstants.biometricEnabledKey) ?? false;
  }

  // تغيير الثيم
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(AppConstants.themeKey, mode.index);
    notifyListeners();
  }

  // تبديل الوضع الليلي
  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  // تغيير اللغة
  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await _prefs.setString(AppConstants.localeKey, languageCode);
    notifyListeners();
  }

  // تفعيل/تعطيل القفل
  Future<void> setLockEnabled(bool enabled) async {
    _lockEnabled = enabled;
    await _prefs.setBool(AppConstants.lockEnabledKey, enabled);
    if (!enabled) {
      _biometricEnabled = false;
      await _prefs.setBool(AppConstants.biometricEnabledKey, false);
    }
    notifyListeners();
  }

  // تفعيل/تعطيل البصمة
  Future<void> setBiometricEnabled(bool enabled) async {
    _biometricEnabled = enabled;
    await _prefs.setBool(AppConstants.biometricEnabledKey, enabled);
    notifyListeners();
  }
}
