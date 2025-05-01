import 'package:flutter/material.dart';

Future<int?> askSumm(BuildContext context) {
  return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int summa = 0;
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(15),
          title: const Text('Введите сумму'),
          children: [
            TextFormField(
              initialValue: summa.toString(),
              onChanged: (value) {
                try {
                  summa = int.parse(value);
                } catch (e) {
                  summa = 0;
                }
              },
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
