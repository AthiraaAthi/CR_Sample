import 'package:call_recorder_sample/view/contact_selection_screen/contact_selection.dart';
import 'package:call_recorder_sample/view/home_screen/home_screen.dart';
import 'package:call_recorder_sample/view/recording_list/recording_list.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {},
    );
  }
}
