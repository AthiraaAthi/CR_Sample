import 'dart:io';
import 'package:call_recorder_sample/view/contact_selection_screen/contact_selection.dart';
import 'package:call_recorder_sample/view/contact_selection_screen/selected_contacts.dart';
import 'package:call_recorder_sample/view/home_screen/home_screen.dart';
import 'package:call_recorder_sample/view/recording_list/recording_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialize FlutterSoundRecorder
FlutterSoundRecorder _recorder = FlutterSoundRecorder();

//1. FUNCTION TO GET SELECTED NUMBERS FROM SHARED PREFERENCES //////////
Future<List<String>> getSelectedNumbers() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('record_contacts') ?? [];
}

// 2. TESTING: SIMULATE INCOMING CALL USING SELECTED CONTACTS //////////
void listenForIncomingCalls() async {
  final selectedNumbers = await getSelectedNumbers();
  // Simulating an incoming call
  Future.delayed(Duration(seconds: 3), () async {
    String incomingNumber = ""; // Simulated number
    if (selectedNumbers.contains(incomingNumber)) {
      print("DEBUG: Number is in selected list. Starting recording...");
      await startRecording();
      showRecordingNotification("Recording call from $incomingNumber");
    } else {
      print("DEBUG: Number not in selected list. No recording.");
    }
  });
  Future.delayed(Duration(seconds: 10), () async {
    print("DEBUG: Ending call, stopping recording...");
    await stopAndSaveRecording();
  });
}

Future<void> startRecording() async {
  // Request permissions and open recorder
  await _recorder.openRecorder(); // Correct method for initializing recorder

  // Get the directory where we will save the recording
  final dir = await getExternalStorageDirectory();
  if (dir == null) return;

  final folder = Directory('${dir.path}/CallRecordings');
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  final fileName = 'Recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  final filePath = '${folder.path}/$fileName';

  // Start recording to the file
  await _recorder.startRecorder(toFile: filePath);

  // Show a notification that recording has started
  showRecordingNotification(fileName);
}

Future<void> stopAndSaveRecording() async {
  // Stop recording
  String? filePath = await _recorder.stopRecorder();

  if (filePath == null) return;

  // Show notification indicating recording is saved
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

  // Initialize the notification plugin
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
