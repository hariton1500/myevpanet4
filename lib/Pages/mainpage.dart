import 'package:flutter/material.dart';
import 'package:myevpanet4/Widgets/authwidget.dart';
import 'package:myevpanet4/Widgets/mainwidget.dart';
import 'package:myevpanet4/globals.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return !isRegistered
        ? AuthWidget(
            onSuccess: () {
              setState(() {});
            },
          )
        : const MainWidget();
  }
}
