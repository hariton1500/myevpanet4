import 'package:flutter/material.dart';

Future<int?> askSumm(BuildContext context) {
  return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int summa = 0;
        return SimpleDialog(
          title: const Text('Введите сумму'),
          children: [
            TextFormField(
              onChanged: (value) => summa = int.parse(value),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сумма',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите сумму';
                }
                return value;
              },
            ),
            SimpleDialogOption(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: const Text('Подтвердить'),
              onPressed: () {
                Navigator.of(context).pop(int.parse(summa.toString()));
              },
            ),
          ],
        );
      }).then((value) => value);
}
