import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

callToSupportDialog(BuildContext context) {
  showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: const Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            //title: const Text('Звонок в техподдержку:'),
            content: Column(children: [
              const Text('Вы можете связаться с нами по телефонам:'),
              TextButton.icon(
                  onPressed: () {
                    callToNumber('+79780489664');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('+7(978)0489664')),
              //const SizedBox(height: 20),
              TextButton.icon(
                  onPressed: () {
                    callToNumber('+79780755900');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('+7(978)0755900')),
            ]));
      });
}

void callToNumber(String s) {
  launchUrlString('tel:$s');
}
