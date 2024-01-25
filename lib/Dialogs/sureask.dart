import 'package:flutter/material.dart';

Future<bool> areUSure(BuildContext context, String content) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Подтверждение'),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: const Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Подтвердить'),
              ),
            ],
          );
        },
      ) ??
      false;
}
