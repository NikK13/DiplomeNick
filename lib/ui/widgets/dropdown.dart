import 'package:diplome_nick/data/utils/lists.dart';
import 'package:flutter/material.dart';

class DropdownPicker extends StatelessWidget {
  final String? title;
  final String? myValue;
  final List<ListItem>? items;
  final double borderRadius;
  final Function? onChange;
  final Function? onSubmit;
  final Color darkColor;

  const DropdownPicker({
    Key? key,
    this.title,
    this.myValue,
    this.items,
    this.onChange,
    this.onSubmit,
    this.darkColor = const Color(0xFF181818),
    this.borderRadius = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment : CrossAxisAlignment.start,
      children: <Widget> [
        Text(" $title",
          maxLines: 1,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600
          )
        ),
        const SizedBox(height: 4),
        InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                ? Colors.black : Colors.white,
                width: 1
              )
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                ? Colors.black : Colors.white,
                width: 1
              )
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                ? Colors.black : Colors.white,
                width: 1
              )
            ),
            contentPadding: const EdgeInsets.all(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: myValue,
              isDense: true,
              isExpanded: true,
              items: items!.map((ListItem item) {
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(
                    item.title
                  ),
                );
              }).toList(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.dark ?
                Colors.white : Colors.black,
              ),
              selectedItemBuilder: (BuildContext ctx) {
                return items!.map<Widget>((ListItem item) {
                  return DropdownMenuItem(
                    value: item.value,
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light ?
                        Colors.black : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                      )
                    )
                  );
                }).toList();
              },
              onChanged: onChange != null ?
              (val) async => await onChange!(val) : null,
            ),
          ),
        ),
      ]
    );
  }
}
