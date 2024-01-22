import 'package:flutter/material.dart';
import 'package:myevpanet4/globals.dart';

class AccountsSetupPage extends StatefulWidget {
  const AccountsSetupPage({super.key});

  @override
  State<AccountsSetupPage> createState() => _AccountsSetupPageState();
}

class _AccountsSetupPageState extends State<AccountsSetupPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список учетных записей'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete_sweep))
        ],
      ),
      body: Center(
        child: AnimatedList(
          key: _listKey,
          itemBuilder: (context, index, animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: _listItem(index),
            );
          },
          initialItemCount: accounts.length,
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
          appState['accounts'].entries.toList().removeAt(index);
          _listKey.currentState
              ?.removeItem(index, (context, animation) => _listItem(index));
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
