import 'package:flutter/material.dart';
import 'package:myevpanet4/Dialogs/changetariff.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/globals.dart';

class AccountPage2 extends StatefulWidget {
  const AccountPage2({super.key, required this.account, required this.guid});
  final Account account;
  final String guid;

  @override
  State<AccountPage2> createState() => _AccountPage2State();
}

class _AccountPage2State extends State<AccountPage2> {
  @override
  Widget build(BuildContext context) {
    Account account = widget.account;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Личный кабинет: ${widget.account.id}'),
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
                Text('ФИО: ${account.name}'),
                Text(
                    'Адрес: ${account.street}, ${account.house}, ${account.flat}'),
                const SizedBox(height: 32),
                const Text(
                  'Информация о тарифе',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Абонентский счет: ${account.balance} руб.'),
                Text('Текущий тариф: ${account.tarifName}'),
                Text(
                    'Абонплата: ${account.tarifSum} руб. (${(account.tarifSum / 30).toStringAsFixed(2)} руб. в сутки)'),
                if (account.daysRemain >= 0) ...[Text(
                    'Дата окончания действия текущего пакета: ${account.endDate} (${account.daysRemain} дн.)')],
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
                ListTile(
                  title: const Text('Выбор тарифа:'),
                  trailing: DropdownButton<Map<String, dynamic>>(
                    value: account.tarifs.firstWhere(
                        (element) =>
                            element['sum'].toString() ==
                            account.tarifSum.toString(),
                        orElse: () => null),
                    items: account.tarifs.map((tariff) {
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
                      var result = await updateTarifWithConfirmation(context, token, value!['id'], widget.guid);
                      print('---------------\n$result\n===============');
                      if (result != null) {
                        setState(() {
                          account.tarifName;
                        });
                      }
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text('Автоматическая активация пакета'),
                  value: account.auto,
                  onChanged: (value) async {
                    var result = await changeActivationFlagAPI(token: token, guid: widget.guid);
                    setState(() {
                      if (result != null) account.auto = result;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Родительский контроль'),
                  value: account.parentControl,
                  onChanged: (value) async {
                    var result = await changeParentAccessFlagAPI(token: token, guid: widget.guid);
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