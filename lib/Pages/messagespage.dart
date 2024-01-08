import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key, required this.message});
  final RemoteMessage message;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Сообщение'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message.notification!.title!),
            Text(widget.message.notification!.body!),
          ],
        ),
      ),
    );
  }
}
