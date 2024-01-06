// functions to work with local storage

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myevpanet4/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future loadAppState() async {
  // load appState from local storage
  // appState = {'guids': [], 'accounts': [], 'token': ''};
  await loadGuids();
  await loadAccounts();
  await loadToken();
}

Future loadGuids() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appState['guids'] = sharedPreferences.getStringList('guids') ?? [];
}

Future loadAccounts() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<String> accsJsonStrings =
      sharedPreferences.getStringList('accounts') ?? [];
  for (var accJson in accsJsonStrings) {
    appState['accounts'].add(jsonDecode(accJson));
  }
}

Future loadToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appState['token'] = sharedPreferences.getString('token') ?? '';
  // check token from google
  String tokenFromFCM = await FirebaseMessaging.instance.getToken() ?? '';
  if (tokenFromFCM != appState['token']) {
    //FCM gave a new token to this app copy
    appState['token'] = tokenFromFCM;
  }
}

Future saveAppState(List<String>? guids) async {
  // save appState to local storage
  if (guids != null) {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('guids', guids);
  }
}
