import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final WarningLevel level;
  final String title;
  final String body;

  const WarningDialog(
      {super.key,
      required this.level,
      required this.title,
      required this.body});

  Widget _title(WarningLevel level) {
    late IconData icon;
    late Color color;

    switch (level) {
      case WarningLevel.info:
        icon = Icons.info_outline;
        color = Colors.blue;
        break;
      case WarningLevel.warning:
        icon = Icons.warning_amber_outlined;
        color = Colors.yellow;
        break;
      case WarningLevel.error:
        icon = Icons.error_outline;
        color = Colors.red;
        break;
    }
    return Icon(
      icon,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal:12, vertical: 16),
      title: Row(
        children: [
          _title(level),
          Text(title),
        ],
      ),
      children: [
        Text(body),
        const Divider(),
        SimpleDialogOption(
          child: const Text("OK"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

enum WarningLevel {
  info,
  warning,
  error,
}
