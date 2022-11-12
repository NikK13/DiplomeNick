import 'package:flutter/material.dart';

class Toast {
  static void show({required context, required String text, required Widget icon, String? extra, Function()? func}) {
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry overlayEntry = OverlayEntry(builder: (_) => const SizedBox.shrink());

    const Duration d = Duration(seconds: 1);
    double o = .0;

    overlayEntry = OverlayEntry(builder: (context) =>
      StatefulBuilder(
        builder: (_, setState) {
          WidgetsBinding.instance.addPostFrameCallback((__) {
            if (o == .0) {
              setState(() => o = 1.0);
              Future.delayed(const Duration(seconds: 2) + d).then((_) {
                if (overlayEntry.mounted) setState(() => o = .1);

                Future.delayed(d).then((_) {
                  if (overlayEntry.mounted) overlayEntry.remove();
                });
              });
            }
          });

          return Positioned(
            bottom: 120,
            left: 0, right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 72
              ),
              child: AnimatedOpacity(
                opacity: o,
                duration: d,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.black.withOpacity(0.75),
                    border: Theme.of(context).brightness == Brightness.dark ?
                    Border.all(color: Colors.white, width: 0.15) : null
                  ),
                  padding: const EdgeInsets.only(
                    left: 6.6, right: 15.0,
                    top: 8, bottom: 8
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: icon
                      ),
                      Flexible(
                        child: Center(
                          child: Text(
                            text,
                            style: const TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
          );
        },
      )
    );

    overlayState.insert(overlayEntry);
  }
}