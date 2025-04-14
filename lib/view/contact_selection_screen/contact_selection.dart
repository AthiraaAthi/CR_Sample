import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:permission_handler/permission_handler.dart';

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
    if (status.isGranted) {}
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: Column());
  }
}
