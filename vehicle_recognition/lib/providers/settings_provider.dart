import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

class SettingsProvider extends ChangeNotifier {
  static const String keyDarkMode = 'dark_mode';
  static const String keyLanguage = 'language';
  static const String keyCurrency = 'currency';
  static const String keyCountry = 'country';

  late SharedPreferences _prefs;
  late Settings _settings;

  Settings get settings => _settings;
  bool get isDarkMode => _settings.isDarkMode;
  String get language => _settings.language;
  String get currency => _settings.currency;
  String get country => _settings.country;

  SettingsProvider() {
    _settings = Settings();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _settings = Settings(
      isDarkMode: _prefs.getBool(keyDarkMode) ?? false,
      language: _prefs.getString(keyLanguage) ?? 'English',
      currency: _prefs.getString(keyCurrency) ?? 'USD',
      country: _prefs.getString(keyCountry) ?? 'Nicaragua',
    );
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(keyDarkMode, value);
    _settings = _settings.copyWith(isDarkMode: value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    await _prefs.setString(keyLanguage, value);
    _settings = _settings.copyWith(language: value);
    notifyListeners();
  }

  Future<void> setCurrency(String value) async {
    await _prefs.setString(keyCurrency, value);
    _settings = _settings.copyWith(currency: value);
    notifyListeners();
  }

  Future<void> setCountry(String value) async {
    await _prefs.setString(keyCountry, value);
    _settings = _settings.copyWith(country: value);
    notifyListeners();
  }
}
