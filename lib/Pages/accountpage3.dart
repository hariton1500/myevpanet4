import 'package:flutter/material.dart';
import 'package:myevpanet4/Dialogs/calltosupport.dart';
import 'package:myevpanet4/Models/account.dart';
import 'package:myevpanet4/Pages/chat.dart';
import 'package:myevpanet4/globals.dart';

class AccountPage3 extends StatefulWidget {
  const AccountPage3({
    super.key,
    required this.guid,
    required this.update,
  });
  final String guid;
  final void Function(Account acc) update;

  @override
  State<AccountPage3> createState() => _AccountPage3State();
}

class _AccountPage3State extends State<AccountPage3> {
  @override
  Widget build(BuildContext context) {
    print('AccountPage3 build');
    var account = accounts[widget.guid];
    List? filteredTarifs;
    try {
      filteredTarifs = account?.tarifs
          .where((element) =>
              int.parse(element['sum'].toString()) < account.balance)
          .toList();
    } catch (e) {
      printLog(e);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ID: ${account?.id}'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(id: account!.id, guid: widget.guid)));
              },
              icon: const Icon(Icons.message),
            ),
            IconButton(
              onPressed: () {
                callToSupportDialog(context);
              },
              icon: const Icon(Icons.call),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Information Card
                account!.accountInfoCard(context),
                const SizedBox(height: 16),

                // Tariff Information Card
                account.tariffInfoCard(context),
                const SizedBox(height: 16),

                // Payments
                account.paymentsAndHistoryCard(context),
                const SizedBox(height: 16),

                // Settings Section
                account.settingsSection(context, setState, filteredTarifs, widget.guid, widget.update),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
