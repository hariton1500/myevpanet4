import 'package:myevpanet4/Models/account.dart';

Map<String, dynamic> appState = {
  'guids': <String>[],
  'accounts': <String, Account>{},
  'token': ''
};

bool get isRegistered =>
    appState['guids'] is List && appState['guids'].length > 0;

Map<String, Account> get accounts => appState['accounts'];

List<String> get guids => List<String>.from(appState['guids']);

String get token => appState['token'];

String lastApiErrorMessage = '';
