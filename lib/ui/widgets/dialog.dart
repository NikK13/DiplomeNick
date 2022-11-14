import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final Widget? action;
  final Widget? trailing;
  final Widget? child;
  final bool bottomSafeArea;

  const AppDialog({
    Key? key,
    this.action,
    this.trailing,
    required this.title,
    required this.child,
    this.bottomSafeArea = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: bottomSafeArea,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  children: [
                    dialogLine,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        trailing ?? const SizedBox(width: 40),
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        action ?? getIconButton(
                          child: const Icon(
                            Icons.clear,
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
                    child!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
