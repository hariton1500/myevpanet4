import 'package:flutter/material.dart';
import 'package:myevpanet4/Models/account.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.account});
  final Account account;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('ID: ${widget.account.id}'),
          ),
          body: Center(
            child: widget.account.accountWidgetFull(
              context,
              onEdit: () {},
            ),
          )),
    );
  }
}
