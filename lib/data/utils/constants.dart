import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final bool isIosApplication = defaultTargetPlatform == TargetPlatform.iOS;

const Color refuelColor = Color(0xff0bcb41);
const Color repairColor = Color(0xffe02121);
const Color washColor = Color(0xff1f5db9);

const int listLimit = 5;

const numberTypeForInputs = TextInputType.numberWithOptions(decimal: true);

const String androidPl = "android";
const String iosPl = "iOS";

const String adminEmail = "admin@admin.com";

const String dateFormat24h = "dd/MM/yyyy kk:mm";
const String dateFormat12h = "dd/MM/yyyy hh:mma";
const String dateFormat = "dd/MM/yyyy";

const String keyThemeMode = "mode";
const String keyThemeColor = "mode_color";
const String keyIsDarkColor = "mode_color_is_dark";
const String keyLanguage = "language";
const String key24Hour = "24h";
const String keyIsFirst = "first";
const String keyColorIndex = "color_index";