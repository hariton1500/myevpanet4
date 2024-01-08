import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Pages/accountpage.dart';
import 'package:myevpanet4/Pages/logs.dart';
import 'package:myevpanet4/Pages/messagespage.dart';
import 'package:myevpanet4/globals.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
    runAccountsLoading();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      printLog('onMessage: $message');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagesPage(message: message)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            //secret section to make appbar double tapable for getting to logs page
            onDoubleTap: () {
              magic++;
              if (magic >= 3) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const LogsPage()))
                    .then((value) {
                  magic = 0;
                });
              }
            },
            child: const Text('Мой EvpaNet')),
      ),
      body: accounts.isEmpty
          ? const Center(child: Text('Загрузка данных...'))
          : SingleChildScrollView(
              child: Column(
                children: accounts.values
                    .map((e) => GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AccountPage(account: e))),
                          child: e.accountWidgetSmall(
                              accounts.values.toList().indexOf(e) + 3),
                        ))
                    .toList(),
              ),
            ),
      /*bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.abc), label: 'label'),
        NavigationDestination(icon: Icon(Icons.abc), label: 'label')
      ]),
      persistentFooterButtons: [
        TextButton(onPressed: () {}, child: const Text('dat')),
        TextButton(onPressed: () {}, child: const Text('dat')),
        TextButton(onPressed: () {}, child: const Text('dat')),
        TextButton(onPressed: () {}, child: const Text('dat')),
      ],
      persistentFooterAlignment: AlignmentDirectional.topCenter,*/
      //bottomSheet: TextButton(onPressed: () {}, child: const Text('bottom')),
    ));
  }

  Future<void> runAccountsLoading() async {
    int countL = 0, countR = 0;
    for (var guid in guids) {
      // 1. Load Accounts data from local storage
      await loadAccountDataFromLocalStorage(guid: guid).then((acc) {
        if (acc != null) {
          printLog('adding account ${acc.show()}');
          countL++;
          setState(() {
            appState['accounts'][guid] = acc;
          });
        }
      });
    }
    printLog('Accounts loaded from local storage: $countL');
    for (var guid in guids) {
      // 2. Load Accounts data from API
      await getAccountDataFromAPI(guid: guid, token: token).then((acc) {
        if (acc != null) {
          countR++;
          printLog('Account data loaded from API: $guid = ${acc.show()}');
          //save account data to local storage
          saveAppState(accountEntry: MapEntry(guid, acc));
          setState(() {
            appState['accounts'][guid] = acc;
          });
        }
      });
    }
    printLog('Accounts loaded from API: $countR');
  }
}
