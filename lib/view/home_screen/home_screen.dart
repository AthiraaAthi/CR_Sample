import 'package:flutter/cupertino.dart';

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
              Container(
                height: 100,
                child: CupertinoButton.filled(
                  child: Text('Select Contacts to Auto-Record'),
                  onPressed: () => Navigator.pushNamed(context, '/contacts'),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: CupertinoButton.filled(
                  child: Text('Selected Contacts'),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/selectedContacts'),
                ),
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
