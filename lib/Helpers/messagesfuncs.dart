import 'package:firebase_messaging/firebase_messaging.dart';

int getIdFromMessageTitle(String title) {
  int start = title.indexOf('(');
  int end = title.indexOf(')');
  String id = title.substring(start + 1, end);
  return int.tryParse(id) ?? 0;
}

Map<String, dynamic> convertFCMessageToMessage(RemoteMessage message) {
  return {
    'id': DateTime.now().millisecondsSinceEpoch,
    'date': DateTime.now().toString(),
    'text': message.notification?.body ?? '',
    'direction': getIdFromMessageTitle(message.notification?.title ?? '').toString(),
    'author': 'EvpaNet'
  };
}
