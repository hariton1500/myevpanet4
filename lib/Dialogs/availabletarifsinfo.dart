import 'package:flutter/material.dart';
import 'package:myevpanet4/Models/account.dart';

Future<void> showAvailableTariffs(BuildContext context, Account acc) async {
  return showAdaptiveDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text(
          'Доступные тарифы для вашего подключения:',
          textAlign: TextAlign.center,
        ),
        content: Column(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: acc.tarifs
                    .map((e) => Text(
                          '${(e as Map)['name']} - ${(e)['sum']} руб.',
                        ))
                    .toList()),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
                children: [
                  TextSpan(
                    text:
                        'Для тарифов выше 100 Мбит/с обязательно наличие Гигабитного WiFi роутера.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '\n\n'),
                  TextSpan(
                    text: 'Роутер можно приобрести в магазине или ',
                  ),
                  TextSpan(
                    text:
                        'заказать в офисе Евпанет по адресу 60 Лет Октября 26',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
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
