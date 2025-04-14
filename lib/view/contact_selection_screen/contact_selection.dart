import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactSelectionScreen extends StatefulWidget {
  const ContactSelectionScreen({super.key});

  @override
  State<ContactSelectionScreen> createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  List<Contact> contacts = [];
  Set<String> selectedNumbers = Set();
  @override
  void initState() {
    super.initState();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      loadContacts();
    }
    await Permission.storage.request();
  }

  Future<void> loadContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final allContacts =
          await FlutterContacts.getContacts(withProperties: true);
      setState(() => contacts = allContacts);
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList('record_contacts') ?? [];
      selectedNumbers = stored.toSet();
    }
  }

  Future<void> toggleSelection(String number) async {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else {
        selectedNumbers.add(number);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: Column());
  }
}
