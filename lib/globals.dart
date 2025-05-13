import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Models/account.dart';

int currentId = 0;
double priceOfDay = 25;

Map<String, dynamic> appState = {
  'guids': <String>[],
  'accounts': <String, Account>{},
  'token': '',
  'messages': <Map<String, dynamic>>[{}],
  'flagNewMessage': bool,
};

/*
messages format:
[
  {
    'date': DateTime,
    'id': int,
    'text': String,
    'direction': String,
    'author': String,
  }
]
*/

List<types.Message> messagesChat(int filterId) => messages
    .where((element) => element['direction'] == filterId.toString())
    .toList()
    .map((e) => types.TextMessage(
        author: types.User(id: e['author']),
        id: (DateTime.parse(e['date'])).millisecondsSinceEpoch.toString(),
        text: e['text'],
        createdAt: (DateTime.parse(e['date'])).millisecondsSinceEpoch))
    .toList();

bool get isRegistered =>
    appState['guids'] is List && appState['guids'].length > 0;

//Map<String, Account> get accounts => (appState['accounts'] is Map<String, Account>) ? appState['accounts'] : {};
Map<String, Account> get accounts =>
    Map<String, Account>.from(appState['accounts']);

List<String> get guids => List<String>.from(appState['guids']);

String get token => appState['token'];

List<Map<String, dynamic>> get messages =>
    List<Map<String, dynamic>>.from(appState['messages']);

int get id => currentId;

bool get isNewMessage => appState['flagNewMessage'];

String lastApiErrorMessage = '';

// logging system
int magic = 0;
List<String> logs = [];
printLog(Object o) {
  if (kDebugMode) {
    print('===${DateTime.now()}=========================');
    print(o);
  }
  logs.add('===${DateTime.now().toLocal()}=========================\n$o');
  saveLogs();
}
////////////////
