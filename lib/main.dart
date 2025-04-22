import 'dart:io';

import 'package:call_recorder_sample/view/contact_selection_screen/contact_selection.dart';
import 'package:call_recorder_sample/view/home_screen/home_screen.dart';
import 'package:call_recorder_sample/view/recording_list/recording_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> stopAndSaveRecording() async {
  final dir = await getExternalStorageDirectory();
  if (dir == null) return;
  final folder = Directory('${dir.path}/CallRecordings');
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }
  final fileName = 'Recording_${DateTime.now().millisecondsSinceEpoch}.aac';
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
        stopAndSaveRecording(); // Implement this function
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
      },
    );
  }
}
