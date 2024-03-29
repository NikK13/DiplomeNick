import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final String? hint;
  final Function? onTap;
  final bool isEnabled;
  final bool isPassword;
  final bool isOnlyNum;
  final double borderRadius;
  final TextInputType? inputType;
  final TextEditingController? controller;

  const InputField({
    Key? key,
    this.hint,
    this.controller,
    this.isEnabled = true,
    this.isPassword = false,
    this.isOnlyNum = false,
    this.borderRadius = 50,
    this.onTap,
    this.inputType = TextInputType.text
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _passwordIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null ? () => widget.onTap!() : null,
      child: TextField(
        enabled: widget.onTap == null,
        controller: widget.controller,
        keyboardType: widget.inputType,
        cursorColor: appColor,
        textInputAction: TextInputAction.done,
        obscureText: widget.isPassword ?
        !_passwordIsVisible : false,
        enableSuggestions: !widget.isPassword,
        autocorrect: !widget.isPassword,
        inputFormatters: widget.isOnlyNum ? <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
        ] : null, // Only nu
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 16
          ),
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(
              _passwordIsVisible
                ? Icons.visibility
                : Icons.visibility_off,
              color: appColor,
            ),
            onPressed: () {
              setState(() {
                _passwordIsVisible = !_passwordIsVisible;
              });
            },
          ) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
              ? Colors.black : Colors.white,
              width: 1
            )
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
              ? Colors.black : Colors.white,
              width: 1
            )
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
              ? Colors.black : Colors.white,
              width: 1
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
              ? Colors.black : Colors.white,
              width: 1
            )
          ),
          hintText: widget.hint ?? "",
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16
          )
      ),
      ),
    );
  }
}