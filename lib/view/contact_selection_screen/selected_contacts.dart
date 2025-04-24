import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedContactsScreen extends StatefulWidget {
  const SelectedContactsScreen({super.key});

  @override
  State<SelectedContactsScreen> createState() => _SelectedContactsScreenState();
}

class _SelectedContactsScreenState extends State<SelectedContactsScreen> {
  List<Contact> allContacts = [];
  List<String> selectedNumbers = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final numbers = prefs.getStringList('record_contacts') ?? [];

    if (await FlutterContacts.requestPermission()) {
      final fetchedContacts =
          await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        selectedNumbers = numbers;
        allContacts = fetchedContacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Selected Contacts'),
      ),
      child: selectedNumbers.isEmpty
          ? Center(
              child: Text(
                'No contacts selected for auto-recording.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              itemCount: selectedNumbers.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final number = selectedNumbers[index];
                final matchingContact = allContacts.firstWhere(
                  (contact) => contact.phones.any((phone) =>
                      phone.number.replaceAll(RegExp(r'\s|-'), '') ==
                      number.replaceAll(RegExp(r'\s|-'), '')),
                  orElse: () => Contact(),
                );
                final name = matchingContact.id != null
                    ? matchingContact.displayName
                    : number;

                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: CupertinoListTile(
                      title: Text(
                        name,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        number,
                        style: TextStyle(fontSize: 18),
                      ),
                    ));
              },
            ),
    );
  }
}
