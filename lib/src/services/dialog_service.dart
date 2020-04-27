import 'package:flutter/material.dart';
import 'package:aduanas_app/src/widgets/appButton.dart';

enum DialogAction { yes, abort }

class Dialogs {
  

  static Widget showButton(bool exist, BuildContext context, String title, bool invertColors, bool accionButton) {
    if (exist) {
      return AppButton(
        color: Color.fromRGBO(255, 143, 52, 1),
        name: title,
        context: context,
        onPressed: accionButton ? () => Navigator.of(context).pop(DialogAction.yes):  () => Navigator.of(context).pop(DialogAction.abort),
        invertColors: invertColors
      );
    } else {
      return SizedBox(height: 0.0);
    }
  }

  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
    bool primaryButton,
    bool secondaryButton,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 22.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),            
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(body,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 18.0,
                        color: Color.fromRGBO(142, 144, 146, 1),
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 10.0,
                ),
               Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),                
                child:  showButton(primaryButton, context, "Aceptar", true, true),
                ),
               Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:  showButton(secondaryButton, context, "Cancelar", false, false),
               )     
              ],
            ),
            //actions: 
            );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}
