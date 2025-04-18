import 'package:flutter/cupertino.dart';

class CuperTile extends StatelessWidget {
  const CuperTile(
      {super.key, required this.title, this.subtitle, this.trailing});
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
