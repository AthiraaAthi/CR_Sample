import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CuperTile extends StatelessWidget {
  const CuperTile(
      {super.key, required this.title, this.subtitle, this.trailing});
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
