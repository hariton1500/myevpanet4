import 'package:flutter/material.dart';
import 'package:myevpanet4/globals.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  bool reverse = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs Page: ${logs.length} rows'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  reverse = !reverse;
                  logs.reversed;
                });
              },
              icon: const Icon(Icons.sort))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reverse
              ? logs.map((e) => Text('$e\n')).toList()
              : logs.reversed.map((e) => Text('$e\n')).toList(),
        ),
      ),
    );
  }
}
