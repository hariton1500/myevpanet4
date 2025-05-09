import 'package:flutter/material.dart';
import 'package:myevpanet4/Dialogs/sureask.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/Widgets/authwidget.dart';
import 'package:myevpanet4/globals.dart';

class AccountsSetupPage extends StatefulWidget {
  const AccountsSetupPage({super.key, required this.update});
  final VoidCallback update;

  @override
  State<AccountsSetupPage> createState() => _AccountsSetupPageState();
}

class _AccountsSetupPageState extends State<AccountsSetupPage> {
  @override
  Widget build(BuildContext context) {
    //print(appState);
    return Scaffold(
      appBar: AppBar(
        title: Text('Список учетных записей', style: Theme.of(context).textTheme.titleLarge,),
        actions: [
          IconButton(
              onPressed: () async {
                if (await areUSure(context,
                    'Вы уверены, что хотите удалить все учетные записи из списка?')) {
                  setState(() {
                    appState['accounts'] = {};
                    appState['guids'] = [];
                    clearLocalStorage();
                    widget.update();
                    Navigator.of(context).pop();
                    /*
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainPage()));*/
                  });
                }
              },
              icon: const Icon(Icons.delete_sweep)),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _listItem(index);
          },
          itemCount: accounts.length,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AuthWidget(
                        onSuccess: () {
                          widget.update();
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      )));}, label: const Text('Добавить учетные записи с другим номером'), icon: const Icon(Icons.add),),
      //floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _listItem(int index) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.titleHeight,
      minLeadingWidth: 40,
      leading: Text('ID:\n${accounts.values.toList()[index].id}'),
      title: Text(accounts.values.toList()[index].name),
      subtitle: Text(accounts.values.toList()[index].address),
      trailing: IconButton(
        onPressed: () async {
          if (await areUSure(context,
              'Вы уверены, что хотите удалить учетную запись ID: ${accounts.values.toList()[index].id} из списка?')) {
            setState(() {
              //Navigator.of(context).pop();
              String guidToRemove = accounts.keys.toList()[index];
              //accounts.remove(accounts.keys.toList()[index]);
              //appState['accounts'] = accounts;
              (appState['accounts'] as Map<String, Account>).remove(guidToRemove);
              //guids.remove(accounts.keys.toList()[index]);
              appState['guids'].remove(guidToRemove);
              saveAppState(guids: guids);
              widget.update();
            });
          }
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
