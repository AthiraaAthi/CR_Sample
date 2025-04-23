import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    checkAndRequestContactsPermission();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Call Recorder')),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton.filled(
                child: Text('Select Contacts to Auto-Record'),
                onPressed: () => Navigator.pushNamed(context, '/contacts'),
              ),
              SizedBox(height: 20),
              CupertinoButton.filled(
                child: Text('View Recordings'),
                onPressed: () => Navigator.pushNamed(context, '/recordings'),
              ),
            ],
          ),
        ));
  }

  Future<void> checkAndRequestContactsPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      // Request permission if not granted
      await Permission.contacts.request();
    } else {
      //loadContacts(); // If permission is granted, load contacts
    }
  }

  Future<void> loadContacts() async {}
}
