import 'package:flutter/material.dart';

Future<void> infoWithOk(BuildContext context, Widget info) async {
  return showAdaptiveDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text(
          'Информация:',
          textAlign: TextAlign.center,
        ),
        content: info,
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
