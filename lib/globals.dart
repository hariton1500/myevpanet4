import 'package:flutter/foundation.dart';
import 'package:myevpanet4/Models/account.dart';

int currentId = 0;

Map<String, dynamic> appState = {
  'guids': <String>[],
  'accounts': <String, Account>{},
  'token': '',
  'messages': <Map<String, dynamic>>[]
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

bool get isRegistered =>
    appState['guids'] is List && appState['guids'].length > 0;

Map<String, Account> get accounts => appState['accounts'];

List<String> get guids => List<String>.from(appState['guids']);

String get token => appState['token'];

List<Map<String, dynamic>> get messages => appState['messages'];

int get id => currentId;

String lastApiErrorMessage = '';

// logging system
int magic = 0;
List<String> logs = [];
printLog(Object o) {
  if (kDebugMode) {
    print(o);
  }
  logs.add(o.toString());
}
////////////////
