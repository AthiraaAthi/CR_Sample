// 📁 notifications.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showRecordingNotification(String contactName) async {
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
    "$contactName's call is being recorded",
    'Tap to stop and save',
    platformDetails,
    payload: 'stop_recording',
  );
}

Future<void> stopAndSaveRecording() async {
  final dir = await getExternalStorageDirectory();
  if (dir == null) return;

  final folder = Directory('${dir.path}/CallRecordings');
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  final fileName = 'Recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  final file = File('${folder.path}/$fileName');

  // Replace with actual audio data in production
  await file.writeAsBytes([]);

  await flutterLocalNotificationsPlugin.cancel(0);

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
    'Saved to: $fileName',
    platformChannelSpecifics,
  );
}
