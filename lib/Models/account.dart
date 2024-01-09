import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/globals.dart';

class Account {
  String? guid;
  int id = -1;
  String name = '';
  double balance = 0.0;
  String endDate = '';
  int daysRemain = 0;
  String password = '';
  double debt = 0.0;
  String tarifName = '';
  int tarifSum = 0;
  String ip = '';
  String street = '', house = '', flat = '';
  bool auto = false, parentControl = false;
  List<dynamic> tarifs = [];
  int dayPrice = 0;
  bool? isRealIp;

  Account();

  Account.loadFromServerJson(Map<String, dynamic> user, String guid) {
    guid = guid;
    id = int.parse(user['id']);
    name = user['name'];
    balance = double.parse(user['extra_account']);
    password = user['clear_pass'];
    daysRemain = (int.parse(user['packet_secs']) / 60 / 60 / 24).round();
    endDate = user['packet_end'] ?? '00.00.0000 00:00';
    debt = double.parse(user['debt'] ?? 0.0);
    tarifName = user['tarif_name'];
    tarifSum = int.parse(user['tarif_sum'].toString());
    ip = user['real_ip'];
    street = user['street'];
    house = user['house'];
    flat = user['flat'];
    auto = user['auto_activation'] == '1';
    parentControl = user['flag_parent_control'] == '1';
    tarifs = List.from(user['allowed_tarifs']);
    dayPrice = user['days_price'];
    isRealIp = user['flag_white_ip'] == '1';
  }

  Account.fromJson(Map<String, dynamic> json) {
    //guid = json['guid'] ?? '';
    id = json['id'];
    name = json['name'] ?? '';
    balance = json['balance'];
    endDate = json['endDate'] ?? '';
    daysRemain = json['daysRemain'];
    password = json['password'] ?? '';
    debt = json['debt'];
    tarifName = json['tarifName'] ?? '';
    tarifSum = json['tarifSum'];
    ip = json['ip'] ?? '';
    street = json['street'] ?? '';
    house = json['house'] ?? '';
    flat = json['flat'] ?? '';
    auto = json['auto'] == '1';
    parentControl = json['parentControl'] == '1';
    tarifs = List.from(json['tarifs']);
    dayPrice = json['dayPrice'] ?? 0;
    isRealIp = json['isRealIp'] == '1';
  }

  Account reload() {
    return this;
  }

  String toJson() {
    return json.encode({
      //'guid': guid,
      'id': id,
      'name': name,
      'balance': balance,
      'endDate': endDate,
      'daysRemain': daysRemain,
      'password': password,
      'debt': debt,
      'tarifName': tarifName,
      'tarifSum': tarifSum,
      'ip': ip,
      'street': street,
      'house': house,
      'flat': flat,
      'auto': auto,
      'parentControl': parentControl,
      'tarifs': tarifs,
      'dayPrice': dayPrice,
      'isRealIp': isRealIp
    });
  }

  List show() {
    return [id, name, balance, ip];
  }

  Widget accountWidgetSmall(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        shape: const RoundedRectangleBorder(
            side: BorderSide(width: 0.4, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        elevation: index.toDouble() + 3,
        child: ListTile(
          leading: Text('ID:\n$id'),
          title: Text(name),
          subtitle: Text('$tarifName\nАбонплата: $tarifSum руб.'),
          trailing: Text('Счет:\n${balance - debt} руб.'),
        ),
      ),
    );
  }

  Widget accountWidgetFull(BuildContext context,
      {VoidCallback? onEdit, required String guid}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Text('ID:\n$id'),
              Text('ФИО: $name'),
              const Divider(),
              Text('Адрес: $street, $house, $flat'),
              const Divider(),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text('Текущий тариф: $tarifName'),
                  ElevatedButton(
                      onPressed: () {},
                      //icon: const Icon(Icons.price_change),
                      child: const Text('Изменить тариф')),
                ],
              ),
              const Divider(),
              Text('Абонплата: $tarifSum руб. ($dayPrice руб. в сутки)'),
              const Divider(),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10.0,
                children: [
                  Text('Счет: $balance руб.'),
                  ElevatedButton(
                      onPressed: () {},
                      //icon: const Icon(Icons.currency_ruble),
                      child: const Text('Пополнить online')),
                ],
              ),
              debt == 0 ? const SizedBox() : const Divider(),
              debt == 0 ? const SizedBox() : Text('Задолжность: $debt руб.'),
              const Divider(),
              Text(
                  'Дата окончания действия текущего пакета: $endDate ($daysRemain дн.)'),
              const Divider(),
              //Text('Пароль:\n$password'),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                children: [
                  Text('Автоматическая активация: ${auto ? 'Да' : 'Нет'}'),
                  CupertinoSwitch(
                      value: auto,
                      onChanged: (bool value) {
                        changeActivationFlagAPI(token: token, guid: guid)
                            .then((value) {
                          if (value != null) {
                            auto = value;
                            onEdit!();
                          } else {
                            printLog(lastApiErrorMessage);
                          }
                        });
                      }),
                ],
              ),
              const Divider(),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                children: [
                  Text(
                      'Родительский контроль: ${parentControl ? 'Да' : 'Нет'}'),
                  CupertinoSwitch(
                      value: parentControl,
                      onChanged: (bool value) {
                        changeParentAccessFlagAPI(token: token, guid: guid)
                            .then((value) {
                          if (value != null) {
                            parentControl = value;
                            printLog('parent control = $parentControl');
                            onEdit!();
                          } else {
                            printLog(lastApiErrorMessage);
                          }
                        });
                      }),
                ],
              ),
              ip == '' ? const SizedBox() : const Divider(),
              ip == '' ? const SizedBox() : Text('IP адрес: $ip'),
              //Text('Рабочий IP:\n${isRealIp? 'Да' : 'Нет'}'),
              //Text('Разрешенные тарифы:\n${tarifs.join(', ')}'),
              //Text('Разрешенные тарифы:\n${tarifs.join(', ')}'),
            ]),
      ),
    );
  }

  Widget connectionStatusWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 10.0)],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: daysRemain > 0 ? Colors.green : Colors.red,
          border: Border.all(color: Colors.black, width: 1.0)),
      child: Text(daysRemain > 0 ? ' Активно ' : ' Не активно '),
    );
  }
}
