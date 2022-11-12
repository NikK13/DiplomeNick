import 'package:flutter/material.dart';

class Ripple extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final double? radius;
  final double elevation;
  final Color? rippleColor;

  const Ripple({
    Key? key,
    this.child,
    this.onTap,
    this.onLongPress,
    this.elevation = 0,
    this.radius,
    this.rippleColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(radius!)),
      color: rippleColor ?? Colors.transparent,
      elevation: elevation,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(radius!)),
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
