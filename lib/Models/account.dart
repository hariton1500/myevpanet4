import 'dart:convert';

import 'package:flutter/material.dart';

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
}
