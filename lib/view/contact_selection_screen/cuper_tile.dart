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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: subtitle,
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
