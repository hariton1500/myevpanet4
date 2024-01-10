import 'package:flutter/material.dart';

Future<void> showConfirmationDialogChangeTariff(BuildContext context, VoidCallback onConfirmed) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Подтверждение'),
        content: const Text('Вы уверены, что хотите изменить тариф?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: onConfirmed,
            child: const Text('Подтвердить'),
          ),
        ],
      );
    },
  );
}
