import 'package:flutter/material.dart';
import 'package:myevpanet4/Models/account.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.account, required this.guid});
  final Account account;
  final String guid;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    Account account = widget.account;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('ID: ${widget.account.id}'),
          ),
          body: Center(
            child: account.accountWidgetFull(
              context,
              onEdit: () {
                setState(() {});
              },
              guid: widget.guid
            ),
          )),
    );
  }
}
