import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Call Recorder')),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ));
  }
}
