// functions to work with local storage

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future loadAppState() async {
  // load appState from local storage
  // appState = {'guids': [], 'accounts': {}, 'token': ''};
  await loadGuids();
  //await loadAccounts();
  await loadToken();
}

Future loadGuids() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appState['guids'] = sharedPreferences.getStringList('guids') ?? [];
  printLog('Guids loaded from local storage: ${guids.length}');
}

/*
Future loadAccounts() async {
  int count = 0;
  for (var guid in guids) {
    loadAccountDataFromLocalStorage(guid: guid).then((value) {
      if (value != null) {
        appState['accounts'][guid] = value;
        count++;
      }
    });
  }
  print('Accounts loaded from local storage: $count');
}*/

Future loadToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appState['token'] = sharedPreferences.getString('token') ?? '';
  printLog('Token loaded from local storage: $token');
  // check token from google
  String tokenFromFCM = await FirebaseMessaging.instance.getToken() ?? '';
  if (tokenFromFCM != appState['token']) {
    //FCM gave a new token to this app copy
    //saving old token
    sharedPreferences.setString('oldtoken', appState['token']);
    printLog('New token from FCM: $tokenFromFCM');
    appState['token'] = tokenFromFCM;
    //saving new token
    sharedPreferences.setString('token', tokenFromFCM);
  }
}

Future saveAppState(
    {List<String>? guids, MapEntry<String, Account>? accountEntry}) async {
  // save appState to local storage
  if (guids != null) {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('guids', guids);
  }
  if (accountEntry != null) {
    // save account to local storage
    String guid = accountEntry.key;
    Account acc = accountEntry.value;
    printLog('Account data saved to local storage: $guid = ${acc.show()}');
    // save account to local storage
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(guid, acc.toJson());
  }
}

Future<Account?> loadAccountDataFromLocalStorage({required String guid}) async {
  // load account data from local storage
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  printLog('Trying to load account data from local storage for guid: $guid');
  String accJsonString = sharedPreferences.getString(guid) ?? '';
  var decodedJson = jsonDecode(accJsonString);
  //print('Account data loaded from local storage: $decodedJson');
  if (decodedJson is Map<String, dynamic>) {
    Account acc = Account.fromJson(decodedJson);
    printLog('Account data loaded from local storage: ${acc.show()}');
    return acc;
  }
  return null;
}
