// payment variants
import 'package:myevpanet4/Models/account.dart';

List<Map<String, dynamic>> payVariants(Account account) => [
      {
        'name': 'Robokassa',
        'id': 0,
        'icon': 'https://my.evpanet.com/images/robokassa.jpg',
        'comment': 'Комиссия составляет 6%',
        'askSumm': true,
        'needPaymentNo': true,
        'payUrl': ''
      },
      {
        'name': 'Payberry',
        'id': 1,
        'icon': 'https://my.evpanet.com/images/payberry.jpg',
        'comment': 'Комиссия будет показана на сайте',
        'payUrl': 'https://payberry.ru/pay/26?acc=${account.id}'
      },
    ];
