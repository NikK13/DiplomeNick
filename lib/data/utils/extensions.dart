import 'dart:convert';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

Color getThemedBackgroundColor(BuildContext context){
  return Theme.of(context).brightness == Brightness.light ?
  colorLight : const Color(0xFF181818);
}

printFullResponse(Response res){
  final code = res.statusCode;
  final url = res.request!.url;

  final full = "$url: RESPONSE CODE - $code, ${res.headers['content-type']}";
  debugPrint(full);
}

Uint8List? imageBytes(String photo){
  if(photo.isNotEmpty){
    final ph = photo.split(',').last;
    return base64.decode(ph);
  }
  return null;
}

void setLandscapeMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

void updateAddressFromMap(String place, TextEditingController controller){
  controller.text = place;
}

void setPortraitMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void setAllScreensMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

Widget iconButton(context, icon, [double size = 22]){
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: appColor,
      borderRadius: BorderRadius.circular(12)
    ),
    child: Icon(
      icon!,
      size: size,
      color: Colors.white,
    ),
  );
}

Color accent(context) => Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;

void scrollToTheTop(ScrollController scrollController){
  if(scrollController.hasClients){
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeIn
    );
  }
}

Widget getIconButton({required Widget child, required BuildContext context, Function()? onTap, Color? color}) => InkWell(
  onTap: onTap,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: color ?? (Theme.of(context).brightness == Brightness.light ?
      const Color.fromRGBO(255, 255, 255, 1) : Colors.black26),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15), //color of shadow
          spreadRadius: Theme.of(context).brightness == Brightness.light ? 2 : 0, //spread radius
          blurRadius: Theme.of(context).brightness == Brightness.light ? 4 : 2, // blur radius
          offset: Theme.of(context).brightness == Brightness.light ?
          const Offset(2, 3) : const Offset(0, 0)
        )
      ]
    ),
    padding: const EdgeInsets.all(8.0),
    child: child
  ),
);

Widget get dialogLine => Center(
  child: Container(
    margin: const EdgeInsets.only(top: 2.0, bottom: 4.0),
    height: 4.0,
    width: 24.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey.withOpacity(0.3)
    ),
  ),
);

Widget get widgetLine => Center(
  child: Container(
    margin: const EdgeInsets.only(top: 2.0, bottom: 4.0),
    height: 4.0,
    width: 24.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.white
    ),
  ),
);

void showSnackBar(context, text) {
  final isLight = Theme.of(context).brightness == Brightness.light;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 12
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isLight ? Colors.white : Colors.grey[850],
      content: Text(
        text,
        style: TextStyle(color: isLight ? Colors.black : Colors.white),
      ),
    ),
  );
}

int crossAxisCountOnWidth(BuildContext context){
  if(MediaQuery.of(context).size.width < 300){
    return 1;
  }
  if(MediaQuery.of(context).size.width < 600){
    return 2;
  }
  if(MediaQuery.of(context).size.width < 1000){
    return 3;
  }
  return 4;
}

String formattedDate(bool is12h, String date){
  DateTime dateTime = DateFormat(dateFormat24h).parse(date).add(const Duration(hours: 1));

  if(is12h){
    final h12Date = DateFormat.jm().format(dateTime);
    return "${date.substring(0, 10)} $h12Date";
  }
  else{
    final h24Date = DateFormat.Hm().format(dateTime);
    return "${date.substring(0, 10)} $h24Date";
  }
}

BoxConstraints getDialogConstraints(BuildContext context){
  return BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * 0.95
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addHour(int hour) {
    return replacing(hour: this.hour + hour, minute: minute);
  }

  TimeOfDay addMinutes(int minutes) {
    return replacing(hour: hour, minute: minute + minutes);
  }

  String format12Hour(BuildContext context) {
    TimeOfDay time = replacing(hour: hourOfPeriod);
    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    final StringBuffer buffer = StringBuffer();

    buffer
      ..write("${time.hour}:${time.minute > 9 ? time.minute : "0${time.minute}"}")
      ..write(' ')
      ..write(period == DayPeriod.am
        ? localizations.anteMeridiemAbbreviation
        : localizations.postMeridiemAbbreviation);

    return '$buffer';
  }
}

extension DoubleExtension on String {
  double toDBDouble() {
    return double.parse(replaceAll(',', '.'));
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}