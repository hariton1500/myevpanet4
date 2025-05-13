import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types show TextMessage, User;
import 'package:myevpanet4/Dialogs/availabletarifsinfo.dart';
import 'package:myevpanet4/Dialogs/info_with_ok.dart' show infoWithOk;
import 'package:myevpanet4/Dialogs/paymentsumm.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Helpers/showscaffoldmessage.dart' show showScaffoldMessage;
import 'package:myevpanet4/globals.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String get address {
    if (street.isEmpty) return '';
    return street +
        (house.isEmpty ? '' : ', д. $house') +
        (flat.isEmpty ? '' : ', кв. $flat');
  }

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

  Future<Account> reload({required String token, required String guid}) async {
    var account = await getAccountDataFromAPI(token: token, guid: guid);
    if (account != null) {
      saveAccountDataToLocalStorage(acc: account, guid: guid);
      return account;
    } else {
      return this;
    }
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

  @override
  String toString() {
    return show().toString();
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
          leading: Column(
            children: [
              Text(
                'ID:\n$id',
              ),
              Icon(Icons.circle,
                  color: daysRemain >= 0 ? Colors.green : Colors.red)
            ],
          ),
          title: Text(name),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tarifName),
              Text('Абонплата: $tarifSum руб.'),
              Text('Осталось дней: $daysRemain', style: TextStyle(color: daysRemain >= 3 ? Colors.green : (daysRemain <=0 ? Colors.red : Colors.orange))),
              Text('Адрес: $street, $house, $flat'),
            ],
          ),
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

  Widget connectionStatusWidget2(BuildContext context) {
    return Row(
      children: [
        const Text('Статус:'),
        const SizedBox(width: 8),
        Text(daysRemain > 0 ? ' Активно ' : ' Не активно ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: (daysRemain > 0 ? Colors.green : Colors.red), fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Account Information Card Widget
  Widget accountInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 8),
                Text(
                  'Информация',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('ФИО: $name'),
            Text('Адрес: $street, $house, $flat'),
            connectionStatusWidget2(context),
          ],
        ),
      ),
    );
  }

  // Tariff Information Card Widget
  Widget tariffInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_offer),
                const SizedBox(width: 8),
                Text(
                  'Текущий тариф',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Наименование тарифа: $tarifName'),
            Text('Стоимость тарифа: $tarifSum руб.'),
            Text(
                'Баланс: $balance руб.',
              style: TextStyle(
                color: balance < 0 ? Colors.red : null, fontWeight: FontWeight.bold
              ),
            ),
            if (debt > 0) Text('Задолженность: $debt руб.', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            if (daysRemain >= 0)
              Text(
                'Действует до: $endDate ($daysRemain дней)',
                style: TextStyle(
                  color: daysRemain < 7 ? Colors.red : null,
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showAvailableTariffs(context, this);
              },
              child: const Text('Доступные тарифы'),
            ),
          ],
        ),
      ),
    );
  }

  // Payments History Card Widget
  Widget paymentsAndHistoryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment),
                const SizedBox(width: 8),
                Text(
                  'Оплата',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                int? sum = await askSumm(context);
                if (sum != null && sum > 0) {
                  launchUrl(Uri.parse(
                      'https://billing.evpanet.com/api/robo/?id=$id&sum=$sum'));
                }
              },
              icon: const Icon(Icons.currency_ruble),
              label: const Text('Пополнить online Robokassa'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                launchUrl(Uri.parse(
                    'https://payberry.ru/pay/26?acc=$id'));
              },
              icon: const Icon(Icons.currency_ruble),
              label: const Text('Пополнить online Payberry'),
            ),
          ],
        ),
      ),
    );
  }

  // Settings Section Widget
  Widget settingsSection(BuildContext context, void Function(void Function()) update, List<dynamic>? filteredTarifs, String guid, void Function(Account) widgetUpdate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings),
                const SizedBox(width: 8),
                Text(
                  'Настройки',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!auto)
              ListTile(
                title: const Text('Выбор тарифа:'),
                trailing: DropdownButton<Map<String, dynamic>>(
                  value: filteredTarifs?.firstWhere(
                      (element) =>
                          element['sum'].toString() ==
                          tarifSum.toString(),
                      orElse: () => null),
                  disabledHint: const Text('Недостаточно средств'),
                  hint: const Text('Выберите тариф'),
                  items: filteredTarifs?.map((tariff) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: tariff,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(tariff['name']),
                          Text(
                            'Стоимость: ${tariff['sum']} руб.',
                            style: const TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (int.parse(value?['speed']) > 200000) {
                      addSupportRequest(
                              token: token,
                              guid: guid,
                              message:
                                  'Пожелание абонента перейти на пакет более 100 Мбит, отправленное из приложения')
                          .then((value) {
                        Map<String, dynamic> storeMessage = {
                          'id': DateTime.now()
                              .millisecondsSinceEpoch,
                          'date': DateTime.now().toString(),
                          'text':
                              'Пожелание абонента перейти на пакет более 100 Мбит',
                          'direction': id.toString(),
                          'author': id
                              .toString() //field for selecting the side of message in chat
                        };
                        var chatMessage = types.TextMessage(
                            author: types.User(
                              id: id.toString(),
                            ),
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            text:
                                'Хочу перейти на пакет более 100 Мбит',
                            createdAt: DateTime.now()
                                .millisecondsSinceEpoch);

                        if (value != null) {
                          update(() {
                            messagesChat(id)
                                .insert(0, chatMessage);
                            appState['messages'].add(storeMessage);
                          });
                          //save messages to local storage
                          saveMessages();
                        } else {
                          update(() {
                            messagesChat(id).insert(
                                0,
                                chatMessage.copyWith(
                                    text:
                                        'Сообщение c пожеланием перейти на тариф более 100 Мбит не доставлено. Повторите попытку позже'));
                          });
                        }
                      });
                      infoWithOk(
                          context,
                          const Text(
                              'Самостоятельно изменить тариф более 100 Мбит нельзя, поскольку, возможно, ваше оборудование не поддерживает эту скорость, а также, возможно, требуется внести изменения в ваше подключение с нашей стороны. Поэтому будет произведена проверка и с Вами свяжется оператор службы поддержки. Спасибо за обращение!'));
                    } else {
                      var result =
                          await updateTarifWithConfirmation(
                              context,
                              token,
                              value!['id'],
                              guid);
                      printLog(
                          '---------------$result===============');
                      if (result != null) {
                        showScaffoldMessage(
                            message: 'Тариф изменен!',
                            context: context);
                        Account? tempAcc =
                            await getAccountDataFromAPI(
                                token: token, guid: guid);
                        if (tempAcc != null) {
                          widgetUpdate(tempAcc);
                          update(() {
                            appState['accounts'][guid] =
                                tempAcc;
                          });

                          saveAccountDataToLocalStorage(
                              acc: this, guid: guid);
                        }
                      } else {
                        showScaffoldMessage(
                            message: 'Произошла ошибка!',
                            context: context);
                      }
                    }
                  },
                ),
              )
            else
              ListTile(
                  title: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Чтобы изменить тариф, надо выключить автопродление',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
            SwitchListTile(
              title: const Text('Автопродление'),
              value: auto,
              onChanged: (value) async {
                var result = await changeActivationFlagAPI(
                    token: token, guid: guid);
                update(() {
                  if (result != null) {
                    auto = result;
                  } else {
                    showScaffoldMessage(
                        message:
                            'Произошла ошибка. Попробуйте позже.',
                        context: context);
                  }
                });
              },
            ),
            SwitchListTile(
              title: const Text('Родительский контроль'),
              value: parentControl,
              onChanged: (value) async {
                var result = await changeParentAccessFlagAPI(
                    token: token, guid: guid);
                update(() {
                  if (result != null) {
                    parentControl = result;
                  } else {
                    showScaffoldMessage(
                        message:
                            'Произошла ошибка. Попробуйте позже.',
                        context: context);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget addDaysCard(BuildContext context, double daysToAdd, void Function(double) updateDaysState, String guid, void Function(Account) widgetUpdate) {
    return balance < priceOfDay ?
      Card(
        color: const Color.fromARGB(255, 238, 187, 187),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Недостаточно средств!', style: Theme.of(context).textTheme.titleMedium),
              const Text('На Вашем счету недостаточно средств для добавления дополнительных дней.'),
              Text('Минимальная сумма ${priceOfDay.toStringAsFixed(2)} руб.')
            ]
          ),
        )) :
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_box),
                  const SizedBox(width: 8),
                  Text(
                    'Добавление дней к пакету',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                children: [
                  const Text('Дополнительные дни:'),
                  Slider(
                    min: 0,
                    max: (balance ~/ priceOfDay).toDouble(),
                    value: daysToAdd,
                    divisions: balance ~/ priceOfDay,
                    onChanged: (value) {
                      updateDaysState(value);
                    },
                    label: daysToAdd.toInt().toString(),
                    secondaryTrackValue: daysToAdd,
                  )
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: daysToAdd == 0 ? null : () async {
                  var result = await addDays(
                      token: token, guid: guid, days: daysToAdd.toInt());
                  if (result != null) {
                    Account? tempAcc =
                        await getAccountDataFromAPI(
                            token: token, guid: guid);
                    if (tempAcc != null) {
                      widgetUpdate(tempAcc);
                      appState['accounts'][guid] = tempAcc;
                      saveAccountDataToLocalStorage(
                          acc: this, guid: guid);
                    }
                    updateDaysState(0);
                    showScaffoldMessage(
                        message: 'Дни добавлены!', context: context);
                  } else {
                    showScaffoldMessage(
                        message: 'Произошла ошибка. Попробуйте позже.',
                        context: context);
                  }
                },
                child: const Text('Добавить дни к текущему пакету'),
              ),
            ],
          ),
        ),
      );
  }
}
