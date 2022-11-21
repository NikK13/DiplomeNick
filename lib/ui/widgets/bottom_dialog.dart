import 'package:diplome_nick/data/utils/styles.dart';
import 'package:flutter/material.dart';

showInfoDialog(context, String text){
  showDialog(
    context: context,
    builder: (context) => Center(
      child: Container(
        decoration: BoxDecoration(
          color: dialogBackgroundColor(context),
          borderRadius: BorderRadius.circular(16)
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outlined, color: Colors.red, size: 150),
            const SizedBox(height: 20),
            Text(text, style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16
            )),
            const SizedBox(height: 20),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: appColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: appFont
                )
              ),
              child: const Text(
                "OK"
              )
            ),
          ],
        ),
      ),
    )
  );
}

showBottomSheetDialog(context, Widget child){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: dialogBackgroundColor(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16)
      )
    ),
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width > 500 ? 500 :
      MediaQuery.of(context).size.width,
    ),
    builder: (ctx) => child
  );
}