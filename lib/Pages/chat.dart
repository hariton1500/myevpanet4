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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.id}: чат с техподдержкой'),
      ),
      body: Chat(
          messages: messagesChat(widget.id),
          onSendPressed: (text) async {
            printLog('send ${text.text}');
            var result = await addSupportRequest(
                token: token, guid: widget.guid, message: text.text);
            var message = types.TextMessage(
                author: types.User(
                  id: widget.id.toString(),
                ),
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                text: text.text,
                createdAt: DateTime.now().millisecondsSinceEpoch);
            Map<String, dynamic> storeMessage = {
              'id': DateTime.now().millisecondsSinceEpoch,
              'date': DateTime.now().toString(),
              'text': text.text,
              'direction': widget.id.toString(),
              'author': 'EvpaNet'
            };
            if (result != null) {
              setState(() {
                messagesChat(widget.id).insert(0, message);
                (appState['messages'] as List<Map<String, dynamic>>)
                    .add(storeMessage);
              });
            } else {
              setState(() {
                messagesChat(widget.id).insert(
                    0,
                    message.copyWith(
                        text:
                            'Сообщение не доставлено. Повторите попытку позже'));
              });
            }
          },
          user: types.User(
            id: widget.id.toString(),
          ),
          l10n: const ChatL10nRu()),
    );
  }
}
