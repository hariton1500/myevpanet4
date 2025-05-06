import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet4/Dialogs/calltosupport.dart';
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Helpers/messagesfuncs.dart';
import 'package:myevpanet4/Helpers/showscaffoldmessage.dart';
//import 'package:myevpanet4/Pages/accountpage.dart';
//import 'package:myevpanet4/Pages/accountpage2.dart';
import 'package:myevpanet4/Pages/accountpage3.dart';
import 'package:myevpanet4/Pages/accountseditpaget.dart';
import 'package:myevpanet4/Pages/chat.dart';
import 'package:myevpanet4/Pages/logs.dart';
import 'package:myevpanet4/globals.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.update});
  final VoidCallback update;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
    runAccountsLoading();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      printLog('A new onMessageOpenedApp event was published!');
      printLog('Message data: ${message.data}');
      printLog('Message notification: ${message.notification}');
    });
    //if flag new messages is true, then go to ChatPage
    Future.delayed(const Duration(seconds: 3), () async {
      printLog('[MainWidget] isNewMessage: $isNewMessage');
      if (isNewMessage) {
        appState['flagNewMessage'] = false;
        saveFlags();
        await loadMessages();
        //go to ChatPage where id is last message direction
        print(messages.last);
        int tmpId = int.parse(messages.last['direction']);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(id: tmpId, guid: accounts.keys.firstWhere((s) => accounts[s]?.id == tmpId))));
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      printLog(
          'onMessage:');
      printLog('Title:\n${message.notification?.title}\nBody:\n${message.notification?.body}');
      /*
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagesPage(message: message)));*/
      appState['messages'].add(convertFCMessageToMessage(message));
      saveMessages();
      //printLog('onMessage: ${messages.last}');
      showScaffoldMessage(
          message: message.notification!.body!, context: context);
      int tmpId = getIdFromMessageTitle(message.notification!.title!);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(id: tmpId, guid: accounts.keys.firstWhere((s) => accounts[s]?.id == tmpId))));
    });
  }

  @override
  Widget build(BuildContext context) {
    printLog(
        'MainWidget build:\nguids: ${guids.length}\naccounts loaded: ${accounts.length}');
    if (guids.isEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        //Navigator.of(context).pop();
        widget.update();
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return accounts.entries.length == 1
        ? AccountPage3(
            //account: accounts.entries.first.value,
            guid: accounts.entries.first.key,
            update: (acc) {
              setState(() {});
            },
          )
        : SafeArea(
            child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      callToSupportDialog(context);
                    },
                    icon: const Icon(Icons.call)),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AccountsSetupPage(
                                update: () async {
                                  printLog('AccountsSetupPage: update');
                                  printLog('accounts: $accounts');
                                  await runAccountsLoading();
                                  setState(() {});
                                },
                              )));
                    },
                    icon: const Icon(Icons.person_add))
              ],
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
                      children: accounts.entries
                          .map((e) => GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => AccountPage3(
                                              //account: e.value,
                                              guid: e.key,
                                              update: (acc) {
                                                setState(() {
                                                  //e = MapEntry(e.key, acc);
                                                  accounts[e.key] = acc;
                                                });
                                              },
                                            ))),
                                child: e.value.accountWidgetSmall(
                                    accounts.values.toList().indexOf(e.value) +
                                        3),
                              ))
                          .toList(),
                    ),
                  ),
          ));
  }

  Future<void> runAccountsLoading() async {
    int countL = 0, countR = 0;
    for (var guid in guids) {
      printLog('1. Load Accounts data from local storage');
      await loadAccountDataFromLocalStorage(guid: guid).then((acc) {
        if (acc != null) {
          printLog('adding account ${acc.show()}');
          countL++;
          setState(() {
            appState['accounts'][guid] = acc;
          });
        } else {
          printLog('Account data not found in local storage');
        }
      }, onError: (e) {
        printLog('Error while loading account data from local storage: $e');
        return null;
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
            //print(accounts);
          });
        } else {
          printLog(lastApiErrorMessage);
        }
      }, onError: (e) {
        printLog('Error while loading account data from API: $e');
        return null;
      });
    }
    printLog('Accounts loaded from API: $countR');
  }
}
