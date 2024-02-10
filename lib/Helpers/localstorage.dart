// functions to work with local storage
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> loadAppState() async {
  bool needReRegister = false;
  // load appState from local storage
  // appState = {'guids': [], 'accounts': {}, 'token': ''};
  await loadGuids();
  //await loadAccounts();
  var answer = await loadToken();
  if (answer) {
    needReRegister = true;
  }
  await loadMessages();
  await loadFlags();
  return needReRegister;
}

Future<void> clearLocalStorage() async {
  // clear local storage
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove('guids');
  sharedPreferences.remove('accounts');
  sharedPreferences.remove('messages');
}

Future loadGuids() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appState['guids'] = sharedPreferences.getStringList('guids') ?? [];
  printLog('Guids loaded from local storage: ${guids.length}');
}

Future<bool> loadToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appState['token'] = sharedPreferences.getString('token') ?? '';
  printLog('Token loaded from local storage: $token');
  //for web and apple
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  printLog('User granted permission: ${settings.authorizationStatus}');

  // check token from google
  //String tokenFromFCM = !kIsWeb? await FirebaseMessaging.instance.getToken() ?? '' : '';
  String tokenFromFCM = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BF9QLEnrCHTSZqCcDvSF8yC2R6QRBTRokoOWgCIENrEV5heqlZ7-7ypMsGfn9M1-ZjvWEKLBWV9DAGg9t6ZEW7Q') ??
      '';
  if (tokenFromFCM != appState['token']) {
    //FCM gave a new token to this app copy

    //saving old token
    sharedPreferences.setString('oldtoken', appState['token']);
    printLog('New token from FCM: $tokenFromFCM');
    appState['token'] = tokenFromFCM;
    //saving new token
    sharedPreferences.setString('token', tokenFromFCM);
    //need to make register to server again
    return true;
  }
  return false;
}

Future saveAppState(
    {List<String>? guids, MapEntry<String, Account>? accountEntry}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // save flags to local storage
  sharedPreferences.setBool('flag_new_message', false);
  // save appState to local storage
  if (guids != null) {
    sharedPreferences.setStringList('guids', guids);
  }
  if (accountEntry != null) {
    // save account to local storage
    String guid = accountEntry.key;
    Account acc = accountEntry.value;
    printLog('Account data saved to local storage: $guid = ${acc.show()}');
    // save account to local storage
    sharedPreferences.setString(guid, acc.toJson());
  }
}

Future saveAccountDataToLocalStorage(
    {required Account acc, required String guid}) async {
  // save account to local storage
  //String guid = acc.guid;
  printLog('Account data saved to local storage: $guid = ${acc.show()}');
  // save account to local storage
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(guid, acc.toJson());
}

Future<Account?> loadAccountDataFromLocalStorage({required String guid}) async {
  // load account data from local storage
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  printLog('Trying to load account data from local storage for guid: $guid');
  String accJsonString = sharedPreferences.getString(guid) ?? '';
  printLog('jsonString length: ${accJsonString.length}');
  if (accJsonString.isEmpty) {
    printLog('loading is empty. returning null');
    return null;
  }
  var decodedJson = jsonDecode(accJsonString);
  //print('Account data loaded from local storage: $decodedJson');
  if (decodedJson is Map<String, dynamic>) {
    Account acc = Account.fromJson(decodedJson);
    printLog('Account data loaded from local storage: ${acc.show()}');
    return acc;
  }
  printLog('loading failed. returning null');
  return null;
}

Future<void> saveMessages() async {
  if (messages.isNotEmpty) {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(
        'messages_storage', messages.map((e) => jsonEncode(e)).toList());
    printLog('messages saved to local storage: ${messages.length}');
  }
}

Future<void> loadMessages() async {
  printLog('loading messages from local storage');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<String> messagesJson =
      sharedPreferences.getStringList('messages_storage') ?? [];
  appState['messages'] = messagesJson.map((e) => jsonDecode(e)).toList();
  printLog('messages loaded from local storage: ${appState['messages']}');
}

Future<void> saveFlags() async {
  // save flag to show new message in chat page
  printLog('saving flag to show new message in chat page');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool('flag_new_message', true);
}

Future<void> loadFlags() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appState['flagNewMessage'] =
      sharedPreferences.getBool('flag_new_message') ?? false;
  printLog('flag_new_message loaded from local storage: $isNewMessage');
}
