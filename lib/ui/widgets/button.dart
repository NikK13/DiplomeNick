import 'package:diplome_nick/data/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Function()? onPressed;
  final Function? onLongPress;
  final double borderRadius;

  const AppButton({
    Key? key,
    @required this.text,
    this.fontSize = 20,
    @required this.onPressed,
    this.onLongPress,
    this.borderRadius = 500
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed!,
      onLongPress: () => onLongPress != null ?
      onLongPress!() : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: appColor,
        textStyle: const TextStyle(
          fontFamily: appFont,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.7,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      )
    );
  }
}
