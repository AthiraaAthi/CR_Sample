import 'dart:io';

import 'package:call_recorder_sample/utils/image_constant/iamge_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';
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
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      loadContacts();
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Permission Required'),
          content: Text(
              'Please allow contact permission to proceed with recordings.'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
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
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('record_contacts', selectedNumbers.toList());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Select Contacts')),
        child: contacts.isEmpty
            ? FutureBuilder(
                future: Future.delayed(Duration(seconds: 3)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CupertinoActivityIndicator());
                  } else {
                    return Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(addContactIcon),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add contacts',
                          style: TextStyle(),
                        ),
                      ],
                    ));
                  }
                })
            : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  final number = contact.phones.isNotEmpty
                      ? contact.phones.first.number
                      : '';
                  final selected = selectedNumbers.contains(number);
                  return CupertinoListTile(
                    ////import cupertile//////////////
                    title: Text(contact.displayName),
                    subtitle: Text(number),
                    trailing: CupertinoSwitch(
                      value: selected,
                      onChanged: (_) => toggleSelection(number),
                    ),
                  );
                },
              ));
  }
}

///////edited contact selction bcoz of permission reject texts go check it/////////
Future<void> saveRecording(String fileName, List<int> audioBytes) async {
  final dir = await getExternalStorageDirectory();
  if (dir == null) return;
  final folder = Directory('${dir.path}/CallRecordings');
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }
  final file = File('${folder.path}/$fileName');
  await file.writeAsBytes(audioBytes);
  debugPrint('Recording saved to: ${file.path}');
}
