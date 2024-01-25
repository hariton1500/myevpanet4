import 'package:flutter/material.dart';
import 'package:myevpanet4/Dialogs/sureask.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
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
    print(appState);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список учетных записей'),
        actions: [
          IconButton(
              onPressed: () async {
                if (await areUSure(context,
                    'Вы уверены, что хотите удалить все учетные записи?')) {
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
              icon: const Icon(Icons.delete_sweep))
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
        onPressed: () {
          setState(() {
            appState['accounts'].entries.toList().removeAt(index);
            appState['guids'].removeAt(index);
            widget.update();
          });
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
