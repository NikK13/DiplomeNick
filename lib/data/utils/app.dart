import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App {
  static const String appName = "TickBook";
  static String platform = defaultTargetPlatform.name;

  static const appPadding = EdgeInsets.only(
    right: 20, left: 20, top: 32
  );

  static List<String> get supportedLanguages => ["en", "ru"];

  static final Iterable<LocalizationsDelegate<dynamic>> delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultMaterialLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  static final supportedLocales = [
    const Locale('en', ''),
    const Locale('ru', ''),
  ];

  static setupBar(bool isLight) => SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarColor: isLight ? const Color(0x00000000) : Colors.transparent,
      systemNavigationBarColor: isLight ? colorLight : colorDark,
    ),
  );
}
