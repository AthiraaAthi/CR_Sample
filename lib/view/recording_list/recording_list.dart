import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

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
      child: Column(),
    );
  }
}
