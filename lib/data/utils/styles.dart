import 'package:diplome_nick/data/utils/constants.dart';
import 'package:flutter/material.dart';

const String appFont = "Nunito";

const Color appColor = Color(0xFF1878FA);

const Color colorDark = Color(0xFF141414);
const Color colorLight = Color(0xFFFFFFFF);

const Color colorNavDark = Color(0xFF202020);
const Color colorNavLight = Color(0xFFFAFAFA);

const Color colorDialogDark = Color(0xFF141414);
const Color colorDialogLight = Color(0xFFFDFDFD);

const Color colorAppBarDark = Color(0xFF202020);
const Color colorAppBarLight = Color(0xFFFAFAFA);

Color get iconBackgroundColor => Colors.grey.withOpacity(0.1);

Color backgroundColor(context) => Theme.of(context).brightness == Brightness.light ? colorLight : colorDark;

Color navigationBarColor(context) => Theme.of(context).brightness == Brightness.light ?
colorNavLight : colorNavDark;

Color dialogBackgroundColor(context) => Theme.of(context).brightness == Brightness.light ?
colorDialogLight : colorDialogDark;

Color appBarColor(context) => Theme.of(context).brightness == Brightness.light ?
colorAppBarLight : colorAppBarDark;

Color bottomBarIconColor(context, curIndex, barIndex) => curIndex == barIndex ?
Colors.white : Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;

const textStyleBtnLight = TextStyle(
    fontSize: 16,
    color: Colors.white
);

final textStyleBtnDark = TextStyle(
    fontSize: 16,
    color: Colors.green.shade700
);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: colorLight,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  useMaterial3: isIosApplication ?
  false : true,
  textTheme: const TextTheme(
    button: textStyleBtnLight,
  ),
  fontFamily: appFont,
  colorScheme: const ColorScheme.light().copyWith(secondary: Colors.white),
);

ThemeData themeDark = ThemeData(
  scaffoldBackgroundColor: colorDark,
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  useMaterial3: isIosApplication ?
  false : true,
  //floatingActionButtonTheme: fabTheme,
  textTheme: TextTheme(
    button: textStyleBtnDark,
  ),
  brightness: Brightness.dark,
  fontFamily: appFont,
  colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.black),
);

ThemeMode getThemeMode(String mode){
  switch(mode){
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

Brightness getBrightnessByTheme(mode, context){
  switch(mode){
    case 'light':
      return Brightness.light;
    case 'dark':
      return Brightness.dark;
    default:
      return Theme.of(context).brightness;
  }
}

