import 'package:flutter/material.dart';
import 'package:gbte/widgets/dialog/warning_dialog.dart';

class InvalidFileDialog extends StatelessWidget {

  final String errorMessage;

  const InvalidFileDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return WarningDialog(level: WarningLevel.error, title: "Bad File!", body: "The file you have attempted to load is malformed, and cannot be loaded!\n(Error: $errorMessage)");
  }

}