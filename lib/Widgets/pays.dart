///
///'https://paymaster.ru/payment/init?LMI_MERCHANT_ID=95005d6e-a21d-492a-a4c5-c39773020dd3&LMI_PAYMENT_AMOUNT=$value&LMI_CURRENCY=RUB&LMI_PAYMENT_NO=${abonent.lastApiMessage}&LMI_PAYMENT_DESC=%D0%9F%D0%BE%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%20EvpaNet%20ID%20${abonent.users[currentUserIndex].id}'
///

import 'package:flutter/material.dart';
import 'package:myevpanet4/Dialogs/paymentsumm.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/constants.dart';
import 'package:myevpanet4/globals.dart';
import 'package:url_launcher/url_launcher.dart';

Widget payVariantsWidget(Account account, BuildContext context, String guid) {
  //int summa = 0;
  return DropdownMenu<String>(
      leadingIcon: const Icon(Icons.payment),
      onSelected: (varik) {
        print('value: $varik');
        switch (varik) {
          case 'Robokassa':
            askSumm(context).then((summa) {
              print(summa);
              if (summa != null && summa > 0) {
                postGetPaymentNo(token: token, guid: guid).then((value) {
                  if (value != null && value.isNotEmpty) {
                    String url =
                        'https://paymaster.ru/payment/init?LMI_MERCHANT_ID=95005d6e-a21d-492a-a4c5-c39773020dd3&LMI_PAYMENT_AMOUNT=${(summa * 1.06).ceil()}&LMI_CURRENCY=RUB&LMI_PAYMENT_NO=$value&LMI_PAYMENT_DESC=%D0%9F%D0%BE%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%20EvpaNet%20ID%20${account.id}';
                    print(url);
                    launchUrl(Uri.parse(url));
                  }
                });
              }
            });

            /*
            showDialog<int>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Введите сумму пополнения:'),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (summ) {
                        print(summ);
                        summa = int.parse(summ);
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(0);
                          },
                          child: const Text('Отмена')),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(summa);
                        },
                        child: const Text('Перейти к оплате'),
                      )
                    ],
                  );
                }).then((value) {
              if (value != null && value > 0) {
                postGetPaymentNo(token: token, guid: account.guid!)
                    .then((value) {
                  if (value != null && value.isNotEmpty) {
                    String url =
                        'https://paymaster.ru/payment/init?LMI_MERCHANT_ID=95005d6e-a21d-492a-a4c5-c39773020dd3&LMI_PAYMENT_AMOUNT=$summa&LMI_CURRENCY=RUB&LMI_PAYMENT_NO=$value&LMI_PAYMENT_DESC=%D0%9F%D0%BE%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%20EvpaNet%20ID%20${account.id}';
                    print(url);
                    launchUrl(Uri.parse(url));
                  }
                });
              }
            });*/
            break;
          default:
        }

        //launchUrl(Uri.parse(value['payUrl']));
      },
      //initialSelection: 0,
      //errorText: 'error text',
      hintText: 'Пополнить online',
      width: 300,
      dropdownMenuEntries: payVariants(account)
          .map(
            (e) => DropdownMenuEntry<String>(
                value: e['name'],
                label: e['name'],
                labelWidget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      Image.network(e['icon']),
                      Text(
                        e['comment'],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                )),
          )
          .toList());
}
