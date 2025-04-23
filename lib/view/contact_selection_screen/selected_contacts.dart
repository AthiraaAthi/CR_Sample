import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedContactsScreen extends StatefulWidget {
  const SelectedContactsScreen({super.key});

  @override
  State<SelectedContactsScreen> createState() => _SelectedContactsScreenState();
}

class _SelectedContactsScreenState extends State<SelectedContactsScreen> {
  List<String> selectedNumbers = [];

  @override
  void initState() {
    super.initState();
    loadSelectedContacts();
  }

  Future<void> loadSelectedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final numbers = prefs.getStringList('record_contacts') ?? [];
    setState(() {
      selectedNumbers = numbers;
    });
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: Text(
                    selectedNumbers[index],
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
    );
  }
}
