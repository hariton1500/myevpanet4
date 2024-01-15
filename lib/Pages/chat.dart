import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:myevpanet4/Helpers/api.dart';
import 'package:myevpanet4/globals.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.id, required this.guid});
  final int id;
  final String guid;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //List<types.Message> _messages = [];
  final _user = types.User(
    id: id.toString(),
  );

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
          messages: messagesChat,
          onSendPressed: (text) async {
            printLog('send ${text.text}');
            var result = await addSupportRequest(
                token: token, guid: widget.guid, message: text.text);
            var message = types.TextMessage(
                author: _user,
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                text: text.text,
                createdAt: DateTime.now().millisecondsSinceEpoch);
            if (result != null) {
              setState(() {
                messagesChat.insert(0, message);
              });
            } else {
              setState(() {
                messagesChat.insert(
                    0,
                    message.copyWith(
                        text:
                            'Сообщение не доставлено. Повторите попытку позже'));
              });
            }
          },
          user: _user,
          l10n: const ChatL10nRu()),
    );
  }

  void loadMessages() async {
    List<types.Message> _messages = messages
        .map((e) => types.TextMessage(
            author: types.User(id: e['author']),
            id: (e['date'] as DateTime).millisecondsSinceEpoch.toString(),
            text: e['text'],
            createdAt: (e['date'] as DateTime).millisecondsSinceEpoch))
        .toList();
    setState(() {
      _messages;
    });
  }
}
