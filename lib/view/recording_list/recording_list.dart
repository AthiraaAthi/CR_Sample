import 'dart:io';

import 'package:flutter/cupertino.dart';

class RecordingListScreen extends StatefulWidget {
  const RecordingListScreen({super.key});

  @override
  State<RecordingListScreen> createState() => _RecordingListScreenState();
}

class _RecordingListScreenState extends State<RecordingListScreen> {
  List<FileSystemEntity> recordings = [];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(),
    );
  }
}
