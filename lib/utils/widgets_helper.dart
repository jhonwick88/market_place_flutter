import 'package:flutter/material.dart';

class WidgetHelper {
  AlertDialog showAlertDialog(
      {required BuildContext context,
      required String title,
      required String message,
      required Function() actionYes}) {
    return AlertDialog(title: Text(title), content: Text(message), actions: [
      ElevatedButton(onPressed: actionYes, child: Text("Ya")),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("Tidak"))
    ]);
  }
}
