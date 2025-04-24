import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:call_recorder_sample/utils/image_constant/iamge_constant.dart';
import 'package:call_recorder_sample/view/contact_selection_screen/cuper_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

FlutterSoundRecorder _recorder = FlutterSoundRecorder();

Future<void> startRecording() async {
  await _recorder.openRecorder();
  final dir = await getExternalStorageDirectory();
  if (dir == null) return;

  final folder = Directory('${dir.path}/CallRecordings');
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  final fileName = 'Recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  final filePath = '${folder.path}/$fileName';

  await _recorder.startRecorder(toFile: filePath);
  showRecordingNotification(fileName);
}

Future<void> stopAndSaveRecording() async {
  String? filePath = await _recorder.stopRecorder();
  if (filePath == null) return;

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'recording_saved_channel',
    'Recording Saved',
    channelDescription: 'Notifies when a call recording has been saved',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    1,
    'Recording Saved',
    'Saved to: $filePath',
    platformChannelSpecifics,
  );
}

Future<void> showRecordingNotification(String fileName) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'recording_channel_id',
    'Recording Notifications',
    channelDescription: 'Shows recording status for ongoing calls',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
    autoCancel: false,
    onlyAlertOnce: true,
    playSound: false,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Recording in progress...',
    'Saving to: $fileName',
    platformDetails,
    payload: 'stop_recording',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        stopAndSaveRecording();
      }
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/contacts': (context) => ContactSelectionScreen(),
        '/recordings': (context) => RecordingListScreen(),
        '/selectedContacts': (context) => SelectedContactsScreen(),
      },
    );
  }
}
//HOMESCREEN
//import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
}

//RECORDINGLIST SCREEN
// import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

class RecordingListScreen extends StatefulWidget {
  const RecordingListScreen({super.key});

  @override
  State<RecordingListScreen> createState() => _RecordingListScreenState();
}

class _RecordingListScreenState extends State<RecordingListScreen> {
  List<FileSystemEntity> recordings = [];
  @override
  void initState() {
    super.initState();
    loadRecordings();
  }

  Future<void> loadRecordings() async {
    final dir = await getExternalStorageDirectory();
    final folder = Directory('${dir!.path}/CallRecordings');
    if (await folder.exists()) {
      setState(() {
        recordings = folder.listSync();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Recorded Calls')),
      child: recordings.isEmpty
          ? Center(child: Text('No recordings found.'))
          : ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) => GestureDetector(
                onLongPress: () async {
                  final file = File(recordings[index].path);
                  if (await file.exists()) {
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      text: 'Sharing a recorded call',
                    );
                  }
                },
                child: CupertinoListTile(
                  leading: Icon(CupertinoIcons.play_arrow_solid),
                  title: Text(recordings[index].path.split('/').last),
                  onTap: () async {
                    final player = AudioPlayer();
                    await player.play(DeviceFileSource(recordings[index].path));
                  },
                ),
              ),
            ),
    );
  }
}

///CONTACT SELECTION SCREEN

// import 'dart:io';

// import 'package:call_recorder_sample/utils/image_constant/iamge_constant.dart';
// import 'package:call_recorder_sample/view/contact_selection_screen/cuper_tile.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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
    if (!await Permission.contacts.request().isGranted) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Permission Required'),
          content: Text(
              'Please allow contact permission to proceed with recordings.'),
          actions: [
            CupertinoDialogAction(
              child: Text('Go to Settings'),
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }
    if (!await Permission.storage.request().isGranted) {
      await Permission.storage.request();
    }
    loadContacts();
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
                  return CuperTile(
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

//SELECTEDCONTACTS SCREEN

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
