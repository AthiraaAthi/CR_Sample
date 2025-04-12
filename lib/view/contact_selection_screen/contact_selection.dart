import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';

class ContactSelectionScreen extends StatefulWidget {
  const ContactSelectionScreen({super.key});

  @override
  State<ContactSelectionScreen> createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: Column());
  }
}
