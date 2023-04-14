import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final Widget title;
  final List<Widget> body;

  const YesNoDialog({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.addAll(body);
    children.addAll([
      const Divider(),
      SimpleDialogOption(
        child: const Text("Yes"),
        onPressed: () => Navigator.of(context).pop(true),
      ),
      SimpleDialogOption(
        child: const Text("No"),
        onPressed: () => Navigator.of(context).pop(false),
      ),
    ]);
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal:12, vertical: 16),
      title: title,
      children: children,
    );
  }
}
