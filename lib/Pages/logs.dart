import 'package:flutter/material.dart';
import 'package:myevpanet4/globals.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs Page: ${logs.length} rows'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: logs.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }
}