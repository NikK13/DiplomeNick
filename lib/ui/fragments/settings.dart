import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/lists.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/settings_ui.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isFullPage;

  const SettingsPage({Key? key, this.isFullPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullPage ? AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context, 'settings'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: appColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined
          ),
          onPressed: (){
            context.router.popForced();
          },
        )
      ) : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SettingsSection(
                title: AppLocalizations.of(context, 'common'),
                settingsItems: [
                  SettingsRow(
                    title: AppLocalizations.of(context, 'change_lang'),
                    onTap: () => showSelectionDialog(
                      context, languages,
                      "language", prefsProvider,
                      'change_lang'
                    ),
                    trailing: languages.firstWhere((element) => element.value == prefsProvider.locale!.languageCode).title,
                    icon: Icons.language_rounded,
                    isFirst: true,
                    isLast: false,
                  ),
                  SettingsRow(
                    title: AppLocalizations.of(context, 'current_theme'),
                    onTap: () => showSelectionDialog(
                      context, listOfThemes(context),
                      "theme", prefsProvider, 'themes'
                    ),
                    trailing: prefsProvider.getThemeTitle(context),
                    icon: Icons.brightness_auto,
                    isFirst: true,
                    isLast: false,
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSelectionDialog(context, List<ListItem> list, type, provider, key){
    showModalBottomSheet(
      context: context,
      backgroundColor: dialogBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)
        )
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > 500 ? 500 :
        MediaQuery.of(context).size.width
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dialogLine,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    AppLocalizations.of(context, key),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  getIconButton(
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.grey,
                    ),
                    context: context,
                    onTap: () {
                      Navigator.pop(context);
                    }
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    final item = list[index];
                    return GestureDetector(
                      onTap: (){
                        if(type == "theme"){
                          provider.savePreference(keyThemeMode, item.value);
                        }
                        if(type == "language"){
                          provider.savePreference(keyLanguage, item.value);
                        }
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Center(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).brightness == Brightness.light ?
                                  Colors.black : Colors.white,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
