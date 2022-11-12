import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/ui/widgets/ripple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final String? title;
  final String? trailing;
  final Function? onTap;
  final Function? onLongTap;
  final IconData? icon;
  final Widget? switchData;
  final bool? isFirst;
  final bool? isLast;

  const SettingsRow({
    Key? key,
    required this.title,
    required this.onTap,
    this.trailing,
    required this.icon,
    this.switchData,
    this.onLongTap,
    required this.isLast,
    required this.isFirst
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () => onTap!(),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                left: 4, right: 8,
                top: trailing != null ? 12 : 15,
                bottom: trailing != null ? 12 : 15
              ),
              child:Row(
                children: [
                  Icon(
                    icon!,
                    size: 32,
                    color: Theme.of(context).brightness == Brightness.dark ?
                    Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                        ),
                        if(trailing != null)
                        Text(
                          trailing!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: appColor,
                            fontWeight: FontWeight.w700
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  if(switchData != null)
                  switchData!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsTitle extends StatelessWidget {
  final String? title;

  const SettingsTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        title!,
        style: const TextStyle(
          fontFamily: appFont,
          fontWeight: FontWeight.w700,
          color: appColor,
          fontSize: 14,
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsRow>? settingsItems;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.settingsItems
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsTitle(title: title),
        Padding(
          padding: EdgeInsets.only(
            bottom: defaultTargetPlatform == TargetPlatform.iOS ? 0 : 32
          ),
          child: ListView.builder(
            itemCount: settingsItems!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return settingsItems![index];
            },
          ),
        ),
      ],
    );
  }
}


