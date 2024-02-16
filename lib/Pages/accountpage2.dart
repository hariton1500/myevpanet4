// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myevpanet4/Dialogs/availabletarifsinfo.dart';
import 'package:myevpanet4/Dialogs/calltosupport.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Helpers/showscaffoldmessage.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/Pages/chat.dart';
//import 'package:myevpanet4/Widgets/pays.dart';
import 'package:myevpanet4/globals.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage2 extends StatefulWidget {
  const AccountPage2(
      {super.key,
      //required this.account,
      required this.guid,
      required this.update});
  //final Account account;
  final String guid;
  final void Function(Account acc) update;

  @override
  State<AccountPage2> createState() => _AccountPage2State();
}

class _AccountPage2State extends State<AccountPage2> {
  @override
  Widget build(BuildContext context) {
    var account = accounts[widget.guid];
    List? filteredTarifs;
    try {
      filteredTarifs = account?.tarifs
          .where((element) =>
              int.parse(element['sum'].toString()) < account.balance)
          .toList();
    } catch (e) {
      printLog(e);
    }
    //print('filtered tarifs: $filteredTarifs');
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('ID: ${account?.id}'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(id: account!.id, guid: widget.guid)));
              },
              icon: const Icon(Icons.message)),
          IconButton(
              onPressed: () {
                callToSupportDialog(context);
              },
              icon: const Icon(Icons.call)),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Информация об абоненте',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('ФИО: ${account?.name}'),
                Text(
                    'Адрес: ${account?.street}, ${account?.house}, ${account?.flat}'),
                const SizedBox(height: 32),
                const Text(
                  'Информация о тарифе',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: [
                    Text('Абонентский счет: ${account?.balance} руб.'),
                    ElevatedButton.icon(
                        onPressed: () {
                          launchUrl(Uri.parse(
                              'https://payberry.ru/pay/26?acc=${account?.id}'));
                        },
                        icon: const Icon(Icons.currency_ruble),
                        label: const Text('Пополнить online')),
                  ],
                ),
                //payVariantsWidget(account!, context, widget.guid),
                Wrap(
                  children: [
                    Text('Текущий тариф: ${account?.tarifName}'),
                    IconButton(
                        onPressed: () {
                          showAvailableTariffs(context, account!);
                        },
                        icon: const Icon(Icons.info))
                  ],
                ),
                Text(
                    'Абонплата: ${account!.tarifSum} руб. (${(account.tarifSum / 30).toStringAsFixed(2)} руб. в сутки)'),
                if (account.daysRemain >= 0) ...[
                  Text(
                      'Дата окончания действия текущего пакета: ${account.endDate} (${account.daysRemain} дн.)')
                ],
                const SizedBox(height: 32),
                const Text(
                  'Информация о подключении',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    const Text('Статус подключения:'),
                    account.connectionStatusWidget(context),
                  ],
                ),
                Text('Дата подключения: ${account.endDate}'),
                const SizedBox(height: 32),
                const Text(
                  'Настройки',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                !account.auto
                    ? ListTile(
                        title: const Text('Выбор тарифа:'),
                        trailing: DropdownButton<Map<String, dynamic>>(
                          value: filteredTarifs?.firstWhere(
                              (element) =>
                                  element['sum'].toString() ==
                                  account.tarifSum.toString(),
                              orElse: () => null),
                          disabledHint: const Text('Не достаточно средств'),
                          hint: const Text('Выберите тариф'),
                          //need to filter tariffs with sum lower then abon have money
                          items: filteredTarifs?.map((tariff) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: tariff,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            //showConfirmationDialogChangeTariff(context, () {setState(() {account.tarifName = value?.values.first!;});});
                            //print('---------------\n$value\n===============');
                            var result = await updateTarifWithConfirmation(
                                context, token, value!['id'], widget.guid);
                            printLog(
                                '---------------\n$result\n===============');
                            if (result != null) {
                              showScaffoldMessage(
                                  message: 'Тариф успешно изменен',
                                  context: context);
                              Account? tempAcc = await getAccountDataFromAPI(
                                  token: token, guid: widget.guid);
                              if (tempAcc != null) {
                                widget.update(tempAcc);
                                setState(() {
                                  accounts[widget.guid] = tempAcc;
                                });

                                saveAccountDataToLocalStorage(
                                    acc: account, guid: widget.guid);
                              }
                            } else {
                              showScaffoldMessage(
                                  message: 'Ошибка изменения тарифа',
                                  context: context);
                            }
                          },
                        ),
                      )
                    : ListTile(
                        title: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Для возможности смены тарифа нужно отключить Автоматическую активацию пакета',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                SwitchListTile(
                  title: const Text('Автоматическая активация пакета'),
                  value: account.auto,
                  onChanged: (value) async {
                    var result = await changeActivationFlagAPI(
                        token: token, guid: widget.guid);
                    setState(() {
                      if (result != null) {
                        account.auto = result;
                      } else {
                        showScaffoldMessage(
                            message:
                                'Произошла ошибка. Повторите попытку позже.',
                            context: context);
                      }
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Родительский контроль'),
                  value: account.parentControl,
                  onChanged: (value) async {
                    var result = await changeParentAccessFlagAPI(
                        token: token, guid: widget.guid);
                    setState(() {
                      if (result != null) account.parentControl = result;
                    });
                  },
                ),
                //,
              ],
            ),
          )),
    ));
  }
}
