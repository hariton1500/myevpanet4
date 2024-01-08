import 'package:flutter/material.dart';
import 'package:myevpanet4/globals.dart';

class AccountsListWidget extends StatelessWidget {
  const AccountsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: accounts.values
            .map((e) =>
                e.accountWidgetSmall(accounts.values.toList().indexOf(e)))
            .toList(),
      ),
    );
  }
}
