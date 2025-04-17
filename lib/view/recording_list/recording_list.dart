import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
                  )),
    );
  }
}
