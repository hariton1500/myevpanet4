import 'package:flutter/material.dart';
import 'package:myevpanet4/Widgets/authwidget.dart';
import 'package:myevpanet4/Widgets/mainwidget.dart';
import 'package:myevpanet4/globals.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return !isRegistered ? const AuthWidget() : const MainWidget();
  }
}
