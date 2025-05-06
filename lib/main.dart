import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myevpanet4/Helpers/localstorage.dart';
import 'package:myevpanet4/Helpers/messagesfuncs.dart';
import 'package:myevpanet4/Pages/initloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myevpanet4/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await setupFlutterNotifications();
  //showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //loadLogs();
  printLog('[${DateTime.now()}]Handling a background message \nType:${message.messageType}\nData:${message.data}\nNotif.title:${message.notification?.title}\nNotif.body:${message.notification?.body}');
  //await loadMessages();
  printLog('loading messages from local storage');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<String> messagesJson =
      sharedPreferences.getStringList('messages_storage') ?? [];
  appState['messages'] = messagesJson.map((e) => jsonDecode(e)).toList();
  printLog('messages loaded from local storage: ${appState['messages']}');
  var decodedMessage = convertFCMessageToMessage(message);
  printLog('decodedMessage: $decodedMessage');
  appState['messages'].add(decodedMessage);
  //saveMessages();
  sharedPreferences.setStringList(
        'messages_storage', messages.map((e) => jsonEncode(e)).toList());
  saveFlags();
  saveLogs();
}

//correct issue with https certicates expirations
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // инициализируем запуск приложения
  WidgetsFlutterBinding.ensureInitialized();
  // инициализируем Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  /*
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!);
      },
      title: 'Мой EvpaNet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const InitLoading(),
    );
  }
}
