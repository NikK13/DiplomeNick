import 'dart:ui';
import 'package:diplome_nick/data/model/preferences.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider extends ChangeNotifier {
  SharedPreferences? sp;

  String? currentTheme;
  Locale? locale;

  PreferenceProvider() {
    _loadFromPrefs();
  }

  _initPrefs() async {
    sp ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    if (sp!.getString(keyThemeMode) == null) await sp!.setString(keyThemeMode, "light");
    if (sp!.getString(keyLanguage) == null) {
      switch (window.locale.languageCode) {
        case 'en':
        case 'ru':
          locale = Locale(window.locale.languageCode, '');
          break;
        default:
          locale = const Locale('ru', '');
      }
    } else {
      locale = Locale(sp!.getString(keyLanguage)!, '');
    }
    currentTheme = sp!.getString(keyThemeMode);
    notifyListeners();
  }

  savePreference(String key, value) async {
    await _initPrefs();
    switch (key) {
      case keyThemeMode:
        sp!.setString(key, value);
        currentTheme = sp!.getString(keyThemeMode);
        break;
      case keyLanguage:
        sp!.setString(key, value);
        locale = Locale(sp!.getString(keyLanguage)!, '');
        break;
    }
    notifyListeners();
  }

  Preferences get preferences => Preferences(
    locale: locale,
    theme: currentTheme,
  );

  String? getThemeTitle(BuildContext context) {
    switch (sp!.getString(keyThemeMode)) {
      case 'light':
        return AppLocalizations.of(context, 'theme_light');
      case 'dark':
        return AppLocalizations.of(context, 'theme_dark');
      case 'system':
        return AppLocalizations.of(context, 'theme_system');
      default:
        return "";
    }
  }
}
