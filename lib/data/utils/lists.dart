import 'package:diplome_nick/data/utils/localization.dart';

class ListItem{
  String title;
  String value;

  ListItem(this.title, this.value);
}

List<ListItem> get languages => List.from([
  ListItem("English", 'en'),
  ListItem("Русский", 'ru'),
]);

List<ListItem> listOfThemes(context) => List<ListItem>.from([
  ListItem(AppLocalizations.of(context, 'theme_light'), 'light'),
  ListItem(AppLocalizations.of(context, 'theme_dark'), 'dark')
]);